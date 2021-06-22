# This file was generated, do not modify it. # hide
λ′ = 3

# naive route
β_fat′ = basic_ridge_solve(X_fat, y_fat, λ′)

# efficient route
w_fat′ = U'y_fat ./ (S .+ λ′)
β_fat′ ≈ X_fat' * (U * w_fat′)
