+++
title = "Convex analysis &ndash; pt. I"
descr = """
    The subdifferential and the First-order Optimality Condition (FOC).
    """
tags = ["optimisation"]
+++

{{redirect /pub/csml/cvxopt/ca1.html}}

# Convex analysis (part I)

{{page_tags}}

\toc \\

In the notes $\Gamma_0(C)$ denotes the set of *proper* and *lsc* convex functions on a non-empty convex set $C\subseteq \R^n.$ Remember that we assume $C\subseteq \mathrm{dom} f$ the domain of the function of interest $f$.

* a **proper** convex function $f$ is finite value for at least one $x\in C$ (i.e.: $\exists x\in C, f(x) < \infty$) and is always lower bounded (i.e.: $f(x)>-\infty, \forall x\in C$).
* a **lsc** (*lower semi continuous*) function is such that
\eqa{f(x)&\le& \lim_{i\to \infty} f(x_i) \label{def lsc}}
for any sequence $x_1, x_2, \dots$ in $C$ that converges to $x$ and such that the limit exists (see \citet{rockafellar70} section 7). The figure below illustrates this (note that the functions are of course not convex).

@@img-small ![](/assets/cvxopt/lsc-usc.svg) @@

For the purpose of these notes, we will *always* assume that $f$ is a proper convex function and usually assume that it is also lsc.

**Example**: the function $f(x)=|x|+i_{[-1,1]}(x)$ is in $\Gamma_0(\R)$. Clearly it is a proper convex function on $\R$ and is lsc on $\R\backslash\{-1, 1\}$. Then, it's easy to see that for any sequence $x_1,x_2,\dots$ in $\R$ converging to $1$ (resp. $-1$) we have $\lim_{i\to\infty} f(x_i)=\infty$ or $f(1)$ (resp. $f(-1)$) so that \eqref{def lsc} holds.


## Subgradient, subdifferential and FOC <!-- ✅ 19/9/2018 -->

@@colbox-blue
We say that $y\in\R^n$ is a *subgradient* of the convex function $f$ at $x\in C$ if it verifies the following inequality:

\eqa{
    f(z) &\ge & f(x) + \langle z-x, y \rangle, \qquad \forall z\in C. \label{subgradient ineq}
}
@@

The inequality \eqref{subgradient ineq} simply indicates that the graph of the function $f$ at $x$ is supported by the hyperplane defined by the right-hand side.
A subgradient is thus the "slope" of one such *supporting hyperplane*.

The function is differentiable at $x$ if and only if there is a unique subgradient at $x$ (the classical gradient $\nabla f(x)$) and, correspondingly, only one supporting hyperplane:

\eqa{
    f(z) &\ge& f(x) + \scal{z-x, \nabla f(x)}, \qquad \forall z \in C.
}

However, if the function is not differentiable at $x$ (e.g., if there is a kink at $x$) then there may be infinitely many supporting hyperplanes and infinitely many subgradients.

@@colbox-blue
The set of subgradients of a convex function $f$ at a point $x\in \mathrm{dom}\, f$ is called the *subdifferential* of $f$ and denoted $\partial f(x)$.
For a proper convex function $f$, it can be shown that the subdifferential of $f$ is a non-empty bounded set at any point $x\in (\mathrm{dom}\,f)^\circ$ (\citet{rockafellar70}, theorem 23.4).
@@

Note that since we have assumed that $C\subseteq \mathrm{dom}\,f$, then $C^\circ\subseteq (\mathrm{dom}\,f)^\circ$ and therefore $\partial f$ is non-empty and bounded on $C^\circ$.

An example is the absolute value function $f(x)=|x|$ which is not differentiable at $0$.
It is however supported at that point by all lines of the form $\ell_\alpha(x)=\alpha x$ with $\alpha\in [-1,1]$ (see the dashed lines on the figure below).
The set $[-1, 1]$ is therefore the subdifferential of the function at $0$, denoted $\partial f(0)$.

@@img-small ![](/assets/cvxopt/abs-subgrad.svg) @@

### First order optimality condition (FOC) <!-- ✅ 12/9/2018 -->

A point $\xopt\in C$ is a minimiser of the function $f$ if and only if $f(z)\ge f(\xopt)$ for all $z\in C$.
This can be written equivalently as:

\eqa{
    f(z) &\ge& f(\xopt) + \scal{z-x, 0}, \qquad \forall z \in C,
}

and hence $0$ must be a subgradient of $f$ at $\xopt$.

@@colbox-blue
*First-order optimality condition* (FOC): for a proper convex function $f$,
$$
\xopt \,\in\, \arg\min_{x\in C} \, f(x) \spe{\Longleftrightarrow} 0\,\in\, \partial f(\xopt).$$
@@

**Note**: some care must be taken when $\xopt \in \arg\inf_{x\in C} f(x)$ is on the boundary of $C$ as there may not be a subgradient there, this is why we had originally assumed that $f$ is minimised on the interior of $C$.
We will come back to this when discussing optimisation methods for constrained problems such as the projected gradient descent.

If we take the subdifferential as an *operator* then, intuitively, looking for a minimiser amounts to "inverting" the subdifferential and evaluating it at $0$, i.e.: $\xopt = (\partial f)^{-1}(0)$.
Of course at this point we don't know how to compute $(\partial f)^{-1}$ in general.
We shall come back to this in more details but the idea of inverting an operator involving the subdifferential to find the minimiser is key in convex optimisation.

Note that in some simple situations the FOC is sufficient to immediately find a minimiser, for instance, if $f(x)=|x|$, then clearly the subdifferential:

\eqa{
    \partial f(x) &=& \begin{cases} \mathrm{sign}(x) & (x\neq 0) \\\\ [-1, 1] & (x=0) \end{cases}
}

which shows that the only point $\xopt$ where $0\in \partial f(\xopt)$ is $\xopt=0$. In other words, $(\partial f)^{-1}(0) = 0$.

### Subdifferential of a sum <!-- ✅ 12/9/2018 -->

@@colbox-blue
Let $f_i:C\to \R$ be proper convex functions then
\eqa{
    \partial \sum_i f_i &\supseteq& \sum_i \partial f_i. \label{subdiff of sum}
}
@@

Indeed, let $g\equiv\sum_i f_i$ and let $y_i\in\partial f_i(x)$ then, by definition,

\eqa{
    f_i(z) &\ge& f_i(x) + \scal{z-x, y_i}, \quad\forall z\in C,
}
and we can sum across these inequalities to get
\eqa{
    g(z) &\ge& g(x) + \langle z-x, \sum_i y_i\rangle, \quad\forall z\in C,
}
so that $\sum_i y_i \in \partial g(x)$.
Note that if $0\in \sum_i \partial f_i(x^\dagger)$ then the inclusion implies $0\in\partial \sum_i f_i(x^\dagger)$ which is sufficient to show that $x^\dagger$ is a minimiser.

## Additional references

1. **Boyd** and **Vandenberghe**, [Subgradients](https://see.stanford.edu/materials/lsocoee364b/01-subgradients_notes.pdf), 2008. -- Accessible lecture notes introducing the subgradient and proving that the subdifferential of a convex function is non-empty and closed at any point in the interior of the domain of the function.
1. \biblabel{rockafellar70}{Rockafellar (1970)} **Rockafellar**: [Convex analysis](http://press.princeton.edu/titles/1815.html), 1970.

*See also the general references mentioned in the [introduction](/posts/2018/09/13-convex-optimisation-intro/).*
