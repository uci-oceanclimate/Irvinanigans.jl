using Oceananigans
using Random, Statistics

function initialize_shear_layer(Ri; L=10, H=10, Nx=64, Nz=64, output_writer=true)
    
    grid = RectilinearGrid(
        size=(Nx, Nz),
        x=(-H/2, H/2),
        z=(-L/2, L/2),
        topology=(Periodic, Flat, Bounded)
    )

    shear_flow(x, z, t) = tanh(z)
    U = BackgroundField(shear_flow)

    stratification(x, z, t, p) = p.h * p.Ri * tanh(z / p.h)
    B = BackgroundField(stratification, parameters=(Ri=Ri, h=1.25))

    model = NonhydrostaticModel(timestepper = :RungeKutta3,
                              advection = UpwindBiasedFifthOrder(),
                                   grid = grid,
                               coriolis = nothing,
                      background_fields = (u=U, b=B),
                                closure = ScalarDiffusivity(ν=5e-5, κ=5e-5),
                               buoyancy = BuoyancyTracer(),
                                tracers = (:b, :c))

    Δt = 0.2
    simulation = Simulation(model, Δt=Δt, stop_iteration=2500, verbose=true)

    @info "Setting initial conditions"
    
    u, v, w = model.velocities
    b = model.tracers.b
    B = Field(b + model.background_fields.tracers.b)
    c = model.tracers.c
    
    TKE = Field(Average(1/2 * (u^2 + w^2)))
    
    noise(x, z) = 1.e-4*randn()
    gaussian(x, z) = exp(-(z/0.5^2)^2)
    set!(model, u=noise, w=noise, b=noise, c=gaussian)

    global_attributes = Dict("Ri" => Ri)

    if output_writer
        simulation.output_writers[:state] = NetCDFOutputWriter(
            model, (u=u, w=w, b=b, B=B, c=c,),
            schedule = TimeInterval(3.0),
            filename =  string("../data/raw_output/shear_instability_state_Ri=",Ri,".nc"),
            global_attributes = global_attributes,
            overwrite_existing = true
        )
        
        simulation.output_writers[:averages] = NetCDFOutputWriter(
            model, (TKE=TKE,),
            schedule = TimeInterval(1.0),
            filename = string("../data/processed_output/shear_instability_TKE_Ri=",Ri,".nc"),
            global_attributes = global_attributes,
            overwrite_existing = true
        )
    end
        
    return simulation
end