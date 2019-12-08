# This file was generated, do not modify it. # hide
gᵢ = (Ut * (X_fat * xᵢ)) ./ Σ
g̃ᵢ = gᵢ ./ (Σ² .+ λ)

@show rᵢ ≈ (dot(g̃ᵢ, w) - yᵢ) / (1 - dot(g̃ᵢ, gᵢ))