# This file was generated, do not modify it. # hide
using StableRNGs
rng = StableRNG(512)

err(E) = println("Max error: ", round(maximum(abs.(E)), sigdigits=2))

n, m = 10, 5
A = randn(rng, n, m)
Q, R = gs(A)
err(Q' * Q - I)
err(Q * R - A)

n, m = 10, 20
A = randn(rng, n, m)
Q, R = gs(A)
err(Q' * Q - I)
err(Q * R - A)
