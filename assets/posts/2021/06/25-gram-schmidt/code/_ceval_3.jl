# This file was generated, do not modify it. # hide
function mgs(A::Matrix{T}; tol=1e-10) where T
    n, m = size(A)
    Q = zeros(T, n, n)
    R = zeros(T, n, m)
    c = 1
    for k = 1:m
        w = A[:, k]
        for i = 1:c-1
            R[i, k] = dot(w, Q[:, i])           # the modification
            w .-= R[i, k] .* Q[:, i]            
        end
        η = norm(w)
        η < tol && continue
        Q[:, c] .= w ./ η
        R[c, k] = dot(A[:, k], Q[:, c])
        c += 1
    end
    p = c - 1
    return Q[:, 1:p], R[1:p, :]
end
