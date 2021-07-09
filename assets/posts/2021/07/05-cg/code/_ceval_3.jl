# This file was generated, do not modify it. # hide
function conjgrad(A::Matrix, b::Vector, x0::Vector; niter=10)
    x = copy(x0)
    r = A * x .- b

    norm_rk    = zeros(niter+1)
    norm_rk[1] = norm(r)

    # We need to compute the first two steps
    # before starting to use the recurrence

    u1   = r
    Au1  = A * u1
    η1   = sqrt(dot(u1, Au1))
    u1  /= η1
    Au1 /= η1
    α    = -dot(r, u1)
    x  .+= α .* u1
    r  .+= α .* Au1

    norm_rk[2] = norm(r)

    u2  = r .- dot(r, Au1) .* u1
    Au2 = A * u2
    η2  = sqrt(dot(u2, Au2))
    u2  /= η2
    Au2 /= η2
    α    = -dot(r, u2)
    x  .+= α .* u2
    r  .+= α .* Au2

    norm_rk[3] = norm(r)

    u  = copy(u2)
    Au = copy(Au2)

    for k = 1:niter-2
        # Recurrence relation
        u   .= -(α * dot(Au2, Au1)) .* u1 .+ (η2 - dot(r, Au2)) .* u2 .+ (α .* Au2)
        Au  .= A * u
        η    = sqrt(dot(u, Au))
        u  ./= η
        Au ./= η

        α   = -dot(r, u)
        x .+= α .* u
        r .+= α .* Au

        η2    = η
        u1   .= u2
        Au1  .= Au2
        u2   .= u
        Au2  .= Au

        norm_rk[3+k] = norm(r)
    end
    return x, norm_rk
end
;#hide
