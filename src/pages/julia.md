@def date = Dates.today()

# Julia notes

I've been using Julia since 2015 and like it a lot, primarily for two reasons:

* the types + multiple dispatch paradigm makes more sense to me than object-oriented programming, more generally I like the syntax,
* it's interpreted which helps to try out ideas quickly and yet code can be very fast.

## Using Julia

These are notes I keep on how to do stuff with Julia.

* [Creating a package in Julia](/pub/julia/dev-pkg.html): how to create a package from scratch using `Pkg`
* [Creating a package in Julia pt. 2](/pub/julia/dev-pkg2.html): how to synchronise your new package with GitHub, Travis etc.

## Projects in Julia

Some packages I have worked on, I may write notes on some of them in the future.

### Misc

* [`JuDoc.jl`](https://github.com/tlienart/JuDoc.jl), an experimental static site generator (SSG) which I use for this website (actively maintained).

### Research related

* [`PDSampler.jl`](https://github.com/alan-turing-institute/PDSampler.jl), a package I wrote while at the Alan Turing Institute for piecewise deterministic Monte Carlo samplers and accompanying our paper on [_using PDMC on restricted domains_](https://arxiv.org/abs/1701.04244) (infrequently maintained).
* [`EPBP.jl`](https://github.com/tlienart/EPBP.jl), a package accompanying our paper on [_expected particle belief propagation_](/assets/misc/pdf/epbp.pdf) (currently unmaintained).
* [`PosteriorServer.jl`](https://github.com/BigBayes/PosteriorServer), a package I contributed to for our paper on [_distributed Bayesian learning_](http://www.jmlr.org/papers/volume18/16-478/16-478.pdf) (currently unmaintained).
