@def hasmath = false
@def hascode = true
@def title = "Creating a package in Julia"

# Creating a package in Julia

This is a short guide as to how to start developing a package in Julia, it is not an official tutorial and so there may be better ways.
It has been written while using `Julia 1.0.1` on MacOS (but I expect the process to be identical on Linux and very similar on Windows 10).

## Creating the package on your computer

I prefer to have all the packages I'm developing in the same spot, it makes my life simpler, and this spot is `~/.julia/dev` where `~` is the path to my home folder.

Fire up Julia and `cd` to the right directory:

```julia-repl
julia> cd(expanduser("~/.julia/dev"))
```

Then enter the package mode with `]` and just use the `generate` command.

```julia-repl
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

This is extremely bare-bones with just two files:

1. `Project.toml` which contains information about the authors, name of the package, an identifier and the dependencies. While you can change the author(s) detail, don't change anything else for now.
1. `src/PackageExample.jl` the main module file of your package, this will be where all your methods are defined, exported etc. Currently it only contains a simple `greet()` function.


### Telling Julia about your new package

Once the folder has been generated, you need to tell Julia that there's a new package you care about and that you want to be able to write `using PackageExample` in the REPL in order to play with it.
To do this, simply write in Pkg mode:

```julia-repl
(v1.0) pkg> dev ~/.julia/dev/PackageExample/
 Resolving package versions...
  Updating `~/.julia/environments/v1.0/Project.toml`
  [80573836] + PackageExample v0.1.0 [`~/.julia/dev/PackageExample`]
  Updating `~/.julia/environments/v1.0/Manifest.toml`
  [80573836] + PackageExample v0.1.0 [`~/.julia/dev/PackageExample`]
```

You can now test that everything works by calling `using PackageExample` in Julia:

```julia-repl
julia> using PackageExample
[ Info: Precompiling PackageExample [80573836-e3e6-11e8-18aa-7378983e83b2]
julia> PackageExample.greet()
Hello world!
```
## Developing your package

### Adding tests

Let's add and export two basic functions in `src/PackageExample.jl`:

```julia
export foo, bar

foo(x::T, y::T) where T <: Real = x + y - 5
bar(z::Float64) = foo(sqrt(z), z)
```

To add tests, you should create a folder `test/` in the `PackageExample` folder and add a file `runtests.jl` (Julia convention).
That file may typically contain calls to other test files via `include(fname)`.
In our case there is only two functions to test so for instance we could write in `runtests.jl`:

```julia
using PackageExample, Test

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
(v1.0) pkg> test PackageExample
```

**Note**: you may have to do `] add Test` to add the `Test` package to your environment.

### Adding dependencies


### Syncing your with GitHub

Let's now put the package online on GitHub (the instructions should be pretty much identical for GitLab).

#### on Github.com

* create a new repository, the Julia convention is to name repositories with a `.jl` in the name, in our case: `PackageExample.jl`
* **do not** add anything (`README`, `LICENSE` etc) for now.

#### in your terminal

* set up your local folder as a git repository

```
cd ~/.julia/dev/PackageExample
git init
git add .
git commit -m "First commit"
```

* link it to the new repository you have created on GitHub

```
git remote add origin https://github.com/tlienart/PackageExample.jl
```

* push your local changes

```
git push -u origin master
```

### Travis and CodeCov

You'll want to add a `README.md` and a `LICENSE.md` file to your project which is pretty easy to do.
For the license, most of Julia's projects tend to be [MIT licensed](choose license).

**Travis**: login to [Travis](https://travis-ci.org) with your GitHub credentials, click on the `+` button in the left-margin next to `My Repositories` and toggle `PackageExample.jl` from the list.

You can then trigger a build manually for the first (and last) time by clicking on `More options > Trigger build` on the right of the screen.
The results will appear a while later, also on [CodeCov](https://codecov.io/gh/tlienart/PackageExample.jl) where you can also login via your GitHub credentials and inspect the coverage of your code.

**Badges**: you may want to add badges reporting the status of the repository on your README. 
To do so, copy the first few lines of [this README.md]() file without forgetting to modify your username.


This should show something like this:

@@ght
| Status | Coverage |
| :----: | :----: |
| [![Build Status](https://travis-ci.org/tlienart/PackageExample.jl.svg?branch=master)](https://travis-ci.org/tlienart/PackageExample.jl) | [![codecov.io](http://codecov.io/github/tlienart/PackageExample.jl/coverage.svg?branch=master)](http://codecov.io/github/tlienart/PackageExample.jl?branch=master) |
@@
