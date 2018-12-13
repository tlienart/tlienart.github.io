using LinearAlgebra
using Random: seed!

function gs(A, nsteps)
   L = LowerTriangular(A)
   U = UpperTriangular(A)
   U -= Diagonal(diag(U))
   xk = zeros(size(A, 1))
   for i ∈ 1:nsteps
      xk = L\(b-U*xk)
   end
   xk
end

seed!(12345)

n = 35
A = randn(n, n)
A *= A' # make A positive definite
A += A' # make A symmetric
b = randn(n)
x = A\b # "exact" solution

for nsteps ∈ [10, 50, 100] * 1_000
   xgs = gs(A, nsteps)
   println("GS with $nsteps steps: -- $(norm(A*xgs-b))")
end
