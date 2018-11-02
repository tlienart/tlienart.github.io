@def hasmath = false
@def hascode = true
@def title = "Creating a package in Julia"

# Creating a package in Julia

This is a short personal guide as to how to start developing a package in Julia, it is not an official tutorial and so there may be better ways to do this!

This has been written while using `Julia 1.0.1` and I'm using MacOS (but I expect the process to be identical on Linux and very similar on Windows 10).

## Creating the package on your computer

I prefer to have all the packages I'm developing in the same spot, it makes my life simpler, and this spot is `~/.julia/dev` where `~` is the path to my home folder.

Fire up Julia and `cd` to the right directory:

```julia
julia> cd(expanduser("~/.julia/dev"))
```

Then enter the package mode with `]` and just use the `generate` command.

```
(v1.0) pkg> generate PackageExample
Generating project PackageExample:
    PackageExample/Project.toml
    PackageExample/src/PackageExample.jl
```

This generates a folder in `~/.julia/dev` with the following simple structure

```
.
├── Project.toml
└── src
    └── PackageExample.jl
```

This is extremely bare-bones, in there you find essentially two files:

1. `Project.toml` which, will contain information about the authors, name of the package, an identifier and the dependencies,
1. `src/PackageExample.jl` the main module file of your package, this will be where all your methods are defined, exported etc, in most cases it will be a file with lots of `include("file.jl")` where functions are actually defined in order to avoid having one massively cluttered file. Currently it only contains a simple `greet()` function.


### Telling Julia about your new package

Once the folder is generated, you need to tell Julia that there's a new package you care about and that you want to be able to write `using PackageExample` in the REPL.
To do this, simply write in Pkg mode:

```julia
(1.0) pkg> dev ~/.julia/dev/PackageExample
Resolving package versions...
    Updating `~/.julia/environments/v1.0/Project.toml`
```


### Synching your new package with GitHub, Travis and CodeCov


## Developing your package

### Adding dependencies
