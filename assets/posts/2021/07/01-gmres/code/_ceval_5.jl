# This file was generated, do not modify it. # hide
using IterativeSolvers, PyPlot

rng = StableRNG(908)

n = 50
A = randn(rng, n, n)^4 .+ rand(rng, n, n)
x = randn(rng, n)
b = A * x
x0 = randn(rng, n)
r0 = A * x0 - b

κ = round(cond(A), sigdigits=2)
println("cond(A): $κ")

cases = Dict()
for dirs in (:rand, :grad, :krylov)
    cases[dirs] = itersolve(A, b, x0; niter=n, dirs=dirs)
end

# Using the IterativeSolvers
x_gmres, log_gmres = gmres!(copy(x0), A, b; maxiter=n, restart=n+1, log=true)

figure(figsize=(8, 6))
for dirs in (:rand, :grad, :krylov)
    plot(cases[dirs][2], label=dirs)
end
plot([norm(r0), log_gmres.data[:resnorm]...], label="gmres", ls="none", marker="x")

xlabel("Number of iterations")
ylabel("Norm of the residuals")

legend()

savefig(joinpath(@OUTPUT, "comp_1.svg")) # hide
