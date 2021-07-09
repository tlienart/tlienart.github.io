# This file was generated, do not modify it. # hide
rng = StableRNG(90801)

K = 50
times = Dict(:rand=>[], :grad=>[], :krylov=>[], :gmres=>[])
N = collect(200:100:3_000)
for n in N
    A = randn(rng, n, n)
    x = randn(rng, n)
    b = A*x
    x0 = randn(rng, n)

    for dirs in (:rand, :grad, :krylov)
        start = time()
        itersolve(A, b, x0; niter=K, dirs=dirs)
        push!(times[dirs], time()-start)
    end
    start = time()
    gmres!(copy(x0), A, b, maxiter=K, restart=K+1)
    push!(times[:gmres], time()-start)
end

figure(figsize=(8, 6))
for dirs in (:rand, :grad, :krylov)
    plot(N, times[dirs], label=dirs)
end
plot(N, times[:gmres], label="gmres")
legend()

xlabel("Matrix size")
ylabel("Time taken [s]")

savefig(joinpath(@OUTPUT, "comp_3.svg")) # hide
