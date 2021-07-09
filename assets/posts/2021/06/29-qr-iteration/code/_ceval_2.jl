# This file was generated, do not modify it. # hide
using PyPlot

function francis_qr(A::Symmetric; iter=20)
    λ = sort(eigvals(A), by=abs, rev=true)   # to show convergence
    Q̃, R̃ = qr(A)
    Q = copy(Q̃)
    D = zero(Q)
    δ = zeros(iter)
    for i = 1:iter
        Q̃, R̃ = qr(R̃ * Q̃)    # step 1
        Q *= Q̃              # step 2
        # computations to show convergence
        D    = Q' * A * Q
        λ̂    = diag(D)
        δ[i] = maximum(abs.((λ̂ .- λ) ./ λ))
    end
    return Q, D, δ
end

rng = StableRNG(510)
n = 5
A = Symmetric(rand(rng, n, n))

Q, D, δ = francis_qr(A)

figure(figsize=(8, 6))
semilogy(δ, marker="x")
xlabel("Number of iterations")
ylabel("Maximum relative error")
xticks([1, 5, 10, 15, 20])
savefig(joinpath(@OUTPUT, "conv.svg")) # hide

Λ = Diagonal(D)

err_offdiag = round(maximum(abs.(D - Λ)), sigdigits=2)
println("|D-Λ|: $err_offdiag")

err_diag = round(maximum(abs.(A * Q - Q * Λ)), sigdigits=2)
println("|AQ-QΛ|: $err_diag")
