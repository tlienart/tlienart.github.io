# This file was generated, do not modify it. # hide
using LinearAlgebra

function gs(A::Matrix{T}; tol=1e-10) where T
    n, m = size(A)
    Q = zeros(n, n)
    R = zeros(n, m)
    c = 1
    for k = 1:m
        w = A[:, k]
        for i = 1:c-1
            R[i, k] = dot(A[:, k], Q[:, i])
            w .-= R[i, k] .* Q[:, i]            # w = a_k - ∑⟨a_k, q_i⟩q_i
        end
        η = norm(w)
        η < tol && continue                     # check if w ≈ 0
        Q[:, c] .= w ./ η
        R[c, k] = dot(A[:, k], Q[:, c])
        c += 1
    end
    p = c - 1
    return Q[:, 1:p], R[1:p, :]
end
