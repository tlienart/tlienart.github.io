@def title = "Convex analysis I"

# Convex analysis (part 1)

In the notes $\Gamma_0(C)$ denotes the set of *proper* and *lsc* convex functions on a convex set $C\subseteq \R^n$.
Often we will just write $\Gamma_0$ when the domain of the minimisation is unambiguous.

* **proper** indicates that the function takes a finite value for at least one $x\in C$ (i.e.: $\exists x\in C, f(x) < \infty$) and is always lower bounded (i.e.: $f(x)>-\infty, \forall x\in C$). For instance: the indicator of a non-empty set is a proper convex function.
* **lsc** (*lower semi continuous*) indicates that around a point $x_d\in C$ of discontinuity, we will either have $f(x)>f(x_d)$ or $f(x)\le f(x_d)$. For instance: the function $f(x)=1$ if $x>0$ and $f(x)=0$ otherwise, is lsc. on $\R$. However, the function $g(x)=1$ if $x\ge0$ and $g(x)=0$ is *upper* semi continuous on $\R$.

@@img-small ![](/assets/csml/cvxopt/lsc-usc.svg) @@

We denote by $x^\sharp \in C^\circ$ a minimiser of the function, i.e. a point such that $f(x)\ge f(x^\sharp)$ for all $x\in C$ (remember that we assume that the minimum is achieved on $C^\circ$).
It is easy to show that the set of minimisers $\arg\min_{x\in C}$ is a convex subset of $C$.

## Subgradient, subdifferential and FOC <!-- ✅ 12/9/2018 -->

@@colbox-yellow

We say that $y\in\R^n$ is a *subgradient* of the function $f$ at $x\in C$ if it verifies the following inequality:

\eqa{
    f(z) &\ge & f(x) + \langle z-x, y \rangle, \qquad \forall z\in C. \label{subgradient ineq}
}
@@

The inequality \eqref{subgradient ineq} simply indicates that the graph of the function $f$ at $x$ is supported by the hyperplane defined by the right-hand side.
A subgradient is thus the "slope" of one such *supporting hyperplane*.

If the function is differentiable at $x$ then there is only one such subgradient at $x$ (the classical gradient $\nabla f(x)$) and, correspondingly, only one supporting hyperplane:

\eqa{
    f(z) &\ge& f(x) + \scal{z-x, \nabla f(x)}, \qquad \forall z \in C.
}

However, if the function is not differentiable at $x$ (e.g., if there is a kink at $x$) then there may be infinitely many supporting hyperplanes and infinitely many subgradients.

@@colbox-yellow
The set of subgradients of a function $f$ at a point $x\in \mathrm{dom}\, f$ is called the *subdifferential* and denoted $\partial f(x)$.
For a convex function $f$, it can be shown that the subdifferential of $f$ is a non-empty bounded set at any point $x\in (\mathrm{dom}\,f)^\circ$.
@@

An example is the absolute value function $f(x)=|x|$ which is not differentiable at $0$.
It is however supported at that point by all lines of the form $\ell_\alpha(x)=\alpha x$ with $\alpha\in [-1,1]$ (see figure below).
The set $[-1, 1]$ is therefore the subdifferential of the function at $0$, denoted $\partial f(0)$.

![](/assets/csml/cvxopt/abs-subgrad.svg)

### First order optimality condition (FOC) <!-- ✅ 12/9/2018 -->

A point $x^{\sharp}\in C$ is a minimiser of the function $f$ if and only if $f(z)\ge f(x^{\sharp})$ for all $z\in C$.
This can be written equivalently as:

\eqa{
    f(z) &\ge& f(x^{\sharp}) + \scal{z-x, 0}, \qquad \forall z \in C,
}

and hence $0$ must be a subgradient of $f$ at $x^\sharp$.

@@colbox-yellow
*First-order optimality condition* (FOC): for a convex function $f$,

$$
x^\sharp \,\in\, \arg\min_{x\in C} \, f(x) \spe{\Longleftrightarrow} 0\,\in\, \partial f(x^\sharp).$$
@@

If we take the subdifferential as an *operator* then, intuitively, looking for a minimiser amounts to "inverting" the subdifferential and evaluating it at $0$, i.e.: $x^\sharp = (\partial f)^{-1}(0)$.
Of course at this point we don't know how to compute $(\partial f)^{-1}$ in general.
We shall come back to this in more details but the idea of inverting an operator involving the subdifferential to find the minimiser is key in convex optimisation.

Note that in some simple situations the FOC is sufficient to immediately find a minimiser, for instance, if $f(x)=|x|$, then clearly the subdifferential:

\eqa{
    \partial f(x) &=& \begin{cases} \mathrm{sign}(x) & (x\neq 0) \\\\ [-1, 1] & (x=0) \end{cases}
}

which shows that the only point $x^\sharp$ where $0\in \partial f(x^\sharp)$ is $x^\sharp=0$. In other words, $(\partial f)^{-1}(0) = 0$.

### Subdifferential of a sum <!-- ✅ 12/9/2018 -->

@@colbox-yellow
Let $f_i:C\to \R$ be convex functions then
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
Note that if we have $0\in \sum_i \partial f_i(x^\dagger)$ then the inclusion implies that $0\in\partial \sum_i f_i(x^\dagger)$ which is sufficient to show that $x^\dagger$ is a minimiser.

## Short references

1. **Boyd** and **Vandenberghe**, [Subgradients](https://see.stanford.edu/materials/lsocoee364b/01-subgradients_notes.pdf): accessible lecture notes introducing the subgradients and proving that the subdifferential of a convex function is non-empty and closed at any point in the interior of the domain of the function.

*See also the books mentioned in the introduction.*
