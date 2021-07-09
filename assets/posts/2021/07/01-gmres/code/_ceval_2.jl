# This file was generated, do not modify it. # hide
using LinearAlgebra, StableRNGs

function mgs!(Q::Matrix, R::Matrix, v::Vector, k::Int)
    n = length(v)
    Q[:, k] .= v
    for i = 1:k-1
        R[i, k] = dot(Q[:, k], Q[:, i])
        Q[:, k] .-= R[i, k] .* Q[:, i]
    end
    Q[:, k] = normalize(Q[:,k])
    R[k, k] = dot(v, Q[:, k])
    return
end

# simple check
begin
    rng = StableRNG(1234)
    n = 5
    A = randn(rng, n, n)
    Q = zeros(n, n)
    R = zeros(n, n)
    for k = 1:n
        mgs!(Q, R, A[:, k], k)
    end
    e1 = round(maximum(abs.(Q'*Q - I)), sigdigits=2)
    e2 = round(maximum(abs.(A - Q*R)), sigdigits=2)
    println("max entry in |Q'Q-I|: $e1")
    println("max entry in |A-QR|: $e2")
end
