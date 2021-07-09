+++
title = "Convex analysis &ndash; pt. III"
descr = """
    Strict and strong convexity, Bregman divergences, and the link between Lipschitz
    continuity and strong convexity.
    """
tags = ["optimisation"]
+++

{{redirect /pub/csml/cvxopt/ca3.html}}

<!--
NOTE:
last review 20/9/2018
-->

# Convex analysis (part III)

{{page_tags}}

\toc

## Strict and strong convexity

Remember that a function $\psi:C\to \R$ is convex if the following inequality holds for any two $x, z \in C$ and $0<\lambda<1$:
\eqa{
    \psi((1-\lambda)x+\lambda z) &\le & (1-\lambda)\psi(x) + \lambda \psi(z). \label{strict def 1}
}
When that inequality holds *strictly* for any two $x\neq z$ in $C$, the function $\psi$ is called *strictly convex*.
This can also be characterised in terms of the subradient.

@@colbox-blue
Let $x\in C^\circ$ and $y\in \partial \psi(x)$, $\psi$ is strictly convex on $C^\circ$ *if and only if* the subgradient inequality holds strictly for all $z\neq x$:
\eqa{
    \psi(z) &>& \psi(x) + \scal{z-x, y}, \quad\forall z\in C\backslash\{x\}.\label{strict def 2}
}
@@

This simply means that the graph of the function is strictly above its supporting hyperplanes.

We can prove this quickly by noting that \eqref{strict def 1} can be rearranged into
\eqa{
    \psi(z) &>&\psi(x) + {\psi((1-\lambda)x+\lambda z) - \psi(x)\over \lambda}, \label{strict pt1}
}
now if we let $y\in\partial \psi(x)$ and using the subgradient inequality, we can also write
\eqa{
    \psi((1-\lambda)x+\lambda z) &\ge& \psi(x) + \lambda\scal{z-x, y}.\label{strict pt2}
}
Combining \eqref{strict pt1} and \eqref{strict pt2} gives \eqref{strict def 2}.

**Example**: $\psi(x)=x\log(x)$ is strictly convex on $\R^+$ whereas $\psi(x)=|x|$ is not.

@@img-small ![](/assets/csml/cvxopt/strict-convex-ex.svg) @@

@@colbox-blue
The function $\varphi:C\to \R$ is said to be $\mu$-*strongly convex* at $x\in C$ with parameter $\mu>0$ if the subgradient inequality holds with:

\eqa{
    \varphi(z) &\ge& \varphi(x) + \scal{z-x, y} + {\mu\over 2}\|z-x\|_2^2,
} <!--_-->

for any $z\in C$ and $y\in\partial \varphi(x)$.
@@

Intuitively, a strongly convex function is a strictly convex function whose graph goes away from the supporting hyperplane sufficiently fast (at least quadratically fast).

We've now introduced three types of convex functions with increasing specificity:
* "just convex" (equal or above its supporting hyperplanes),
* "strictly convex" (strictly above its supporting hyperplanes),
* "strongly-convex" (moving at least quadratically fast away from its supporting hyperplanes).

A strongly-convex function is generally easier (faster) to optimise than a strictly convex function and the same with respect to a convex function as the additional constraints can be leveraged to speed up optimisation methods.

### Strict convexity and differentiability

@@colbox-blue
Let $\psi:C\to \R$ a convex function; $\psi$ is strictly convex on $C^\circ$ *if and only if* $\psi^\star$ is differentiable on $\partial f(C^\circ) = \{y\in\R^n\,|\,\exists x\in C^\circ, y\in\partial f(x)\}$.
@@

To prove this result, we can use the link between $\partial\psi$ and $\partial\psi^{\star}$ (cf. [convex analysis part 2](/posts/2018/09/24-convex-optimisation-2/)):
\eqa{
    x\in \partial f(y)\cap C &\Longleftrightarrow& (y\in\partial f(x), x\in C). \label{equiv df dfstar}
}
$\Rightarrow$: assume $f^\star$ is not differentiable on $C^\circ$. Then, there is a $y$ such that $\partial f^\star(y)$ contains more than one points, say $x_1\neq x_2$ in in $C^\circ$.
But then, using the equivalence \eqref{equiv df dfstar} we have that $y\in\partial f(x_1) \cap \partial f(x_2)$.
Since $f$ is strictly convex and $x_1\neq x_2$ the two following strict inequalities must hold:
\eqal{
    f(x_2)\spe{>}f(x_1)+\scal{x_2-x_1, y},\\
    f(x_1)\spe{>}f(x_2)+\scal{x_1-x_2, y}.
}
But summing both leads to a contradiction.

$\Leftarrow$: assume $f^\star$ is differentiable and take a $y$ with $x=\nabla f^\star(y)$ in $C^\circ$. Let's now assume that $f$ is not strictly convex on $C^\circ$. Then, there exists $z\in C^\circ$ such that $f(z)=f(x)+\scal{z-x, y}$.
But this can also be written $f(x)=f(z)+\scal{x-z,y}$ so that $y\in\partial f(z)$ by definition of the subgradient.
This means that both $x$ and $z$ are in $\partial f^\star(y)$ which contradicts the differentiability of $f^\star$.

## Bregman divergence <!-- ✅ 13/9/2018 -->

Consider the case where $\psi$ is strictly convex and differentiable on $C^\circ$ so that $\partial \psi(x)=\{\nabla \psi(x)\}$ for $x\in C^\circ$.
In that case, we have
\eqa{
    \psi(z) &\ge& f(x) + \scal{z-x, \nabla \psi(x)}, \quad \forall z\in C,\label{ineq subgrad diff}
}
with equality *if and only if* $z=x$.
We can use this to define a notion of similarity between two points $x$ and $z$ in $C$.

@@colbox-blue
Let $\psi$ denote a strictly convex and differentiable function on $C^\circ$.
The *Bregman-divergence* on $C^\circ\times C^\circ$ associated with $\psi$ is defined as
\eqa{B_\psi(z, x) &=& \psi(z)-\psi(x)-\scal{z-x,\nabla \psi(x)}.}
@@

Given \eqref{ineq subgrad diff}, we have that $B_\psi(z, x)>0$ for all $z\neq x$ and $B_\psi(z, x)=0$ iff $x=z$ which shows that $B_\psi$ is a valid divergence (positive definite functional).

For example, if we take $\psi(x) = \frac12\scal{x, x}$ then
\eqal{
    B_\psi(z, x) \esp&=\esp \frac12\scal{z, z} - \frac12\scal{x, x} - \scal{z-x, x}\\
                 &=\esp \frac12\scal{z-x, z-x}
}
which is just the squared Euclidean ($\ell^{2}$) distance between $z$ and $x$.
The factor $1/2$ might seem irrelevant but it makes other developments a bit nicer so that, usually in convex-optimisation, the squared Euclidean distance is scaled by a factor two.

Note that if the function $\varphi$ is $\mu$-strongly convex and differentiable, then the Bregman divergence associated to it is lower bounded by the squared $\ell^{2}$-distance:

\eqa{
B_{\varphi}(z,x) &\ge& {\mu\over 2} {\|z-x\|^{2}_{2}}, \quad\forall x,z \in C.
\label{strong convex bregman}}


### Bregman divergence and convex conjugacy <!-- ✅ 23/9/2018 -->

Let $\psi$ be a differentiable and strictly convex function on $C^\circ$ then $\psi^\star$ is also differentiable and strictly convex on $\nabla \psi(C^\circ)$ and we can consider the Bregman divergence that it induces:

\eqa{
    B_{\psi^\star}(u, v) &=& \psi^\star(u) - \psi^\star(v) - \scal{u-v, \nabla\psi^\star(v)}.\label{eq breg 1}
}

Let us consider a pair $x, z\in C^\circ$ with $u=\nabla\psi(x)$ and $v=\nabla\psi(z)$.
Then, since $(x, u)$ and $(z, v)$ are dual pairs, we have that $\psi^\star(u)+\psi(x)=\scal{x, u}$ (and the same in $(z, v)$) as well as $\nabla\psi^\star(v)=z$ so that $B_{\psi^\star}(u, v)$ simplifies to
\eqa{
    B_{\psi^\star}(u, v) &=& \psi(z) - \psi(x) - \scal{z-x, \nabla \psi(x)},
}
which proves the following result.

@@colbox-blue
Let $\psi$ be a differentiable and strictly convex function on $C^\circ$ then the following equality holds:
\eqa{
    B_{\psi^\star}(\nabla\psi(x), \nabla\psi(z)) &=& B_\psi(z, x),
}
for any $x,z \in C^\circ$.
@@

Observe how the arguments get "swapped".

## Lipschitz continuity and strong convexity <!-- ✅ 23/9/2018 -->

This is a useful result to prove convergence rates of some iterative minimisation methods but can easily be skipped in a first reading.

We will show that if $\varphi$ is a differentiable, strongly convex function on $C^\circ$ then $\nabla \varphi^\star$ is Lipschitz continuous on $\nabla\varphi(C^\circ)$.
Recall that a function $\phi$ is said to be $\beta$*-Lipschitz-continuous* on $E\subseteq \mathrm{dom}\,\phi$ if the following inequality holds $\forall u,v\in E$:

\eqa{
    \|\phi(u)-\phi(v)\|_2 &\le& \beta \|u-v\|_2.
} <!--_-->

Using \eqref{strong convex bregman}, we can write
\eqa{
    \mu \|x-z\|^{2}_{2} &\le& B_{\varphi}(x,z)+B_{\varphi}(z,x) .
}
for any $x, z\in C^\circ$.
Plugging the definition of the Bregman divergence in the right hand side and letting $u=\nabla \varphi(x)$ and $v=\nabla \varphi(z)$ we get
\eqal{
    \mu\| x-z\|^{2}_{2} &\spe{\le} \langle z-x, u-v \rangle \\
       &\spe{\le} \|x-z\|_2\|u-v\|_2,
} <!--_-->
using Cauchy-Schwartz's inequality on the second line.
Rearranging terms yields
\eqa{
    \|x-z\|_{2} &\le& {1\over \mu}\| u-v\|_2.
} <!--_-->

Since $x\in C^\circ$ and $u=\nabla \varphi(x)$, we can write $x = \nabla \varphi^\star(u)$ and similarly, $z=\nabla\varphi^\star(v)$ (see [convex analysis part 2](/posts/2018/09/24-convex-optimisation-2/)).
This shows that the gradient $\nabla\varphi^\star$ is Lispchitz-continuous.

@@colbox-blue
Let $\varphi$ be a differentiable, $\mu$-strongly convex function on $C^\circ$ then $\varphi^\star$ has a gradient that is is $1/\mu$-Lipschitz continuous over $\nabla \varphi(C^\circ)$, i.e.:

\eqa{
    \| \nabla \varphi^\star(u)-\nabla \varphi^\star(v)  \| &\le& {1\over \mu}\|u-v\|,\quad \forall u,v\in\nabla\varphi(C^\circ),
}
where $\nabla \varphi (C^\circ)=\{u\in\R^n\,|\,\exists x\in C^\circ, u=\nabla \varphi(x)\}$.
@@

## Short references

1. **Bregman**, [A relaxation method of finding a common point of convex sets and its application to the solution of problems in convex programming](http://www.mathnet.ru/links/7dbe5d285fbf611e001a7ab6365e2bed/zvmmf7353.pdf), 1967. -- This is just for fun, it's the original paper by Bregman in 1967 and though you might find it a bit hard to read (I personally don't read Russian), you should be able to recognise equation (1.4).
1. **Goebel**, **Rockafellar**, [Local strong convexity and local Lipschitz continuity of the gradient of convex functions](https://pdfs.semanticscholar.org/d16c/32505274be2bc80d8547a36e6ac2239a80b2.pdf), 2007. -- This is a more technical note covering the link between strong convexity and Lipschitz-continuity.


*See also the general references mentioned in the [introduction](/pub/csml/cvxopt/intro.html).*
