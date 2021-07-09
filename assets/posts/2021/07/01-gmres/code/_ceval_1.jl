# This file was generated, do not modify it. # hide
using StableRNGs, LinearAlgebra
rng = StableRNG(111)

n = 5
A = rand(rng, n, n)
b = rand(rng, n)

Q, R = qr(A)
x = zero(b)
b̃ = Q' * b
for k = n:-1:1
    w = b̃[k]
    for i = 1:n-k
        w -= R[k, k+i] * x[k+i]
    end
    x[k] = w / R[k, k]
end

e = round(norm(A * x - b), sigdigits=2)
println("‖Ax-b‖ = $e")
