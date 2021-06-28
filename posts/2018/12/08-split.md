+++
title = "Splitting methods"
descr = """
   Splitting methods in optimisation, proximal methods, and the Alternating Direction Method of Multipliers (ADMM).
   """
tags = ["optimisation", "proximal method", "admm", "splitting methods"]
+++
<!-- @def hascode = true -->

{{redirect /pub/csml/cvxopt/split.html}}

# Splitting methods and ADMM

{{page_tags}}

In these notes, I show how some well known methods from numerical linear algebra can be applied to convex optimisation.
The aim of these notes is to give an idea for how the following topics intertwine:

* solving a system of linear equations via iterative methods
* operator splitting techniques (*Gauss-Seidel*, *Douglas-Rachford*, ...),
* proximal operator,
* the *alternating direction methods of multipliers* also known as ADM or ADMM

\toc

## From convex optimisation to linear algebra

### Decomposable problems

In machine learning, imaging etc, a large portion of the convex optimisation problems can be written in the form:
$$ \xopt \spe{\in} \arg\min_x\,\, f(x) + g(x).$$
This includes constrained problems where $g\equiv \iota_C$ for a convex set $C$ or penalised problems like the LASSO regression:
$$ \xopt \spe{\in}\arg\min_x\,\, \frac12\|Ax-b\|_2^2 + \lambda\|x\|_1 \label{decomposable-pb}$$ <!--_-->

In a similar vein as for the previous notes, the following regularity conditions are usually assumed to hold:
1. $f, g\in \Gamma_0$, the space of convex, proper, lower semi-continuous functions,
2. $f, g$ are such that on $\mathrm{dom}\, f \cap \mathrm{dom}\, g$, $\partial(f+g)=\partial f+\partial g$.

As we showed in [convex analysis part 1](\cvx{ca1.html}), for $\xopt$ to be a minimiser, it must verify the first order condition, i.e.:

$$ 0 \spe{\in} (\partial f+\partial g)(\xopt), \label{decomposable-foc}$$

the issue being that, in most cases, we don't have a (cheaply available) closed-form expression for the inverse operator (otherwise the problem is trivial).

This issue can in fact be related to the classical problem of solving a linear system of equations:

$$ b \speq Ax \label{linsyst}$$

where $A$ is invertible but is, for instance, too big or too poorly conditioned for its inverse to be computable cheaply and reliably.

### Operator splitting methods in linear algebra

One way of attempting to solve \eqref{linsyst} without computing the inverse of $A$ is to consider a *splitting method*: a decomposition of $A$ into a sum of matrices $A=B+C$ with desirable properties.
The equation \eqref{linsyst} can then be written in the form of a *fixed-point equation*:

$$ Bx \speq b-Cx. $$

Assuming that $B$ is easier to invert than $A$, we can consider the *fixed-point iteration* algorithm:

$$ x_{k+1} \speq B\inv (b-Cx_k). $$

There are two classical examples of this type of splitting:

1. the *Jacobi method*, writing $A=D+R$ with $D$ diagonal,
1. the *Gauss-Seidel method*, writing $A=(L+D)+U$ with $L$ and $U$ lower and upper triangular respectively.

Under some conditions, the corresponding fixed-point iterations converge (see also \cite{ortega00}).
For instance if $A$ is symmetric, positive definite or if it is diagonally dominant then Gauss-Seidel converges.

<!-- Here's a short Julia script to see it at work:

```julia
using LinearAlgebra
using Random: seed!

function gs(A, nsteps)
   L = LowerTriangular(A)
   U = UpperTriangular(A)
   U -= Diagonal(diag(U))
   xk = zeros(size(A, 1))
   for i ∈ 1:nsteps
      xk = L\(b-U*xk)
   end
   xk
end

seed!(12345)

n = 35
A = randn(n, n)
A *= A' # make A positive definite
A += A' # make A symmetric
b = randn(n)
x = A\b # "exact" solution

for nsteps ∈ [10, 50, 100] * 1_000
   xgs = gs(A, nsteps)
   println("GS with $nsteps steps: -- $(norm(A*xgs-b))")
end
```

which gives

```
GS with 10000 steps: -- 0.018597329159745168
GS with 50000 steps: -- 1.5589014142640383e-7
GS with 100000 steps: -- 2.9978755825784496e-13
``` -->

### DPR splitting

Researchers like *Douglas*, *Peaceman* and *Rachford* studied this in the mid 1950s to solve linear systems arising from the discretisation of systems of partial differential equations \citep{peaceman55, douglas56}.
They came up with what is now known as the *Douglas-Rachford* splitting and the *Peaceman-Rachford* splitting.

The context is simple: assume that we have a decomposition $A=B+C$ where $B$ and/or $C$ are poorly conditioned or even singular.
In that case, one can try to regularise them by writing

$$
   A \speq (B+\alpha \mathbf I) + (C-\alpha \mathbf I)
$$

for some $\alpha>0$ which will shift the minimum singular value of $B$ and $C$ away from zero (and thereby push them towards diagonally dominant matrices).
The fixed-point corresponding to this split is

$$
   (B+\alpha \mathbf I) x \speq b-(C-\alpha\mathbf I)x. \label{dpr-fp-1}
$$

Observe that for a suitably large $\alpha$ we could also consider the fixed-point derived from \eqref{dpr-fp-1} where the role of $B$ and $C$ are swapped.
The resulting fixed point equation is equivalent to \eqref{dpr-fp-1} but the fixed-point iteration is not and the DPR method suggests alternating between both.

@@colbox-blue
(**DPR iterative method**) let $Ax=b$ and $A=B+C$, the DPR iterative method is given by
$$
\begin{cases}
   (B+\alpha\mathbf I)x_{k+1} &=\esp (b+(\alpha \mathbf I - C)z_k)\\
   (C+\alpha\mathbf I)z_{k+1} &=\esp (b+(\alpha \mathbf I-B)x_{k+1})
\end{cases}
$$
and converges to the solution provided $\alpha$ is sufficiently large.
@@

This method belongs to a class of method known as *alternating direction methods*...

### DPR splitting for the kernel

Consider now the kernel problem i.e. finding $x$ such that $Ax=0$ (i.e. $b=0$) still with $A=(B+C)$.
Let $y=Cx=-Bx$ then we can consider a triplet of fixed points:

$$
\begin{cases}
   (B+\alpha\mathbf I) x &=\esp (\alpha\mathbf I - C)x + \textcolor{blue}{(Cx-y)}\\
   (C+\alpha\mathbf I)x &=\esp (\alpha\mathbf I - B)x - \textcolor{blue}{(-Bx-y)}\\
   \textcolor{blue}{y} &=\esp \textcolor{blue}{Cx}
\end{cases}
$$

We can then intertwine the corresponding fixed-point iterations as follows:

$$
\begin{cases}
   (B+\alpha\mathbf I) x_{k+1} &=\esp (\alpha\mathbf I - C)z_k + (Cz_k-y_k)\\
   (C+\alpha\mathbf I) z_{k+1} &=\esp (\alpha\mathbf I - B)x_{k+1} - (-Bx_{k+1}-y_k)\\
   \textcolor{blue}{y_{k+1}} &=\esp Cz_{k+1}
\end{cases}
$$

Let now $u_k=y_k/\alpha$ and note that $Cz_{k+1}= (\alpha x_{k+1} + y_k - \alpha z_{k+1}) = \alpha(x_{k+1} + u_k - z_{k+1})$ using the second iteration.
This leads to an iterative method to solve $Ax=0$ which we will show to be directly connected to the ADMM.


@@colbox-blue
(**DPR iterative method (2)**) let $Ax=0$ and $A=B+C$, the DPR2 iterative method is given by
$$
\begin{cases}
   (B+\alpha\mathbf I)x_{k+1} &=\esp \alpha(z_k - u_k)\\
   (C+\alpha\mathbf I)z_{k+1} &=\esp \alpha(z_k + u_k)\\
   u_{k+1} &=\esp u_k + x_{k+1} - z_{k+1}
\end{cases}
\label{DPR2}
$$
and converges to the solution provided $\alpha$ is sufficiently large.
@@


## From linear algebra back to convex optimisation

Going back to problem \eqref{decomposable-pb}, we had noted that a minimiser must be in the kernel of $(\partial f+\partial g)$:

$$ 0 \spe{\in} (\partial f+\partial g)(\xopt). $$

Since we've just seen that splitting operators could be a good idea in linear algebra, we could be tempted to apply exactly the same approach here.
But in order to do this, we need to consider the inverse of the following two operators: $(\partial f+\alpha \mathbf I)$ and $(\partial g+\alpha \mathbf I)$.

### Proximal operators

Proximal operators can be recovered from a number of nice perspectives and are usually attributed to Moreau (see e.g. \cite{moreau65}).
Here we'll just cover it briefly aiming to define the prox of a function $f$ denoted $\mathrm{prox}_f$ and show a key result, i.e.: that $\mathrm{prox}_f \equiv (\partial f+\mathbf I)\inv$.

Let $x$ and $z$ be such that $z \in (\partial f + \mathbf I)(x)$. We are interested in the inverse map or, in other words, in having $x$ in terms of $z$.
Rearranging the equation note that we have

$$
   0 \spe{\in} \partial f(x) + (x-z). \label{prox-step1}
$$

Observe that the simple linear functional $(x-z)$ can be re-expressed as the gradient of a squared $\ell^2$ norm:

$$
\partial \left[\frac12\|x-z\|_2^2\right] \speq x-z.
$$ <!--_-->

Therefore, we can write \eqref{prox-step1} as

$$
   0 \spe{\in} \partial \left[f + {1\over 2}\|\cdot-z\|_2^2\right] (x).
$$<!--_-->

This can be interpreted as a first order condition (FOC) and is equivalent to

$$
   x \spe{\in} \arg\min_u \, f(u)+{1\over 2}\|u-z\|_2^2 \label{obj-prox}
$$ <!--_-->

which *defines* the prox of $f$.

@@colbox-blue
For a convex function $f$, the proximal operator of $f$ at a point $z$ is defined as
$$
   \mathrm{prox}_f(z) \speq \arg\min_u \, f(u)+\frac12\|u-z\|_2^2
$$
and is such that $\mathrm{prox}_f \equiv (\partial f + \mathbf I)\inv$.
@@ <!--_-->

Note that $(\partial f+\alpha \mathbf I) = \alpha (\partial (\alpha\inv f)+\mathbf I)$ so that

$$ \alpha(\partial f + \alpha \mathbf I)\inv \spe{\equiv} \prox_{\alpha\inv f}. $$

Note also that if $\alpha$ is sufficiently large, then the objective in \eqref{obj-prox} is strongly-convex and therefore can only have a unique minimiser meaning that $\prox_{\alpha\inv f}$ is then a well-defined function.

**Remark**: it may look like we just conjured this proximal operator out of the abyss for nothing but it turns out that a proximal operator exists in closed form for a number of important functions.
Among the most known examples is the $\ell^1$-norm whose prox is the *soft-thresholding operator* and the $\iota_C$ indicator of a convex set whose proximal operator is the *orthogonal projection* on that set.

### ADMM

Hopefully you saw this one coming: if you take DPR2 \eqref{DPR2} and simply replace $B$ by $\partial f$, $C$ by $\partial g$ and pepper with $\prox$ you get the ADMM (see e.g. \cite{combettes11}).

@@colbox-blue
(**Alternative direction method of multipliers (ADMM)**) the minimisation problem \eqref{decomposable-pb} can be tackled with the following elegant iteration:
$$
\begin{cases}
   x_{k+1} &=\esp \prox_{\gamma f}(z_k-u_k)\\
   z_{k+1} &=\esp \prox_{\gamma g}(x_{k+1}+u_k)\\
   u_{k+1} &=\esp u_k + x_{k+1} - z_{k+1}
\end{cases}
$$
which converges provided $\gamma>0$ is small enough.
@@

**When is this helpful?**: a frequent scenario has $f$ complex but differentiable and $g$ simple but non-differentiable (e.g. $\ell^1$-norm); in that case, the first prox is a differentiable problem that can be (approximately) solved using a simple/cheap first-order method and the second prox exists in closed form. For instance, regularised maximum likelihood estimation or regularised inverse problems typically have this form.

## References

**Proximal methods**
1. \biblabel{combettes11}{Combettes and Pesquet (2011)} **Combettes** and **Pesquet**, [Proximal splitting methods in signal processing](https://www.ljll.math.upmc.fr/~plc/prox.pdf), 2011. -- A detailed review on proximal methods, accessible and comprehensive.
1. \biblabel{moreau65}{Moreau (1965)} **Moreau**, [Proximité et dualité dans un espace hilbertien](http://www.numdam.org/article/BSMF_1965__93__273_0.pdf), 1965. -- A wonderful seminal paper, clear and complete, a great read if you understand French (and even if you don't you should be able to follow the equations).

**Linear algebra**
1. \biblabel{peaceman55}{Peaceman and Rachford (1955)} **Peaceman** and **Rachford**, [The numerical solution of parabolic and elliptic differential equations](http://www.jstor.org/discover/10.2307/2098834?sid=21106114630493&uid=2&uid=70&uid=4&uid=3738032&uid=2129), 1955.
1. \biblabel{douglas56}{Douglas and Rachford (1956)} **Douglas** and **Rachford**, [On the numerical solution of heat conduction problems in two and three space variables](http://www.ams.org/journals/tran/1956-082-02/S0002-9947-1956-0084194-4/S0002-9947-1956-0084194-4.pdf), 1956.
1. \biblabel{ortega00}{Ortega and Rheinboldt (2000)} **Ortega** and **Rheinboldt**, Iterative solutions of nonlinear equations in several variables, 2000.
