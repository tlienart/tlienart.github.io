# This file was generated, do not modify it. # hide
function itersolve(A::Matrix, b::Vector, x0::Vector;
                   niter::Int=10, dirs=:rand)
    start = time()
    n = size(A, 1)
    r0 = A * x0 - b

    # objects we'll use to store the results
    xk = copy(x0)
    rk = copy(r0)
    pk = zeros(n)
    Q = zeros(n, niter)
    Q̃ = zeros(n, niter)
    R = zeros(niter, niter)
    norm_rk = zeros(niter + 1)
    norm_rk[1] = norm(r0)
    times = zeros(niter+1)
    times[1] = time() - start

    @views for k = 1:niter
        # <O> Obtain a new direction pk
        if dirs == :rand
            pk = randn(n)
        elseif dirs == :krylov
            pk = rk
        elseif dirs == :grad
            pk = A' * rk
        end

        # <A> Orthog. of pk using MGS. We don't care about R[:, k] here,
        # it will be overwritten at the next step anyway
        mgs!(Q, R, pk, k)

        # <B> Orthog. of A*qk using MGS, we do care about R[:, k] here
        mgs!(Q̃, R, A*Q[:, k], k)

        # <C> Solving the least-square problem
        γk = -Q̃[:, 1:k]' * r0

        # <D> Solving the triangular problem
        βk = trisolve(R[1:k, 1:k], γk)

        # <E> Approximation + residuals
        xk .= x0 .+ Q[:, 1:k] * βk
        rk .= r0 .+ Q̃[:, 1:k] * γk

        norm_rk[k+1] = norm(rk)
        times[k+1] = time() - start
    end
    return xk, norm_rk, times
end

# quick check (n steps must lead to the correct solution)
begin
    rng = StableRNG(908)
    n = 5
    A = randn(rng, n, n)
    x = randn(rng, n)
    b = A * x

    x0 = randn(rng, n)
    _, nrk_random, _ = itersolve(A, b, x0; niter=n, dirs=:rand)
    norm_rn = round(nrk_random[end], sigdigits=2)
    println("‖Axn - b‖: $norm_rn (random)")

    _, nrk_krylov, _ = itersolve(A, b, x0; niter=n, dirs=:krylov)
    norm_rn = round(nrk_krylov[end], sigdigits=2)
    println("‖Axn - b‖: $norm_rn (krylov)")

    _, nrk_grad, _ = itersolve(A, b, x0; niter=n, dirs=:grad)
    norm_rn = round(nrk_grad[end], sigdigits=2)
    println("‖Axn - b‖: $norm_rn (grad)")
end
