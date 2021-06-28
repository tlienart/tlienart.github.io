+++
title = "Mirror descent algorithm"
descr = """
    The Generalised Projected Gradient Descent (GPGD) and the Mirror Descent Algorithm (MDA).
    """
tags = ["optimisation", "projected gradient descent", "mirror descent"]
+++

{{redirect /pub/csml/cvxopt/mda.html}}

# Mirror descent algorithm

{{page_tags}}

\toc

## From Euclidean to arbitrary projections

In the notes on the [projected gradient descent](\cvx{pgd.html}) (PGD) we showed that a way to solve the constrained minimisation problem with a differentiable $f$ is to follow the iteration

$$ x_{k+1} \speq \pi_C(x_k - \alpha_k \nabla f(x_k)), $$

where $\pi_C$ denotes the Euclidean projection onto $C$.
By definition of the Euclidean projection, this can also be written as

\eqal{
        x_{k+1} \esp&=\esp \arg\min_{x\in C}\,\, \|(x_k-\alpha_k\nabla f(x_k))-x\|_2^2 \\
        &=\esp \arg\min_{x\in C} \,\,\| (x-x_k) + \alpha_k\nabla f(x_k)\|_2^2.
} <!--_-->

Now, since the $\ell^2$-norm is induced by the inner product (i.e. $\scal{x, x} = \|x\|_2^2$), we can use the decomposition

$$ \|(x-x_k) + \alpha_k\nabla f(x_k)\|_2^2 \speq \|x-x_k\|_2^2 + 2\alpha_k\scal{x, \nabla f(x_k)} + M_k, $$ <!--_-->

where $M_k$ does not depend on $x$ (and can thus be ignored).
Rearranging terms, we're then left with the equivalent iteration:

$$ x_{k+1} \speq \arg\min_{x\in C}\,\, \left\{\scal{x, \nabla f(x_k)} + {1\over \alpha_k} {\|x-x_k\|_2^2\over 2}\right\}. $$ <!--_-->

This new way of writing the PGD allows two important comments:

1. the objective shows how the PGD corresponds to a tradeoff between following the direction of the negative gradient (first term) and not moving too much from the current point (second term) while staying in $C$,
2. the second term is an isotropic measure of distance from the current point $x_k$, but what if we used another measure of distance?

The first point might be obvious to you if you're already seen the gradient descent and related methods but it's actually a bit deeper than what it may seems on a cursory glance, I discuss this more in [thoughts on first order methods](\cvx{fom.html}).

The second point gives the _generalised projected gradient descent_.

@@colbox-blue
The *generalised projected gradient descent* (GPGD) is defined for any positive-definite function $d:\R^n\times\R^n\mapsto\R^+$ by the following iteration:
$$ x_{k+1} \speq \arg\min_{x\in C}\,\, \left\{\scal{x, \nabla f(x_k)} + {1\over \alpha_k} d(x, x_k)\right\}. \label{gpgd}$$
@@

Those positive-definite functions are sometimes called *divergences* and verify $d(u, v)>0$ for $u\neq v$ and $d(u, u)=0$.

One reason why one might want to consider another distance-like function to penalise how much we move in a particular direction is that doing so can better reflect what we may know about the geometry of $C$ which can make steps easier to compute or accelerate convergence to a minimiser.

For a given divergence, there now remains to compute the corresponding iteration steps which may be intractable depending on $d$.
But there happens to be a popular class of divergences for which it _is_ tractable and which [we have already discussed](\cvx{ca3.html}): the Bregman divergences.

## Bregman divergences and the mirror descent algorithm

Recall that for a _strictly convex_ and differentiable function $\psi$, we can define the _Bregman divergence_ associated with $\psi$ as a positive-definite function $B_\psi$ with

$$ B_\psi(x, y) \spe{:=} \psi(x)-\psi(y)-\scal{x - y, \nabla \psi(y)}. $$

Let us now consider a $\mu$-_strongly convex_ and differentiable function $\varphi$ and the associated Bregman divergence $B_\varphi$.
If we use this as divergence in \eqref{gpgd}, the GPGD iteration is

$$ x_{k+1} \spe{\in} \arg \min_{x\in C} \,\,\left\{ \scal{x, \nabla f(x_k)} + {1\over \alpha_k}B_\varphi(x, x_k)\right\} $$

for $\alpha_k>0$.
It's straightforward to take the subgradient of the objective and write the FOC for one step:

$$ 0 \spe{\in} \alpha_k\nabla f(x_k) + \nabla \varphi(x_{k+1}) - \nabla \varphi (x_k) + N_C(x_{k+1}), $$

which, after rearranging terms, reads

$$ x_{k+1} \spe{\in} (\nabla\varphi + N_C)^{-1} (\nabla \varphi(x_k) - \alpha_k \nabla f(x_k)).$$

To complete this, observe that $(\nabla \varphi + N_C) \equiv \partial (\varphi + i_C)$ so that letting $\phi \equiv \varphi + i_C$, and using that for $h\in \Gamma_0$, $(\partial h)^{-1}\equiv\partial h^\star$ (cf. [convex analysis part 2](\cvx{ca2.html})), we end up with the _mirror descent algorithm_.

@@colbox-blue
The _mirror descent algorithm_ (**MDA**) is the iteration
$$ x_{k+1} \speq \nabla\phi^\star (\nabla \varphi(x_k) - \alpha_k\nabla f(x_k)) $$
where $\phi^\star(y) = \sup_{z\in C}[\scal{z,y}-\varphi(z)]$.
@@

Note that $\phi$ is also strongly convex on $C$ so that it is differentiable which is why we can write $\nabla \phi^\star$ (its gradient is even Lipschitz as we showed in [convex analysis part 3](\cvx{ca3.html})).

A final note is that, as for the PGD, the differentiability of $f$ can be relaxed to sub-differentiability without much changes, the iteration is then $x_{k+1}=\nabla\phi^\star(\nabla \varphi(x_k)-\alpha_k f'(x_k))$ with $f'(x_k)\in \partial f(x_k)$.

## References

 1. \biblabel{beck03}{Beck and Teboulle (2003)} **Beck** and **Teboulle**, [Mirror descent and nonlinear projected subgradient methods for convex optimization](https://web.iem.technion.ac.il/images/user-files/becka/papers/3.pdf), 2003. -- The paper behind the MDA, it also presents a convergence analysis and gives an example of application.
 1. \biblabel{nemirovski12}{Nemirovski (2012)} **Nemirovski**, [Tutorial: mirror descent algorithms for large-scale deterministic and stochastic convex optimization](https://www2.isye.gatech.edu/~nemirovs/COLT2012Tut.pdf), 2012. -- A deck of slides from a 2012 presentation, covering the MDA as well as applications.

 <!--
 https://stanford.edu/~jduchi/projects/DuchiShSiTe10.pdf
 -->
