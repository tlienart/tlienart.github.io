# This file was generated, do not modify it. # hide
K = Symmetric(X_fat * X_fat')
F = svd(K)
U, Ut, S = F.V, F.Vt, F.S
Σ² = S
Σ  = sqrt.(S)

w  = (Ut * (K * y_fat)) ./ Σ
gᵢ = (Ut * (X_fat * xᵢ)) ./ Σ
g̃ᵢ = gᵢ ./ (Σ² .+ λ)

@show rᵢ ≈ (dot(g̃ᵢ, w) - yᵢ) / (1 - dot(g̃ᵢ, gᵢ))