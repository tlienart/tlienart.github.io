@def date = Dates.today()

# Julia notes

I've been using Julia since 2015 and like it a lot, primarily for two reasons:

* the types + multiple dispatch paradigm makes more sense to me than object-oriented programming, more generally I like the syntax,
* it's interpreted which helps to try out ideas quickly and yet programs can be very fast.

<!-- ## Using Julia

These are notes I keep on how to do stuff with Julia. -->

<!-- * [Creating a package in Julia](/pub/julia/dev-pkg.html): how to create a package from scratch using `Pkg`
* [Creating a package in Julia pt. 2](/pub/julia/dev-pkg2.html): how to synchronise your new package with GitHub, Travis etc. -->

## Projects in Julia

A list of some of the packages I contribute(d) to.
I may write notes on some of them in the future.

### Misc.

* [`JuDoc.jl`](https://github.com/tlienart/JuDoc.jl), an experimental static site generator which I use for this website that allows using LaTeX-like syntax (\htmlcolor{gray}{ongoing development}).
* [`GPlot.jl`](https://github.com/tlienart/GPlot.jl), a prototype wrapper for the [Graphics Layout Engine](glx.sourceforge.net/index.html), a powerful engine for fast and publication-quality plots (\htmlcolor{gray}{ongoing development}).
* [`LiveServer.jl`](http://github.com/asprionj/LiveServer.jl) (with Jonas Asprion), a local web server with live-reload capacity inspired from [browser-sync](https://www.browsersync.io/) (\htmlcolor{gray}{actively maintained}).

### Stats/ML

* [`CovarianceEstimation.jl`](https://github.com/mateuszbaran/CovarianceEstimation.jl) (with Mateusz Baran), a package for robust covariance estimation (\htmlcolor{gray}{actively maintained}).
* [`MLJ.jl`](https://github.com/alan-turing-institute/MLJ.jl) (with Anthony Blaom and a team at the Alan Turing Institute), a Machine Learning toolbox (\htmlcolor{gray}{ongoing development}).

### Research

* [`PDSampler.jl`](https://github.com/alan-turing-institute/PDSampler.jl), a package I wrote while at the Alan Turing Institute for piecewise deterministic Monte Carlo samplers and accompanying our paper on [_using PDMC on restricted domains_](https://arxiv.org/abs/1701.04244) (\htmlcolor{gray}{infrequently maintained}).
* [`EPBP.jl`](https://github.com/tlienart/EPBP.jl), a package accompanying our paper on [_expected particle belief propagation_](/assets/misc/pdf/epbp.pdf) (\htmlcolor{gray}{currently unmaintained}).
* [`PosteriorServer.jl`](https://github.com/BigBayes/PosteriorServer), a package I contributed to for our paper on [_distributed Bayesian learning_](http://www.jmlr.org/papers/volume18/16-478/16-478.pdf) (\htmlcolor{gray}{currently unmaintained}).
