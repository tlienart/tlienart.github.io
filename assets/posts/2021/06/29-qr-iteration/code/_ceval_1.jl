# This file was generated, do not modify it. # hide
using LinearAlgebra, StableRNGs

function power_method(A::Symmetric, x0; iter=10)
    λ_max = eigmax(A)   # to show convergence
    w = copy(x0)
    Aw = zero(w)
    ρ = zero(eltype(w))
    for i = 1:iter
        Aw .= A * w
        ρ  = dot(Aw, w) / dot(w, w)
        w .= normalize(Aw)
        println("Step $i: ", round(abs((ρ - λ_max) ./ λ_max), sigdigits=2))
    end
    return w, ρ
end

rng = StableRNG(555)
n = 5
A = Symmetric(rand(rng, n, n))
c = randn(rng, n)

w, ρ = power_method(A, c)
err_eig = round(norm(A * w - ρ * w), sigdigits=2)
println("‖Aw - ρw‖: $err_eig")
