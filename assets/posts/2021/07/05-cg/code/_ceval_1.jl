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

function itersolve(A::Matrix, b::Vector, x0::Vector;
                   niter::Int=10, dirs=:rand, criterion=:minres)
    start = time()
    n = size(A, 1)
    r0 = A * x0 - b

    xk = copy(x0)
    rk = copy(r0)
    pk = zeros(n)
    Q = zeros(n, niter)
    Q̃ = zeros(n, niter)
    R = zeros(niter, niter)
    M = zeros(niter, niter)
    norm_rk = zeros(niter + 1)
    norm_rk[1] = norm(r0)
    times = zeros(niter+1)
    times[1] = time() - start

   #@views for k = 1:niter
   for k = 1:niter
       if dirs == :rand
           pk = randn(n)
       elseif dirs == :krylov
           pk = rk
       elseif dirs == :grad
           pk = A' * rk
       end
       mgs!(Q, R, pk, k)
       mgs!(Q̃, R, A*Q[:, k], k)

       if criterion == :minres
           γk = -Q̃[:, 1:k]' * r0
           βk = R[1:k, 1:k] \ γk
       elseif criterion == :fom
           # compute M = (Q'Q̃) iteratively
           if k > 1
               M[1:k-1, k] .= Q[:, 1:k-1]' * Q̃[:, k]
               M[k, 1:k-1] .= vec(Q[:, k]' * Q̃[:, 1:k-1])
           end
           M[k, k] = dot(Q[:, k], Q̃[:, k])
           # solve (Q'Q̃R)β ≈ (-Q'r0)
           βk = (M[1:k, 1:k] * R[1:k, 1:k]) \ (-Q[:, 1:k]' * r0)
       end
       xk .= x0 .+ Q[:, 1:k] * βk
       rk .= A * xk .- b
       norm_rk[k+1] = norm(rk)
       times[k+1] = time() - start
   end
   return xk, norm_rk, times
end
