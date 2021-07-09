# This file was generated, do not modify it. # hide
function trisolve(R::Matrix, v::Vector)
    k = size(R, 1)
    β = zero(v)
    for j = k:-1:1
        β[j] = v[j]
        for i = 1:k-j
            β[j] -= R[j, j+i] * β[j+i]
        end
        β[j] /= R[j, j]
    end
    return β
end

# simple check
begin
    rng = StableRNG(414)
    m = 5
    R = randn(rng, m, m)
    for i=1:m, j=1:i-1
        R[i, j] = 0
    end
    β = randn(rng, m)
    v = R * β
    β̂ = trisolve(R, v)
    e = round(norm(β-β̂), sigdigits=2)
    println("‖β-β̂‖: $e")
end
