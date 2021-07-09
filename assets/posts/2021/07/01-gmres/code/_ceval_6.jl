# This file was generated, do not modify it. # hide
rng = StableRNG(9080)

n = 250
# a random matrix with some sparsity
A = 10 * randn(rng, n, n) .* rand(rng, n, n) .* (rand(rng, n, n) .> 0.3)
nz = sum(A .== 0)
sp = round(nz / (n * n) * 100)
println("Sparsity ≈ $sp%")

x = randn(rng, n)
b = A * x
x0 = randn(rng, n)

cases = Dict()
for dirs in (:rand, :grad, :krylov)
    cases[dirs] = itersolve(A, b, x0; niter=n, dirs=dirs)
end

figure(figsize=(8, 6))
for dirs in (:rand, :grad, :krylov)
    semilogy(cases[dirs][3], cases[dirs][2], label=dirs)
end

xlabel("Time elapsed [s]")
ylabel("Norm of the residuals")
legend()

savefig(joinpath(@OUTPUT, "comp_2.svg")) # hide
