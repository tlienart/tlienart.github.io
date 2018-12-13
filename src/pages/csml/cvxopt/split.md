@def title = "Splitting methods"
<!-- @def hascode = true -->

# Splitting methods

In these notes, I show how some well known methods from numerical linear algebra can be applied to convex optimisation.
The aim of these notes is to give an idea for how the following topics intertwine:

* solving a system of linear equations via iterative methods
* operator splitting techniques (*Gauss-Seidel*, *Douglas-Rachford*),
* monotone operators and proximal methods,
* the *alternating direction methods of multipliers* also known as ADM or ADMM

## From convex optimisation to linear algebra

### Decomposable problems
In convex optimisation, a large portion of the problems can be written in the form:
$$ \xopt \spe{\in} \arg\min_x\,\, f(x) + g(x).$$
This includes constrained problems where $g\equiv \iota_C$ for a convex set $C$ for instance or penalised problems like the LASSO regression:
$$ \xopt \spe{\in}\arg\min_x\,\, \frac12\|Ax-b\|_2^2 + \lambda\|x\|_1$$ <!--_-->

In a similar vein as for the previous notes, the following regularity conditions are usually assumed to hold:
1. $f, g\in \Gamma_0$, the space of convex, proper, lower semi-continuous functions,
2. $f, g$ are such that on $\mathrm{dom}\, f \cap \mathrm{dom}\, g$, $\partial(f+g)=\partial f+\partial g$.

As we showed in [convex analysis part 1](\cvx{ca1.html}), for $\xopt$ to be a minimiser, it must verify the first order condition, i.e.:

$$ 0 \spe{\in} (\partial f+\partial g)(\xopt), $$

the issue being that, in most cases, we don't have a (cheaply available) closed-form expression for the inverse operator (otherwise the problem is trivial).

This issue can in fact be related to the classical problem of solving a linear system of equations:

$$ Ax \speq b \label{linsyst}$$

where $A$ is invertible but is (for example) too big or too poorly condition for its inverse to be computable cheaply and reliably.

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
For instance if $A$ is symmetric, positive definite then Gauss-Seidel converges.
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

Researchers like **Douglas**, **Peaceman** and **Rachford** studied this extensively in the mid 1950s to solve linear systems arising from the discretisation of systems of partial differential equations \citep{peaceman55, douglas56}.
They came up with what is known as the *Douglas-Rachford* splitting and the *Peaceman-Rachford* splitting.

The context is simple, assume that we have a decomposition $A=B+C$ where $B$ and/or $C$ are poorly conditioned or even singular.
In that case, one can try to regularise them by writing

$$
   A \speq (B+\alpha \mathbf I) + (C-\alpha \mathbf I)
$$

for some $\alpha>0$ which will shift the minimum singular value of $B$ and $C$ away from zero.
The fixed-point corresponding to this splitting is

$$
   (B+\alpha \mathbf I) x \speq (b-(C-\alpha\mathbf I)x). \label{dpr-fp-1}
$$

Observe that for a suitably large $\alpha$ we could also consider the fixed-point derived from \eqref{dpr-fp-1} where the role of $B$ and $C$ are swapped.
The resulting fixed point equation is equivalent to \eqref{dpr-fp-1} but the fixed-point iteration is not and the DPR method suggests alternating between both.

@@colbox-blue
(**DPR iterative method**) let $Ax=b$ and $A=B+C$, the DPR iteration is given by
$$
\begin{cases}
   (B+\alpha\mathbf I)x_{k+1} &=\esp (b+(\alpha \mathbf I - C)z_k)\\
   (C+\alpha\mathbf I)z_{k+1} &=\esp (b+(\alpha \mathbf I-B)x_{k+1})
\end{cases}
$$
@@

This iteration belongs to a class of method known as *alternating direction methods*...


## From linear algebra back to convex optimisation

### Proximal operators

### ADMM

## References

**Proximal methods**
1. \biblabel{combettes11}{Combettes and Pesquet (2011)} **Combettes** and **Pesquet**, [Proximal splitting methods in signal processing](https://www.ljll.math.upmc.fr/~plc/prox.pdf), 2011. -- A detailed review on proximal methods, accessible and comprehensive.
1. \biblabel{moreau65}{Moreau (1965)} **Moreau**, [Proximité et dualité dans un espace hilbertien], 1965. -- A wonderful seminal paper, clear and complete, a great read if you understand French (and even if you don't you should be able to follow the equations).

**Linear algebra**
1. \biblabel{peaceman55}{Peaceman and Rachford (1955)} **Peaceman** and **Rachford**, [The numerical solution of parabolic and elliptic differential equations](http://www.jstor.org/discover/10.2307/2098834?sid=21106114630493&uid=2&uid=70&uid=4&uid=3738032&uid=2129), 1955.
1. \biblabel{douglas56}{Douglas and Rachford (1956)} **Douglas** and **Rachford**, [On the numerical solution of heat conduction problems in two and three space variables](http://www.ams.org/journals/tran/1956-082-02/S0002-9947-1956-0084194-4/S0002-9947-1956-0084194-4.pdf), 1956.
1. \biblabel{ortega00}{Ortega and Rheinboldt (2000)} **Ortega** and **Rheinboldt**, Iterative solutions of nonlinear equations in several variables, 2000.
