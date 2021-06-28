# This file was generated, do not modify it. # hide
rng = StableRNG(5511)

A = Float16.(rand(rng, 50, 50).^2)

Q, R = gs(A)
Qm, Rm = mgs(A)

err(Q' * Q - I)
err(Q * R - A)
err(Qm' * Qm - I)
err(Qm * Rm - A)
