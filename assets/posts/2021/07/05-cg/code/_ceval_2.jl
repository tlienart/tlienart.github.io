# This file was generated, do not modify it. # hide
using PyPlot

rng = StableRNG(908)

n = 100
A = randn(rng, n, n)^2 .+ 5 * rand(rng, n, n)
x = randn(rng, n)
b = A * x
x0 = randn(rng, n)
r0 = A * x0 - b

figure(figsize=(8, 6))
for criterion in (:minres, :fom) # (:minres, :fom)
    for dirs in (:rand, :grad, :krylov)
        res = itersolve(A, b, x0; niter=n, dirs=dirs, criterion=criterion)
        semilogy(res[2], label="$(dirs)_$(criterion)")
    end
end
xlabel("Number of iterations")
ylabel("Norm of the residuals")
legend()

savefig(joinpath(@OUTPUT, "comp_1.svg")) # hide
