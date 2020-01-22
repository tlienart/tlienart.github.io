@def hasmath = false
@def hascode = true
@def title = "Creating a package in Julia (pt. 2)"

# Creating a package in Julia (part 2)

In this part we briefly discuss how to synch your package with GitHub (the steps should be similar with GitLab) as well as Travis CI, Appveyor and CodeCov.
Just in case you're not familiar with those:

* Travis will run your tests in a Linux and Mac environment,
* AppVeyor in a Windows environment
* CodeCov will analyse the output of `Coverage.jl` which checks your [code coverage]()

## Telling GitHub, Travis, AppVeyor and CodeCov about your package

(This part follows the [previous part](/pub/julia/dev-pkg.html) where we created a package `Ex`)

* **github.com**:
  * create a new repository, the Julia convention is to name repositories with a `.jl` in the name, in our case: `Ex.jl`,
  * \ul{do not} add anything (`README`, `LICENSE` etc) for now.
* **travis-ci.org**:
  * Login to [Travis](https://travis-ci.org) with your GitHub credentials, click on the `+` button in the left-margin next to `My Repositories` and toggle `Ex.jl` from the list.
* **appveyor.com**:
  * Login to [AppVeyor](https://ci.appveyor.com/) with your GitHub credentials, click on "new project" and add `Ex.jl` from the list.
* **codecov.io**:
  * nothing to do.

## Configuration scripts for Travis and AppVeyor

In your `~/.julia/dev/Ex/` folder, you'll need to add files telling Travis and AppVeyor what to do with your repo.

### script for Travis

In your `Ex/` folder, add a file `.appveyor.yml` with the following content (more information [here](https://docs.travis-ci.com/user/languages/julia/)):

```yml
language: julia
os:
  - linux
julia:
  - 0.7
  - nightly
matrix:
  allow_failures:
    - julia: nightly
notifications:
  email: false
env:
   - PYTHON=""
after_success:
- julia -e 'using Pkg;
            Pkg.add("Coverage");
            using Coverage;
            Codecov.submit(Codecov.process_folder())'
```

### script for AppVeyor

In your `Ex/` folder, add a file `.appveyor.yml` with the following content (more information [here](https://github.com/JuliaCI/Appveyor.jl)):

```yml
environment:
  matrix:
  - julia_version: 0.7
  - julia_version: nightly

platform:
  - x86 # 32-bit
  - x64 # 64-bit

matrix:
   allow_failures:
   - julia_version: nightly

branches:
  only:
    - master

notifications:
  - provider: Email
    on_build_success: false
    on_build_failure: false
    on_build_status_changed: false

install:
  - ps: iex ((new-object net.webclient).DownloadString("https://raw.githubusercontent.com/JuliaCI/Appveyor.jl/version-1/bin/install.ps1"))

build_script:
  - echo "%JL_BUILD_SCRIPT%"
  - C:\julia\bin\julia -e "%JL_BUILD_SCRIPT%"

test_script:
  - echo "%JL_TEST_SCRIPT%"
  - C:\julia\bin\julia -e "%JL_TEST_SCRIPT%"
```

## Synchronising

The only thing left to do is to push everything on GitHub.
To do this, start by setting your local folder as a Git repository:

```bash
cd ~/.julia/dev/Ex
git init
git add .
git commit -m "First commit"
```

you can then link it to the new repository you have just created on GitHub:

```bash
git remote add origin https://github.com/tlienart/Ex.jl
```

and finally, push your local changes:

```bash
git push -u origin master
```

That first push will also trigger a build on Travis and AppVeyor.
Provided the build on Travis was successful, it will also send the coverage information to CodeCov.

## Readme and license

You'll want to add a `README.md` and a `LICENSE.md` file to your project which is a pretty straightforward thing to do.
For the license, most of Julia's projects tend to be [MIT licensed](https://choosealicense.com/licenses/mit/).

**Badges**: you may want to add badges reporting the status of the repository on your README.
To do so, copy the first few lines of [this README.md](https://raw.githubusercontent.com/tlienart/Ex.jl/master/README.md) file without forgetting to modify your username and project name.

This should show something like this:

@@center
@@github
| Linux/OSX | Windows | Coverage |
| :----: | :----: | :----: |
| [![Build Status](https://travis-ci.org/tlienart/PackageExample.jl.svg?branch=master)](https://travis-ci.org/tlienart/PackageExample.jl) | [![appveyor.com](https://ci.appveyor.com/api/projects/status/bm91o5a9jirvanjj?svg=true)](https://ci.appveyor.com/project/tlienart/ex-jl) | [![codecov.io](https://codecov.io/github/tlienart/PackageExample.jl/coverage.svg?branch=master)](https://codecov.io/github/tlienart/PackageExample.jl?branch=master) |
@@ @@
