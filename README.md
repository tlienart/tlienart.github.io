* [ ] abi
* [ ] glr
* [ ] linprog via convex conjugate
* [ ] add link to Krylov for projected gradient descent


## Cvx

* add example of MDA (e.g. with KL divergence)

## Mat

* use https://github.com/triscale-innov/GFlops.jl to count number of floating point ops and plot that to show how things scale

## Site

* group posts by "stories" (maybe change the part xxx and just add a number or whatever) (in tags)

## Future topics

* QN methods and (L)BFGS
* Kalman filter
* Nesterov (and related) accelerations
* LP and dual LP (and relation with convex conjugate)
* ABI, MAP
* generate correlation matrix: 

```julia
L = LowerTriangular(randn(5, 5))
D = Diagonal(1 ./ vec(sqrt.(sum(abs2, L, dims=2))))
C = D * L * L' * D
```

could be interesting to see whether that covers the space, maybe look at spectrum
