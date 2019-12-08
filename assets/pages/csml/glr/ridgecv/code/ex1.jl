# This file was generated, do not modify it. # hide
using LinearAlgebra

basic_ridge_solve(X, y, λ=1) = (X'X + λ*I) \ X'y

X_fat = randn(50, 500)
y_fat = randn(50)

λ = 1

# slow solve requiring the solution of a 500x500 system
β_fat = basic_ridge_solve(X_fat, y_fat, λ)