@def hasmath = false
@def hascode = true
@def title = "Creating a package in Julia"

# Creating a package in Julia

This is a short guide as to how to start developing a package in Julia, it is not an official tutorial and so there may be better ways.
It has been written while using `Julia 1.0.2` on MacOS (but I expect the process to be identical on Linux and very similar on Windows 10).

## Creating the package on your computer

I prefer to have all the packages I'm developing in the same spot, it makes my life simpler, and this spot is `~/.julia/dev` where `~` is the path to my home folder (you don't necessarily need to do this).

Fire up Julia and `cd` to the right directory:

```julia-repl
julia> cd(expanduser("~/.julia/dev"))
```

Then enter the package mode with `]` and just use the `generate` command.

```julia-repl
(v1.0) pkg> generate Ex
Generating project Ex:
    Ex/Project.toml
    Ex/src/Ex.jl
```

This generates a folder in `~/.julia/dev` with the following simple structure

```
.
├── Project.toml
└── src
    └── PackageExample.jl
```

1. `Project.toml` which contains information about the authors, name of the package, an identifier and the dependencies. While you can change the author(s) detail, don't change anything else for now.
1. `src/PackageExample.jl` the main module file of your package, this will be where all your methods are defined, exported etc. Currently it only contains a simple `greet()` function.

### Telling Julia about your new package

Once the folder has been generated, you need to tell Julia to consider a new environment where you will be developing the package.
To do this, you need to go from the "main" environment `(v1.0)` to your package's environment `(Ex)`.
While this may seem cumbersome, it allows to have distinct dependencies for different projects you may have without them clashing.

To activate the environment:

```julia-repl
shell> cd ~/.julia/Ex   # shell mode
(v1.0) pkg> activate .  # pkg mode
(Ex) pkg>
```

**Remark**: where to activate the Pkg mode you should use `]` at the start of a line in the REPL, to activate the shell mode you should use `;`.

If you now leave the Pkg mode, you can test that everything works:

```julia-repl
julia> using Ex
[ Info: Precompiling Ex [fe723aa2-...]
julia> Ex.greet()
Hello world!
```

**Note**: in the Pkg environment, if you want to go back to the "main" environment, just use `activate` without arguments.

```julia-repl
(Ex) pkg> activate
(v1.0) pkg>
```

## Developing your package

### Adding dependencies

In the `(Ex)` environment, you can now add any dependency you need without it clashing with your "main" julia environment.
Track of this will be kept in a `Manifest.toml` file.

All this is handled in the Pkg mode seamlessly.
For instance, you will almost certainly want to add the `Test` package to your project.

```julia-repl
(Ex) pkg> add Test
  Updating registry at `~/.julia/registries/General`
  Updating git-repo `https://github.com/JuliaRegistries/General.git`
 Resolving package versions...
  Updating `~/.julia/dev/Ex/Project.toml`
  [8dfed614] + Test
  Updating `~/.julia/dev/Ex/Manifest.toml`
  [2a0f44e3] + Base64
  [8ba89e20] + Distributed
  [b77e0a4c] + InteractiveUtils
  [8f399da3] + Libdl
  [37e2e46d] + LinearAlgebra
  [56ddb016] + Logging
  [d6f4376e] + Markdown
  [9a3f8284] + Random
  [9e88b42a] + Serialization
  [6462fe0b] + Sockets
  [8dfed614] + Test
```

Since it's the first time we add a dependency to the project, this also creates the `Manifest.toml` file.
Some of the things you will may want to do later

1. update the dependencies: `(Ex) pkg> update`
2. add a package at a specific stage: `(Ex) pkg> add Package#master`
3.

**Remark**: if some package you're interested in is not registered, you can just use the package URL.

### Adding tests

Let's add and export two basic functions in `src/Ex.jl`:

```julia
module Ex
export foo, bar

foo(x::T, y::T) where T <: Real = x + y - 5
bar(z::Float64) = foo(sqrt(z), z)
end
```

To add tests, you should create a folder `test/` in the `Ex` folder and add a file `runtests.jl` (Julia convention).
That file may typically contain calls to other test files via `include(fname)`.
In our case there is only two functions to test, so we will just write in `runtests.jl` directly:

```julia
using Ex, Test

@testset "foo" begin
    x, y = 5, 7
    @test foo(x, y) == 7
    x = "blah"
    @test_throws MethodError foo(x, y)
end

@testset "bar" begin
    z = 4.
    @test bar(z) == 1.
end
```

To test your package you can then just run `runtests.jl` or alternatively you can use the Pkg mode again:

```julia-repl
(Ex) pkg> test Ex
   Testing Ex
 Resolving package versions...
Test Summary: | Pass  Total
foo           |    2      2
Test Summary: | Pass  Total
bar           |    1      1
```

You're good to go!

If you'd like to know how to synchronise your new package with GitHub (or similar system), head to the [second part](/pub/julia/dev-pkg2.html).
