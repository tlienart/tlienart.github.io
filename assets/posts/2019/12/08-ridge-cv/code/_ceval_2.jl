# This file was generated, do not modify it. # hide
# SVD of a 50x50 system
F = svd(Symmetric(X_fat * X_fat'))
U, S = F.U, F.S
w_fat = U'y_fat ./ (S .+ λ)
β_fat ≈ X_fat' * (U * w_fat)
