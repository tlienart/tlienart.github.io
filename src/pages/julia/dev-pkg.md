@def hasmath = false
@def hascode = true
@def title = "Creating a package in Julia"

# Creating a package in Julia

This is a short guide as to how to start developing a package in Julia, it is not an official tutorial and so there may be better ways.
It has been written while using `Julia 1.1` on MacOS (but I expect the process to be identical on Linux and very similar on Windows 10).

**Note**: you may also want to consider [`PkgTemplates.jl`](https://github.com/invenia/PkgTemplates.jl), a package that helps you create new Julia packages.

## Creating the package on your computer

I prefer to have all the packages I'm developing in the same spot, it makes my life simpler, and this spot is `~/.julia/dev` where `~` is the path to my home folder (you don't necessarily need to do this).

Fire up Julia and `cd` to the right directory (press `;` to activate the shell mode)

```julia-repl
shell> cd ~/.julia/dev
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

Once the folder has been generated, you need to tell Julia about it.
To do this, in Pkg mode write:

```julia-repl
(v1.0) pkg> dev ~/.julia/dev/Ex
 Resolving package versions...
  Updating `~/.julia/environments/v1.0/Project.toml`
  [bd8551b6] + Ex v0.1.0 [`~/.julia/dev/Ex`]
  Updating `~/.julia/environments/v1.0/Manifest.toml`
  [bd8551b6] + Ex v0.1.0 [`~/.julia/dev/Ex`]
```

**Note**: if you wanted to work on a repository that is already on GitHub but not yet on your computer, you could also use `dev` and just specify the appropriate repository url as path.

You can now call your package:

```julia-repl
julia> using Ex
[ Info: Precompiling Ex [acebdc52-e6d5-...]
julia> Ex.greet()
Hello World!
```

## Developing your package

### Adding dependencies

In order to add dependencies and have them not clashing with the dependencies of other packages you may be developing, you need to enter the *environment* of `Ex` and add the relevant dependency there.
To do this, `cd` to the package folder, and `activate` it:

```julia-repl
shell> cd ~/.julia/dev/Ex
(v1.0) pkg> activate .
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

Here we added the package `Test` which will be needed for unit testing.
To leave the package-specific environment, just use `activate` again but without arguments:

```julia-repl
(Ex) pkg> activate
(v1.0) pkg>
```

**Remark**: a recent fix was added to Pkg so that you can do `(v1.0) pkg> dev ~/.julia/dev/Ex` instead of `cd` followed by `activate .`. This is not yet present in `1.0.2` but should be present in subsequent versions.

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

### Testing the package

To test your package you can then just run `runtests.jl` or alternatively you can use the Pkg mode again:

```julia-repl
(Ex) pkg> test
   Testing Ex
 Resolving package versions...
Test Summary: | Pass  Total
foo           |    2      2
Test Summary: | Pass  Total
bar           |    1      1
   Testing Ex tests passed
```

If you're back in the main environment, just apply `resolve` and then `test Ex`:

```julia-repl
(v1.0) pkg> resolve
 Resolving package versions...
  Updating `~/.julia/environments/v1.0/Project.toml`
 [no changes]
  Updating `~/.julia/environments/v1.0/Manifest.toml`
 [no changes]
(v1.0) pkg> test Ex
   Testing Ex
 Resolving package versions...
Test Summary: | Pass  Total
foo           |    2      2
Test Summary: | Pass  Total
bar           |    1      1
   Testing Ex tests passed
```

**Note**: you only need to call `resolve` if you've added new dependencies to the project (here we added `Test`).

If you'd like to know how to synchronise your new package with GitHub (or similar system), head to the [second part](/pub/julia/dev-pkg2.html).
