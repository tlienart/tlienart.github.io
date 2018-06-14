@def title = "Basics of Convex Analysis"

# Basics of Convex Analysis


We introduce here briefly a few important building blocks of convex optimisation:

* *subgradient* (generalised gradient) and subdifferential,
* *first-order optimality condition*,
* *strict* and *strong convexity*, *positive-definite functions* and a hint at *Bregman divergences*,
* *convex conjugate*.

## Subgradient and First-order Optimality Condition

@@colbox-yellow

We say that $y\in X$ is a *subgradient* of the function $f\in\Gamma_{0}(X)$ at $x\in X$ and belongs to the *subdifferential* of $f$ at that point (denoted $\partial f(x)$) if it verifies the following inequality:

\begin{eqnarray}
f(z) &\ge & f(x) + \langle z-x, y \rangle, \qquad \forall z\in X.
\end{eqnarray}

@@


The inequality above simply indicates that the graph of the function $f$ is supported by the hyperplane defined by the right-hand side.
A subgradient is thus the "slope" of one such *supporting hyperplane*.
If the function is differentiable at $x$ then there is only one such subgradient (the classical gradient) and, correspondingly, only one supporting hyperplane.
However, if the function is not differentiable at $x$ (e.g., if there is a kink at $x$) then there is an infinity of hyperplanes supporting the function and, correspondingly, the subdifferential at that point is a *set* with a continuum of subgradients.

An example is the absolute value function $f(x)=|x|$ which is not differentiable at $0$.
It is however supported at that point by all lines of the form $\ell(x)=\alpha x$ with $\alpha\in [-1,1]$.
This set is the subdifferential of the function at $0$, denoted $\partial f(0)$.



<!-- ~~~
{}{img_left}{_figs/ex_subgrad_plot1_g.png}{}

	Illustration of the function $f(x)=|x|$ (thick line) and of two supporting lines at the origin (dashed lines). Each of these supporting lines has slope in the subdifferential $\partial f(0)$.\n
Note that the horizontal line is also a supporting hyperplane, illustrating that $0\in\partial f(0)$ and hence that the function has a minimizer at the origin by the first-order condition (cf. below).
~~~ -->


By definition of an optimal point $x^{\sharp}$ for the unconstrained problem, we must have $f(z)\ge f(x^{\sharp})$ for all $z\in X$.
This can be written as


\begin{eqnarray}
f(z) &\ge& f(x^{\sharp}) + \langle z-x,0 \rangle, \qquad \forall z \in X,
\end{eqnarray}


and hence $0$ must be a subgradient of $f$ at $x^\sharp$.


<!-- ~~~ -->

This is the *first-order optimality condition* (FOC):

\begin{eqnarray}
x^\sharp \,\in\, \arg\min_x \, f(x) &\Longleftrightarrow& 0\,\in\, \partial f(x^\sharp).
\end{eqnarray}

<!-- ~~~ -->


If we take the subdifferential as an *operator* then, intuitively, looking for a minimiser amounts to "inverting" the subdifferential and evaluating it at $0$, i.e.: $x^\sharp = (\partial f)^{-1}(0)$.
We shall come back to this in more details but the idea of inverting an operator involving the subdifferential to find the minimiser is very important in optimisation.

Before moving on, it is useful to note (and not too hard to convince oneself) that the following inclusion holds for the subdifferential of a sum:


\begin{eqnarray}
\sum_i \partial f_i &\subseteq& \partial \sum_i f_i.
\end{eqnarray}

For most problems of interest, it holds as an equality.
But note that, even if it does not hold as an equality, if $0\in \sum_i \partial f_i(x^\dagger)$ then the above inclusion implies that $0\in\partial \sum_i f_i(x^\dagger)$ which is sufficient to show that $x^\dagger$ is a minimiser (and is ultimately what we are interested in).

## Strict and Strong convexity

<!-- ~~~ -->

The function $\psi$ is said to be *strictly convex* at $x$ if the sub-gradient inequality holds *strictly* for all $z\in X\backslash \{x\}$ i.e.,:

\begin{eqnarray}
\psi(z) &>& \psi(x) + \langle z-x , y\rangle, \quad\forall z\in X,\, z\neq x
\end{eqnarray}

where $y\in\partial \psi(x)$.
<!-- ~~~ -->

Recalling that a function $d: X\times X$ is said to be *positive-definite* if $d(u,u)=0$ and $d(u,v)>0$ for $u\neq v$, we can observe that we can use such a strictly convex function to define a positive-definite function $B_{\psi}:X\times X\to \mathbb R^{+}$ as:


\begin{eqnarray}
B_{\psi}(z,x) &:=& \psi(z)-\psi(x) - \langle z-x,y \rangle, \quad \text{with}\quad y\in\partial \psi(x).
\end{eqnarray}


This equation actually characterises *Bregman divergences*.
<!-- We shall come back to that (e.g., in the notes on the
*[blog_opti_mda.html Mirror Descent Algorithm]*). -->

<!-- ~~~ -->

The function $\varphi$ is said to be $\mu$-*strongly convex* with parameter $\mu>0$ if it is strictly convex and if the Bregman divergence associated to it is lower bounded by $\mu$ times the squared Euclidean ($\ell^{2}$) distance, i.e.:


\begin{eqnarray}
B_{\varphi}(x,y) &\ge& {\mu\over 2} {\|x-y\|^{2}_{2}}, \quad\forall x,y\in X.
\end{eqnarray}

<!-- ~~~ -->

The factor $1/2$ might seem irrelevant but makes other developments look nicer. For now, observe that if we take the derivative of the right-hand side, then we are left with $(x-y)$ without a spurious factor $2$...

*Remark*: note that, obviously, a strongly-convex function is also strictly convex.

## Legendre-Fenchel convex conjugate

Let us once more consider the definition of the subgradient of a convex function $f$ at a point $x$:

\begin{eqnarray}
\partial f(x) &=& \{y\,|\, f(z)\,\ge\, f(x)+\langle z-x,y\rangle, \,\forall z\}.
\end{eqnarray}

Note that we can then rearrange terms in the condition as follows:

\begin{eqnarray}
\partial f(x) &=& \{y\,|\, \langle z,y\rangle - f(z)\,\le\, \langle x,y\rangle - f(x), \,\forall z\},
\end{eqnarray}

but since the condition must hold for all $z$, it must equivalently hold for all $z$ that maximises the lower bound. Note that the maximum of that lower bound tightens the inequality exactly (just take $z=x$). We can thus write the subgradient as

\begin{eqnarray}
\partial f(x) &=& \{y \,|\, \max_{z} \,\, [\langle z,y\rangle -f(z)] \,=\, \langle x,y\rangle -f(x)\}.
\end{eqnarray}


<!-- ~~~ -->

This justifies the definition of the *convex conjugate* $f^\star(y):X\to \overline{\mathbb R}$ as follows:

\begin{eqnarray}
f^\star(y) &:=& \max_z \,\,[\langle z,y \rangle - f(z)].
\end{eqnarray}

where $\overline{\mathbb R}=\mathbb R \cup \{\pm\infty\}$ is the extended real line.
<!-- ~~~ -->

The subgradient can then be expressed in terms of the convex conjugate as:

\begin{eqnarray}
\partial f(x) &=& \{ y \,|\, f^{\star}(y) \,=\, \langle x,y\rangle - f(x)\}.
\end{eqnarray}

A useful property of the convex conjugate for *nice* convex functions is that $f^{\star\star}=f$ (again, by "nice" we mean $f\in \Gamma_0(X)$).
<!-- We give a sketch of a proof for this in [blog_opti_ca2.html "*more convex analysis*"]. -->

We can consider a simple (and yet quite useful) example for the convex conjugate: if we define $\psi(x):=\|x\|^2/2$, its convex conjugate is then

\begin{eqnarray}
\psi^\star(y) &=& \max_z\,\, \langle z,y\rangle - \frac12\langle z,z\rangle,
\end{eqnarray}

and the FOC leads immediately to $\psi^\star(y)=\psi(y)$.

<!-- ~~~ -->

The definition of the convex conjugate also directly implies *Fenchel's inequality*:

\begin{eqnarray}
f(x) + f^\star(y) &\ge & \langle x,y\rangle, \quad \forall x,y\in X.
\end{eqnarray}

<!-- ~~~ -->

## A couple of comments

* We use $\max$ and $\min$ everywhere. It would be more correct to use $\sup$ and $\inf$. In practice this point is usually irrelevant.
* The notion of duality is rather important in convex analysis and, to be a bit more precise, we should note that a subgradient belongs to the dual space $X^{\star}$ and that the convex conjugate is actually defined on $X^{\star}$ as well. However, in most cases, $X$ is $\mathbb R^n$ which is self-dual and one can afford to drop making the distinction which makes the notations less cumbersome. Generalisation to arbitrary Banach spaces is not difficult but requires a bit of care.
