@def title = "Convex analysis III"

# Convex analysis (part 3)

We add here a few more results of convex analysis which can be skipped in a first reading but to which we may refer in subsequent pages.
You will find here:

* the link between $\partial f$ and $\partial f^{\star}$,
* the link between *Lipschitz continuity* and strong convexity,
* the link between the Bregman divergence associated with a function and that of its convex conjugate.

**Note**: we use the shorthand $f\in\Gamma_0$ to denote $f\in\Gamma_0(\R^n)$.

## Strict and strong convexity

### Strict convexity and Bregman divergence

@@colbox-yellow
The function $\psi$ is said to be *strictly convex* at $x$ if the subgradient inequality \eqref{subgradient ineq} holds *strictly* for all $z\neq x$ i.e.:

\eqa{
    \psi(z) &>& \psi(x) + \langle z-x , y\rangle, \quad\forall z\neq x
}
where $y\in\partial \psi(x)$.
@@

Let us consider the particular case where $\psi$ is strictly convex and differentiable.
Recalling that a function $d: \R^n\times \R^n$ is said to be *positive-definite* if $d(u,u)=0$ and $d(u,v)>0$ for $u\neq v$, we can observe that we can use a strictly convex function to define a positive-definite function $B_{\psi}:\R^n\times \R^n\to \mathbb R^{+}$ as:

\eqa{
B_{\psi}(z,x) &:=& \psi(z)-\psi(x) - \langle z-x,\nabla \psi(x) \rangle
}

This equation actually characterises *Bregman divergences*, we will come back to those later in the notes.

### Strong convexity

@@colbox-yellow
The function $\varphi$ is said to be $\mu$-*strongly convex* with parameter $\mu>0$ if the subgradient inequality \eqref{subgradient ineq} holds with:

\eqa{
    \varphi(z) &\ge& \varphi(x) + \scal{z-x, y} + {\mu\over 2}\|z-x\|_2^2,
}
for any $z, x$ and $y\in\partial \varphi(x)$.
@@

Note that if the function is differentiable, then another characterisation of strong convexity is that the Bregman divergence associated to it is lower bounded by the squared Euclidean ($\ell^{2}$) distance:

\eqa{
B_{\varphi}(z,x) &\ge& {\mu\over 2} {\|z-x\|^{2}_{2}}, \quad\forall x,z.
}

The factor $1/2$ might seem irrelevant but makes other developments look nicer. For now, observe that if we take the derivative of the right-hand side, then we are left with $(x-y)$ without a spurious factor $2$.

## Lipschitz continuity and strong convexity

Let us first recall definitions: a function $\phi$ is $\beta$*-Lipschitz-continuous* if $\forall u,v\in \text{dom}\, \phi$ the following inequality holds:

\begin{eqnarray}
\|\phi(u)-\phi(v)\| &\le& \beta \|u-v\|.
\end{eqnarray}

A differentiable function $\varphi$ is $\mu$*-strongly convex* if $\forall u,v\in \text{dom}\,\varphi$ the following inequality holds:

\begin{eqnarray}
{\mu\over 2}\|u-v\|^{2}_{2} &\le& B_{\varphi}(u,v).
\end{eqnarray}

Of course such a function is also $\Gamma_0$.
Observe that the inequality must hold for all $u$ and $v$ so that, in particular, we can swap $u$ and $v$ and get

\begin{eqnarray}
\mu \|u-v\|^{2}_{2} &\le& B_{\varphi}(u,v)+B_{\varphi}(v,u) .
\end{eqnarray}

Now, recall that $B_{\varphi}(u,v):=\varphi(u)-\varphi(v)-\langle u-v, \nabla\varphi(u)\rangle$ so that if we let $y = \nabla\varphi(u)$ and $z=\nabla\varphi(v)$, then the previous inequality reads:

\eqa{
    \mu\| u-v\|^{2}_{2} &\le & \langle u-v, z-y \rangle \,\,\le\,\, \|u-v\|_2 \|y-z\|_2,
}

where for the last inequality, we used Cauchy-Schwartz's inequality. Rearranging terms yields

\eqa{
    \|u-v\|_{2} &\le& {1\over \mu}\| y-z\|_2.
}

Since $u=(\nabla \varphi)^{-1}(y)=\nabla\varphi^\star(y)$ and $v=(\nabla \varphi)^{-1}(z)=\nabla\varphi^\star(z)$ (by definition of $y$ and $z$ and since $\varphi\in\Gamma_0$) we get the following result.

@@colbox-yellow
Let $\varphi$ be a $\mu$-strongly convex function then $\varphi^\star$ has a  gradient that is is $1/\mu$-Lipschitz continuous, i.e.:

\eqa{
    \| \nabla \varphi^\star(y)-\nabla \varphi^\star(z)  \| &\le& {1\over \mu}\|y-z\|,\quad \forall y,z\in \text{dom}\,\nabla\varphi^\star.
}
@@


## Bregman divergence and convex conjugacy

**FIX THIS, DEFINE BD, USE DUAL PAIR**

Take $\psi\in\Gamma_{0}$, strictly convex and continuously differentiable, the Bregman divergence associated to it is

\eqa{
    B_{\psi}(x,y) &:=& \psi(x)-\psi(y)-\langle x-y,\nabla \psi(y)\rangle.
}

Recall that the convex conjugate is given by $\psi^{\star}(y):=\sup_{x}[\langle x,y \rangle - \psi(x) ]$ and assume that it is attained at a point $x^+$. We can then write

\begin{eqnarray}
    \psi^{\star}(y) &=& \langle x^{+},y\rangle - \psi (x^{+})
\end{eqnarray}

with $\nabla \psi(x^{+})=y$ by the FOC. We can thus write

\begin{eqnarray}
\psi^{\star}(\nabla \psi(x)) &=& \langle x,\nabla\psi (x)\rangle - \psi(x).
\end{eqnarray}

We can then consider the Bregman divergence associated to $\psi^{\star}$ and obtain

\begin{eqnarray}
B_{\psi^{\star}}(\nabla\psi(x),\nabla\psi(y)) &=& \psi(y)-\psi(x)-\langle x-y,\nabla\psi(x)\rangle \,\,=\,\, B_{\psi}(y,x).
\end{eqnarray}


<!-- ~~~ -->

We have thus shown that

\begin{eqnarray}
B_{\psi^{\star}}(\nabla\psi(x),\nabla\psi(y)) &=& B_{\psi}(y,x)
\end{eqnarray}

and, equivalently, $B_{\psi}(\nabla \psi^{\star}(\mu),\nabla\psi^{\star}(\nu))=B_{\psi^{\star}}(\nu,\mu)$.
<!-- ~~~ -->

## Short references

*See also the books mentioned in the introduction.*
