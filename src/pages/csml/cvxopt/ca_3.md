@def title = "Convex analysis III"

# Convex analysis (part 3)

## Strict and strong convexity <!-- ✅ 13/9/2018 -->

Remember that for a convex function $\psi:C\to \R$, the subdifferential at a point $x\in C^\circ$ is non-empty and for any subgradient $y\in\partial \psi(x)$, the following inequality holds:
\eqa{
    \psi(z) &\ge& \psi(x) + \scal{z-x, y}, \quad\forall z\in C.\label{subgrad ineq}
}
This simply means that the graph of the function is above its supporting hyperplanes. When that is strictly the case, the function is said to be strictly convex.

@@colbox-yellow
The function $\psi:C \to \R$ is said to be *strictly convex* at $x\in C^\circ$ if the inequality \eqref{subgrad ineq} holds *strictly* for all $z\neq x$.
@@

For example $\psi(x)=x\log(x)$ is strictly convex on $\R^+$ whereas $\psi(x)=|x|$ isn't.

### Bregman divergence <!-- ✅ 13/9/2018 -->

Let's consider the particular case where $\psi$ is strictly convex and differentiable so that $\partial \psi(x)=\{\nabla \psi(x)\}$.
In that case we have
\eqa{
    \psi(z) &\ge& f(x) + \scal{z-x, \nabla \psi(x)}, \quad \forall z\in C,\label{ineq subgrad diff}
}
with equality if and only if $z=x$.
We can use this to define a notion of similarity between two points $x$ and $z$.

@@colbox-yellow
Let $\psi$ denote a strictly convex and differentiable function on $C$. We define the *Bregman-divergence* on $C\times C$ associated with $\psi$ as
\eqa{B_\psi(z, x) &=& \psi(z)-\psi(x)-\scal{z-x,\nabla \psi(x)}.}
@@

Given \eqref{ineq subgrad diff}, we have that $B_\psi(z, x)>0$ for all $z\neq x$ and $B_\psi(z, x)=0$ iff $x=z$ so that $B_\psi$ is a *positive-definite* function(al).

For example, $\psi(x) = \frac12\scal{x, x}$ then
\eqal{
    B_\psi(z, x) \esp&=\esp \frac12\scal{z, z} - \frac12\scal{x, x} - \scal{z-x, x}\\
                 &=\esp \frac12\scal{z-x, z-x}
}
which is just the squared Euclidean ($\ell^{2}$) distance.The factor $1/2$ might seem irrelevant but it makes other developments a bit nicer so that, traditionally in convex-optimisation, the squared Euclidean distance is always scaled by a factor two.

### Strong convexity <!-- ✅ 13/9/2018 -->

@@colbox-yellow
The function $\varphi:C\to \R$ is said to be $\mu$-*strongly convex* at $x\in C^\circ$ with parameter $\mu>0$ if the subgradient inequality \eqref{subgrad ineq} holds with:

\eqa{
    \varphi(z) &\ge& \varphi(x) + \scal{z-x, y} + {\mu\over 2}\|z-x\|_2^2,
}
for any $z\in C$ and $y\in\partial \varphi(x)$.
@@

Intuitively, a strongly convex function is a strictly convex function whose graph goes away from the supporting hyperplane sufficiently fast (at least quadratically).

Note that if the function $\varphi$ is $\mu$-strongly convex and differentiable, then the Bregman divergence associated to it is lower bounded by the squared $\ell^{2}$-distance:

\eqa{
B_{\varphi}(z,x) &\ge& {\mu\over 2} {\|z-x\|^{2}_{2}}, \quad\forall x,z \in C.
\label{strong convex bregman}}

## Lipschitz continuity and strong convexity

This is a useful result to prove convergence rates of some iterative minimisation methods but can easily be skipped in a first reading.

First we recall that a function $\phi$ is $\beta$*-Lipschitz-continuous* if $\forall u,v\in \text{dom}\, \phi$ the following inequality holds:

\begin{eqnarray}
\|\phi(u)-\phi(v)\| &\le& \beta \|u-v\|.
\end{eqnarray}

We will show that if $\varphi:C\to \R$ is a differentiable, strongly convex function then $\nabla \varphi^\star$ is Lipschitz continuous.

Using \eqref{strong convex bregman}, we can write
\eqa{
    \mu \|x-z\|^{2}_{2} &\le& B_{\varphi}(x,z)+B_{\varphi}(z,x) .
}
for any $x, z\in C^\circ$.
Plugging the definition of the Bregman divergence in the right hand side and letting $u=\nabla \varphi(x)$ and $v=\nabla \varphi(z)$ we get
\eqa{
    \mu\| x-z\|^{2}_{2} &\le & \langle z-x, u-v \rangle \\
       &\le& \|x-z\|_2\|u-v\|_2,
}
using Cauchy-Schwartz's inequality.
Rearranging terms yields
\eqa{
    \|x-z\|_{2} &\le& {1\over \mu}\| u-v\|_2.
}

Since $x\in C^\circ$ and $u=\nabla \varphi(x)$, we can write $x = \nabla \varphi^\star(u)$ and similarly, $z=\nabla\varphi^\star(v)$ (see [convex analysis part 2](/pub/csml/cvx_opti/ca_2.html)).
This shows that the gradient $\nabla\varphi^\star$ is Lispchitz-continuous.

@@colbox-yellow
Let $\varphi:C\to\R$ be a differentiable, $\mu$-strongly convex function then $\varphi^\star$ has a gradient that is is $1/\mu$-Lipschitz continuous over $\nabla \varphi(C^\circ)$, i.e.:

\eqa{
    \| \nabla \varphi^\star(u)-\nabla \varphi^\star(v)  \| &\le& {1\over \mu}\|u-v\|,\quad \forall u,v\in\nabla\varphi(C^\circ),
}
where $\nabla \varphi (C^\circ)=\{u\in\R^n\,|\,u=\nabla \varphi(x),\, x\in C^\circ\}$.
@@

**Remark**: we often use $C^\circ$ instead of just $C$ to make the presentation simpler, indeed we know that on $C^\circ$ the subgradients exist and are bounded.
Of course these results can be generalised so that we don't have to deal with interiors everywhere but some care is needed to do it properly and the extra details are not particularly useful for this presentation.
We refer the interested reader to Rockafellar's book for more details.

## Bregman divergence and convex conjugacy

Let $\psi:C\to\R$ be a differentiable and strictly convex function and let's consider the Bregman divergence induced by $\psi^\star$:
\eqa{
    B_{\psi^\star}(u, v) &=& \psi^\star(u) - \psi^\star(v) - \scal{u-v, \nabla\psi^\star(v)}.\label{eq breg 1}
}
Let us now consider $u, v\in\R^n$ such that $u=\nabla \psi(x)$ and $v=\nabla\psi(z)$ for some $x, z\in C^\circ$.
We then have $\nabla^\star(\nabla \psi (z)) = z$ (cf. [convex analysis part 2](/pub/csml/cvxopt/ca_2.html)). Also, since $(x, \nabla \psi(x))$ is a dual pair, we have
\eqa{
    \psi(x) + \psi^\star(\nabla\psi(x)) &=& \scal{x, \nabla \psi(x)},
}
and the same for $z$.
Plugging this into \eqref{eq breg 1}, we obtain
\eqa{
    B_\psi^\star(\nabla\psi(x), \nabla\psi(y)) &=& \psi(z)-\psi(x)-\scal{z-x, \nabla \psi (x)}.
}
@@colbox-yellow
Let $\psi:C\to \R$ be a differentiable, strictly convex function. Then for $x, z \in C^\circ$ we have
\eqa{
    B_{\psi^\star}(\nabla \psi(x), \nabla\psi(z)) &=& B_\psi(z, x).
}
@@

Of course, by symmetry, we also have
\eqa{
    B_{\psi}(\nabla \psi^{\star}(u),\nabla\psi^{\star}(v)) &=& B_{\psi^{\star}}(u,v),
}
for any $u, v\in\nabla\psi(C)$.


## Short references

*See also the general references mentioned in the [introduction](/pub/csml/cvxopt/intro.html).*
