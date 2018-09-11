@def title = "Basics of Convex Analysis"

# Basics of convex analysis

We introduce here briefly a few important building blocks of convex optimisation:

* *subgradient* (generalised gradient) and *subdifferential*,
* *first-order optimality condition* (FOC),
* *strict* and *strong convexity*, *positive-definite functions* and a hint at *Bregman divergences*,
* *convex conjugate*.

### Notations

In the notes $\Gamma_0(X)$ denotes the set of *proper* and *lsc* convex functions on $X\subseteq \R^n$ (i.e.: *nice* functions).

* **proper** indicates that the function takes a finite value for at least one $x\in X$ (i.e.: $\exists x\in X, f(x) < \infty$) and is always lower bounded (i.e.: $f(x)>-\infty, \forall x\in X$). For instance: the indicator of a non-empty set is a proper function.
* **lsc** (*lower semi continuous*) indicates that around a point $x_d\in X$ of discontinuity, we will either have $f(x)>f(x_d)$ or $f(x)\le f(x_d)$. For instance: the function $f(x)=1$ if $x>0$ and $f(x)=0$ otherwise is lsc.

We also write $x^\sharp$ a true minimiser of the function, i.e. a point such that $f(x)\ge f(x^\sharp)$ for all $x\in X$.
Finally, we write $\eR$ the extended real line: $\eR = \R \cup \{+\infty\}$.

## Subgradient, subdifferential and FOC

@@colbox-yellow

We say that $y\in X$ is a *subgradient* of the function $f\in\Gamma_{0}(X)$ at $x\in X$ and belongs to the *subdifferential* of $f$ at that point (denoted $\partial f(x)$) if it verifies the following inequality:

\eqa{
    f(z) &\ge & f(x) + \langle z-x, y \rangle, \qquad \forall z\in X. \label{subgradient ineq}
}

@@


The inequality \eqref{subgradient ineq} simply indicates that the graph of the function $f$ is supported by the hyperplane defined by the right-hand side.
A subgradient is thus the "slope" of one such *supporting hyperplane*.

If the function is differentiable at $x$ then there is only one such subgradient at $x$ (the classical gradient) and, correspondingly, only one supporting hyperplane.
However, if the function is not differentiable at $x$ (e.g., if there is a kink at $x$) then there is an infinity of hyperplanes supporting the function and, correspondingly, the subdifferential at that point is a *set* with a continuum of subgradients.

An example is the absolute value function $f(x)=|x|$ which is not differentiable at $0$.
It is however supported at that point by all lines of the form $\ell(x)=\alpha x$ with $\alpha\in [-1,1]$.
The set $[-1, 1]$ is therefore the subdifferential of the function at $0$, denoted $\partial f(0)$.



<!-- ~~~
{}{img_left}{_figs/ex_subgrad_plot1_g.png}{}

	Illustration of the function $f(x)=|x|$ (thick line) and of two supporting lines at the origin (dashed lines). Each of these supporting lines has slope in the subdifferential $\partial f(0)$.\n
Note that the horizontal line is also a supporting hyperplane, illustrating that $0\in\partial f(0)$ and hence that the function has a minimizer at the origin by the first-order condition (cf. below).
~~~ -->

### First order optimality condition (FOC)

By definition, an optimal point $x^{\sharp}$ for the general minimisation problem must be such that $f(z)\ge f(x^{\sharp})$ for all $z\in X$.
This can be written as


\eqa{
    f(z) &\ge& f(x^{\sharp}) + \langle z-x,0 \rangle, \qquad \forall z \in X,
}


and hence $0$ must be a subgradient of $f$ at $x^\sharp$.


@@colbox-yellow

This is the *first-order optimality condition* (FOC):

\eqa{
    x^\sharp \,\in\, \arg\min_x \, f(x) &\Longleftrightarrow& 0\,\in\, \partial f(x^\sharp).
}

@@


If we take the subdifferential as an *operator* then, intuitively, looking for a minimiser amounts to "inverting" the subdifferential and evaluating it at $0$, i.e.: $x^\sharp = (\partial f)^{-1}(0)$.
We shall come back to this in more details but the idea of inverting an operator involving the subdifferential to find the minimiser is key in convex optimisation.

### Subdifferential of a sum

Before moving on, it is useful to note (and not too hard to convince oneself) that the following inclusion holds for the subdifferential of a sum:

\eqa{
    \partial \sum_i f_i &\supseteq& \sum_i \partial f_i.
}

For most problems of interest, it holds as an equality.
But note that, even if it does not hold as an equality, if $0\in \sum_i \partial f_i(x^\dagger)$ then the inclusion above implies that $0\in\partial \sum_i f_i(x^\dagger)$ which is sufficient to show that $x^\dagger$ is a minimiser (and is ultimately what we are interested in).

## Strict and strong convexity

### Strict convexity and Bregman divergence

@@colbox-yellow
The function $\psi$ is said to be *strictly convex* at $x$ if the sub-gradient inequality \eqref{subgradient ineq} holds *strictly* for all $z\in X\backslash \{x\}$ i.e.:

\eqa{
\psi(z) &>& \psi(x) + \langle z-x , y\rangle, \quad\forall z\in X,\, z\neq x
}

where $y\in\partial \psi(x)$.
@@

Recalling that a function $d: X\times X$ is said to be *positive-definite* if $d(u,u)=0$ and $d(u,v)>0$ for $u\neq v$, we can observe that we can use such a strictly convex function to define a positive-definite function $B_{\psi}:X\times X\to \mathbb R^{+}$ as:


\eqa{
B_{\psi}(z,x) &:=& \psi(z)-\psi(x) - \langle z-x,y \rangle, \quad \text{with}\quad y\in\partial \psi(x).
}

This equation actually characterises *Bregman divergences*, we will come back to those later in the notes.

### Strong convexity

@@colbox-yellow
The function $\varphi$ is said to be $\mu$-*strongly convex* with parameter $\mu>0$ if it is strictly convex and if the Bregman divergence associated to it is lower bounded by $\mu$ times the squared Euclidean ($\ell^{2}$) distance, i.e.:

\eqa{
B_{\varphi}(x,y) &\ge& {\mu\over 2} {\|x-y\|^{2}_{2}}, \quad\forall x,y\in X.
}
@@

The factor $1/2$ might seem irrelevant but makes other developments look nicer. For now, observe that if we take the derivative of the right-hand side, then we are left with $(x-y)$ without a spurious factor $2$.

*Remark*: note that, obviously, a strongly-convex function is also strictly convex.

## The convex conjugate

Let us once more consider the definition of the subgradient of a convex function $f:X\to\eR$ at a point $x\in X$:

\eqa{
    \partial f(x) &=& \{y\,|\, f(z)\,\ge\, f(x)+\langle z-x,y\rangle, \,\forall z\in X\}.
}

We can rearrange terms in the condition as follows:

\eqa{
    \partial f(x) &=& \{y\,|\, \langle z,y\rangle - f(z)\,\le\, \langle x,y\rangle - f(x), \,\forall z\in X\}.
}

However, since the condition must hold for all $z\in X$, it must equivalently hold for any $z\in X$ that maximises the lower bound.
Note that the maximum of that lower bound tightens the inequality exactly (just take $z=x$).
We can thus write the subgradient as

\eqa{
    \partial f(x) &=& \{y \,|\, \max_{z\in X} \,\, [\langle z,y\rangle -f(z)] \,=\, \langle x,y\rangle -f(x)\}.
}

This justifies the definition of the *convex conjugate* of a function (also sometimes known as the *Fenchel-Legendre convex conjugate* or a combination of those words).

@@colbox-yellow
Let $f: X\to \eR$ be a function, we define its *convex conjugate* $f^\star(y):X\to \overline{\mathbb R}$ as follows:

\eqa{
    f^\star(y) &:=& \sup_{z\in X} \,\,[\langle z,y \rangle - f(z)].
}
@@

It is easy to show that the convex conjugate of a function $f$ is always convex even if the function $f$ is not convex.

The subgradient of a convex function $f$ can then be expressed in terms of the convex conjugate as:

\eqa{
    \partial f(x) &=& \{ y \,|\, f^{\star}(y) \,=\, \langle x,y\rangle - f(x)\}.
}

A useful property of the convex conjugate for *nice* convex functions $f$ (i.e.: $f\in \Gamma_0(X)$), the convex conjugate of the convex conjugate is the function itself: $f^{\star\star}=f$.
<!-- We give a sketch of a proof for this in [blog_opti_ca2.html "*more convex analysis*"]. -->

We can consider a simple (and yet quite useful) example for the convex conjugate: if we define $\psi(x):=\|x\|^2/2$, its convex conjugate is then

\begin{eqnarray}
\psi^\star(y) &=& \sup_z\,\, \langle z,y\rangle - \frac12\langle z,z\rangle.
\end{eqnarray}

The problem in the right hand side is easy to solve: the objective function is differentiable and the FOC gives $y-z^\sharp = 0$ so that $\psi^\star(y)= \psi(y)$.

### Fenchel's inequality

The definition of the convex conjugate also directly implies *Fenchel's inequality*.

@@colbox-yellow
Let $f:X\to \eR$ and $f^\star$ its convex conjugate, then:
\eqa{
    f(x) + f^\star(y) &\ge & \langle x,y\rangle, \quad \forall x,y\in X.
}
@@

## Comments and references

* The notion of duality is rather important in convex analysis and, to be a bit more precise, we should note that a subgradient belongs to the dual space $X^{\star}$ and that the convex conjugate is actually defined on $X^{\star}$ as well. However, in most cases, $X$ is $\mathbb R^n$ which is self-dual and one can afford to drop making the distinction which makes the notations less cumbersome. Generalisation to arbitrary Banach spaces is not difficult but requires a bit of care, see Rockafellar's book.

Beyond the books mentioned in the [introduction](/pub/csml/cvx_opti/intro.html), you may want to consider these references:

1. **Hiriart-Urruty**: [A note on the Legendre-Fenchel transform of convex composite functions](https://www.math.univ-toulouse.fr/~jbhu/A_note_on_the_LF_transform.pdf). This is a more technical note that you may find interesting if you would like more details on convex conjugacy.
