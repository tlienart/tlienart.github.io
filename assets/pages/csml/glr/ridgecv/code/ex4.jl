# This file was generated, do not modify it. # hide
using InvertedIndices
i = 5   # random index between 1 and n
λ = 2.5

X̃ᵢ = X_fat[Not(i),:]
ỹᵢ = y_fat[Not(i),:]
β̃ᵢ = basic_ridge_solve(X̃ᵢ, ỹᵢ, λ)

xᵢ = vec(X_fat[i,:])
yᵢ = y_fat[i]
rᵢ = dot(xᵢ, β̃ᵢ) - yᵢ # this the i-th LOO residual