# This file was generated, do not modify it. # hide
using IterativeSolvers

begin
    rng = StableRNG(111)

    # construct a simple SPD matrix
    n = 100
    A = randn(rng, n, n)
    A = A'A + 2I

    κA = round(cond(A), sigdigits=3)
    println("Condition number κ(A): $κA")

    x = randn(rng, n)
    b = A * x
    x0 = randn(rng, n)

    xcg, nrk = conjgrad(A, b, copy(x0); niter=n)
    res_krylov = itersolve(A, b, x0; niter=n, dirs=:krylov, criterion=:minres)
    res_grad = itersolve(A, b, x0; niter=n, dirs=:grad, criterion=:minres)
    res_fom_k = itersolve(A, b, x0; niter=n, dirs=:krylov, criterion=:fom)
    res_fom_g = itersolve(A, b, x0; niter=n, dirs=:grad, criterion=:fom)

    xcg, lcg = cg!(copy(x0), A, b; maxiter=n, log=true, reltol=0)
    ncg = [norm(A*x0-b), lcg.data[:resnorm]...]

    figure(figsize=(8, 6))
    semilogy(nrk, label="CG", marker="v")
    semilogy(res_krylov[2], label="GMRES (krylov)")
    semilogy(res_grad[2], label="GMRES (grad)")
    semilogy(res_fom_k[2], label="FOM (krylov)", linestyle="--")
    semilogy(res_fom_g[2], label="FOM (grad)", linestyle="--")
    semilogy(ncg, label="CG (IterativeSolvers)", marker="x")
    xlabel("Number of iterations")
    ylabel("Norm of the residuals")
    legend()
end
savefig(joinpath(@OUTPUT, "comp_cg.svg")) # hide
