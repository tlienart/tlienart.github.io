+++
title = "Projected gradient descent"
descr = """
    Normal cone, Euclidean projection, and the Projected Gradient Descent (PGD).
    """
tags = ["optimisation", "projected gradient descent"]
+++

{{redirect /pub/csml/cvxopt/pgd.html}}

# Projected gradient descent

{{page_tags}}

Here we will show a general method to approach a constrained minimisation problem of a convex, differentiable function $f$ over a closed convex set $C\subset \R^n$.
Such problems can be written in an unconstrained form as we discussed in the [introduction](/posts/2018/09/13-convex-optimisation-intro/)

\eqa{ \min_x\esp f(x) + i_C(x),}

where $i_C$ is the indicator function associated with the set.

To get to the method, we will need three main parts:

1. discuss the first order condition (FOC) of the problem which will bring us to the notion of _normal cone_,
2. discuss how the _normal cone_ relates to the _Euclidean projection_,
3. introduce the _projected gradient descent_ algorithm.

\toc

## First order condition

The FOC indicates that $\xopt \in C$ is a minimiser if and only if $0\in \partial(f + i_C)(\xopt)$.
However, remember that the subdifferential of a sum contains the sum of subdifferentials (see [convex analysis pt. 2](/posts/2018/09/24-convex-optimisation-2/)) so that if $0 \in \nabla f(\xopt) + \partial i_C(\xopt)$ then $\xopt$ is a minimiser.

If $y$ is a subgradient of $i_C$ at a point $x\in C$ then, by definition,

\eqa{
    i_C(z) &\ge& i_C(x) + \scal{z-x, y}, \quad\forall z.
}

For any $z\notin C$, this inequality is trivially verified since the left hand side is infinite.
Letting $z\in C$ and since $x\in C$ so that $i_C(x)=i_C(z)=0$, we are left with

\eqa{
    0 &\ge& \scal{z-x, y}, \quad\forall z\in C.
}

This inequality defines the subdifferential $\partial i_C$ but also happens to be the definition of the **normal cone** to the convex set $C$ at $x$ denoted $N_C(x)$.
In short:
\eqa{\partial i_C(x) &=& \{y\in \R^n \,\mid\, \scal{z-x, y}\le 0, \forall z\in C\}\speq  N_C(x).}
Bringing the pieces together, we have
$$   0 \,\in\, \nabla f(\xopt) + N_C(\xopt) \spe{\Longrightarrow} \xopt \,\in\,\arg\min_{x\in C}\, f(x). \label{partial FOC}$$

Of course this doesn't really help much because at this point we don't know how to find a $\xopt$ such that the left-hand-side holds.
This is what the next section will explore.

## Normal cone and Euclidean projection

A useful (and obvious) property of the normal cone which we shall use in the sequel is that it is invariant under non-negative scalar multiplication, i.e.:

\eqa{ \mathrm{if}\,\, u\in N_C(x)\,\,\mathrm{then}\,\, \alpha u\in N_C(x), \,\forall \alpha \ge 0. \label{nc scaling}}

We will now show the connection between the normal cone and the Euclidean projection on $C$.
Remember that the Euclidean projection onto $C$ (denoted $\pi_C$) is defined as follows for any $z\in \R^n$:

$$   \pi_C(z) \speq \arg\min_{x\in C}\,\, \frac12\|x-z\|_2^2 \label{eq projection}$$

Note that in the _unconstrained problem_, $C=\R^n$ and hence $\pi_C=\mathbb I$, the identity operator.
Note also that the factor $1/2$ is here for aesthetics when computing the gradient which is then just $(x-z)$.

Considering the condition \eqref{partial FOC} for the optimisation problem \eqref{eq projection}, we have that if

\eqa{  0\,\in\, (\xopt-z) + N_C(\xopt) }

then $\xopt$ is a minimiser with thus $\xopt = \pi_C(z)$.
This is equivalent to $z \in \xopt + N_C(\xopt)$ or $z\in (\mathbb I + N_C)(\xopt)$.
Replacing $\xopt$ by $\pi_C(z)$ and re-arranging terms gives

\eqa{  \pi_C(z) &=& (\mathbb I + N_C)^{-1}(z). }

This is a classical and important relationship.

@@colbox-blue
Let $C$ denote a convex subset of $\R^n$ then
\eqa{\pi_C &\equiv& (\mathbb I+ N_C)^{-1}. \label{proj equiv}}
@@

## Projected gradient descent

We indicated at \eqref{nc scaling} that for any $\alpha \ge 0$ and $u\in N_C(x)$, then $\alpha u\in N_C(x)$.
We can rewrite this as:

\eqa{(x+\alpha u) - x &\in& N_C(x), \label{eq 1}}

which may seem pointless but will lead us to a fixed-point algorithm (remember from [the introduction](/posts/2018/09/13-convex-optimisation-intro/) that many algorithms for convex optimisation can be expressed in terms of fixed point algorithms).

Let $z:=(x+\alpha u)$ so that \eqref{eq 1} can be rearranged to $z\in (\mathbb I+N_C)(x)$.
By \eqref{proj equiv}, this is equivalent to $x=\pi_C(z)$ or

\eqa{   x &=& \pi_C(x+\alpha u), \quad (\alpha \ge 0, \,u\in N_C(x)).   \label{fixed point 1}}

To finish up, let's go back once more to the FOC \eqref{partial FOC} which indicates that if $\xopt$ is such that $-\nabla f(\xopt) \in N_C(\xopt)$ then it is a minimiser.
Combined with \eqref{fixed point 1}, we get the following useful fixed-point form for the minimiser of the constrained problem:

@@colbox-blue
$$ \xopt \speq \pi_C(\xopt - \alpha \nabla f(\xopt)). \label{pgd fixed point} $$
@@

**Note**: had we not assumed that $f$ was differentiable on $C$, we would still have that there exists a subgradient $f'(\xopt) \in \partial f(\xopt)$ with $-f'(\xopt)\in N_C(\xopt)$ and consequently the fixed-point $\xopt = \pi_C(\xopt - \alpha f'(\xopt))$ leading the _projected subgradient method_.
In practice however, one tries to cast a convex objective function as a sum of a smooth function with a non-smooth one, to follow a gradient descent on the smooth part and use a projection for the non-smooth part (this is the case here with $i_C$ being the non-smooth part).

### The algorithm

Well there's not much left to do.
Applying a fixed-point iteration to \eqref{pgd fixed point} from a starting point $x_0$ generates the sequence $\{x_0, x_1, \dots\}$ via

\eqa{   x_{k+1} &=& \pi_C(x_k - \alpha_k \nabla f(x_k)) }

where $\alpha_k > 0$ is the _step size_ (ignoring the trivial case $\alpha_k=0$).
This is the _projected gradient descent_ method.

Assuming that the $\alpha_k$ are picked sensibly and basic regularity conditions on the problem are met, the method enjoys a convergence rate
$(f(x_k)-f(\xopt)) = \mathcal O(k^{-1})$ (see references for more).

**Note**: this method is pretty easy to apply _provided you can compute the projection_. Of course, there may be situations for which computing the projection is as hard as the initial problem! But there are many special cases where efficient projection can be applied (e.g. if $C$ is a polyhedron, i.e. corresponds to a set of $x$ such that $Ax\le b$ for some matrix $A$ and vector $b$).
See for example \citet{liu09}.

## Additional references

1. **Burke**, [The Gradient Projection Algorithm](https://sites.math.washington.edu/~burke/crs/408/notes/nlp/gpa.pdf), 2014. Lecture notes at the University of Washington covering the topic in a bit more depth.
1. **Saunders**, [Notes on First-Order Methods for Minimizing Smooth Functions](https://web.stanford.edu/class/msande318/notes/notes-first-order-smooth.pdf), 2017. -- Lectures notes at Stanford covering the topic (among others) and proving the linear convergence rate under regularity conditions.
1. \biblabel{liu09}{Liu and Ye (2009)} **Liu**, **Ye**, [Efficient Euclidean Projections in Linear Time](https://icml.cc/Conferences/2009/papers/123.pdf), 2009. -- A paper describing the projection problem and how it can be done efficiently in some cases.

*See also the general references mentioned in the [introduction](/posts/2018/09/13-convex-optimisation-intro/).*
