# Irvinanigans.jl

A (probably incomplete) set of instructions:

- Press the "Fork" button at the top of this Github page to create your own fork of this repository. Separately, in a UNIX terminal, use the change directory command (`cd`) in a UNIX terminal to go into whatever root directory you would like to download this repository into. Clone your fork of the repository with
```bash
git clone https://github.com/YOUR-GITHUB-USERNAME/Irvinanigans.jl.git
```

- Install [Julia v1.10.2](https://julialang.org/downloads/#current_stable_release) (may be under "Older Releases") and run the newly installed Julia program. This should launch a Julia "REPL" with the following command line prompt:
```julia
julia>
```

- Type `]` to transition from Julia's "REPL" mode to the "package manager" mode. Activate and build this repository's environment (a coordinated set of Julia software packages) with:
```
activate .
```
and then
```
build
```
Press the 'Delete' or 'Backspace' key to exit the package manager mode and return to the REPL mode.

- Import the IJulia package and launch an instance of the browser-based JupyterLab programming environment with:
```julia
using IJulia
jupyterlab(dir=pwd())
```
