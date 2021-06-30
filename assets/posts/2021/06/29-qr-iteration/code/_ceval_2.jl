# This file was generated, do not modify it. # hide
function francis_qr(A::Symmetric; iter=20)
    λ = sort(eigvals(A), by=abs, rev=true)   # to show convergence
    Q̃, R̃ = qr(A)
    Q = copy(Q̃)
    D = zero(Q)
    for i = 1:iter
        Q̃, R̃ = qr(R̃ * Q̃)    # step 1
        Q *= Q̃              # step 2
        # computations to show convergence
        D  = Q' * A * Q
        λ̂  = diag(D)
        δ  = round(maximum(abs.((λ̂ .- λ) ./ λ)), sigdigits=2)
        println("Step $i: $δ")
    end
    return Q, D
end

rng = StableRNG(510)
n = 5
A = Symmetric(rand(rng, n, n))

Q, D = francis_qr(A)
Λ = Diagonal(D)

err_offdiag = round(maximum(abs.(D - Λ)), sigdigits=2)
println("|D-Λ|: $err_offdiag")

err_diag = round(maximum(abs.(A * Q - Q * Λ)), sigdigits=2)
println("|AQ-QΛ|: $err_diag")
