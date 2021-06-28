+++
title = "First order methods"
descr = """
  First order methods, minimising sequence, admissible direction, and the Generalised
  Projected Gradient Descent (again).
  """
tags = ["optimisation", "projected gradient descent", "prospective"]
+++

{{redirect /pub/csml/cvxopt/fom.html}}

<!-- need to justify / structure what you're doing here. -->

# Thoughts on first order descent methods

{{page_tags}}

> This is an experimental set of notes, take it with appropriate care.

First order methods (FOM) broadly designate iterative methods for continuous and (sub)differentiable optimisation that mainly use information from the (sub)gradient of the function.

In these notes we consider again the constrained minimisation problem $\min_{x\in C} f(x)$ and, to simplify the presentation, we'll assume that $C$ is closed and convex and that $f$ is strictly convex and smooth on $C$.

What we're interested in, at a high level, is how to generate a _minimising sequence_ for $f$ i.e., a sequence $\{x_k\}$ with $x_k\in C$ such that $f(x_{k+1}) < f(x_k)$ and $f(x_k) \to f(\xopt)$ as $k$ grows.

_Remark_: all norms $\|\cdot\|$ on this page are 2-norms.

\toc

## Local linearisation

Local linearisation is basically what first order methods are about: form a linear approximation of the function around a current point and use that to move towards a promising direction.
Still, let's try to look at this from scratch.

Consider the local linearisation of $f$ around a point $a\in C^\circ$:

$$ f(x) \speq f(a) + \scal{x-a, \nabla f(a)} + r(x, a) $$

where $r(x, a)$ is the _remainder function_.

**Note**: here you may be thinking: _Taylor expansion_. But let's actually put that on the side for now and just assume that you're building this $f(a)+\scal{x-a,\nabla f(a)}$ and that you want to investigate the properties of the remainder function.

That function enjoys the following properties:

1. $r(a, a)=0$, and $r(x, a)>0$ for all $x\neq a$ by strict convexity of $f$,
1. $r(\cdot, a)$ is also strictly convex and smooth for all $a\in C^\circ$.

Let us introduce a more compact notation: $r_a(\delta) := r(a+\delta, a)$ which will be quite useful.
It is easy to note that $r_a$ is smooth and strictly convex with $r_a(0)=0$ and, in fact, is globally minimised at $0$.
By definition of strict convexity, we have

$$ r_a(\delta') \spe{>} r_a(\delta) + \scal{\delta'-\delta, \nabla r_a(\delta)}, \quad \forall\delta' \neq \delta. $$

Taking $\delta'=0$ and rearranging terms yields

$$ r_a(\delta) \spe{<} \scal{\delta, \nabla r_a(\delta)} \spe{\le} \|\delta\|\|\nabla r_a(\delta)\|, $$

using Cauchy-Schwartz for the second inequality.
Rearranging again gives $r_a(\delta)/\|\delta\| < \|\nabla r_a(\delta)\|$ for all $\delta\neq 0$.
Since $r_a$ is smooth away from $0$ and since $\nabla r_a(0)=0$ (minimiser), we can take the limit as $\|\delta\|\to 0$ and get the following result.

@@colbox-blue
The function $r_a$ is $o(\|\delta\|)$ meaning
$$ \lim_{\|\delta\|\to 0} {r_a(\delta)\over \|\delta\|} \speq 0. \label{remainder is small-o}$$
@@

This could have been obtained directly from the Taylor expansion of $f$ but I think it's nice to obtain it using only notions of convexity.
Another note is that the reasoning essentially still holds if $f$ is only convex and sub-differentiable.


## Admissible descent steps

Let's consider a point $x$ in $C$ and a step from $x$ to $x+\delta$ for some $\delta\neq 0$.
We're interested in determining what are "good" steps $\delta$ to take.
Using the notations from the previous point, we have

$$ f(x+\delta) \speq f(x)+\scal{\delta, \nabla f(x)} + r_x(\delta). $$

Such a step will be called an _admissible descent step_ if $x+\delta\in C$ and if it decreases the function, i.e. if $f(x+\delta) < f(x)$ or:

$$ \scal{\delta, \nabla f(x)} + r_x(\delta) \spe{<} 0. \label{admissibility}$$

Let $\mathcal D_x$ be the set of admissible descent steps from $x$; it is non-empty provided that $0<\|\nabla f(x)\|<\infty$. To show this, let $\delta_\epsilon := -\epsilon(g+v)$ with $\epsilon > 0$ and
* $g=\nabla f(x)/\|\nabla f(x)\|$ (the unit vector in the direction of the gradient),
* $v$ orthogonal to $g$ i.e. such that $\scal{v, \nabla f(x)}=0$, and such that $0 < \|v\|\le 1$.
Then just by plugging things in we have
$$\scal{\delta_\epsilon, \nabla f(x)} + r_x(\delta_\epsilon) \speq -\epsilon + r_x(\epsilon(g+v)) $$
but recall that $r_x(\epsilon(g+v)) = o(\epsilon\|g+v\|)$ by \eqref{remainder is small-o}.
And since $g$ and $v$ are fixed, $r_x(\epsilon(g+v)) = o(\epsilon)$.
As a result, for sufficiently small $\epsilon$, the right-hand-side is negative and the condition \eqref{admissibility} holds for $\delta_\epsilon$.

@@colbox-blue
For sufficiently small $\epsilon$, $\delta_\epsilon=-\epsilon(g+v)$ is an admissible descent step.
@@

Note that, by construction, these $\delta_\epsilon$ span a half-ball of radius $\epsilon$ so that $\mathcal D_x$ is non-empty and also non-degenerate.

@@colbox-blue
Let $w$ be such that $0<\|w\|=:\eta$ and $\scal{w, \nabla f(x)}<0$, then, provided $\eta$ is small enough, $w\in\mathcal D_x$.
@@

Obviously, what we would like is to get the _best possible step_:

$$ \deltaopt \spe{\in} \arg\min_{\delta \mid x+\delta \in C} \,\, \left[\scal{\delta, \nabla f(x)}+r_x(\delta)\right] \label{optimal step}  $$

which leads directly to the minimiser $\xopt = x+\deltaopt$.
Of course that's a bit silly since solving \eqref{optimal step} is as hard as solving the original problem.
However the expression \eqref{optimal step} will help us generate descent algorithms.

## Local update schemes

What we would like is thus to consider a problem that is simpler than \eqref{optimal step} and yet still generates an admissible descent direction (and iterate).
A natural way to try to do just that is to replace $r_x(\delta)$ by _a proxy function_ $d_x(\delta)$ enjoying the same properties of positive definiteness and strict convexity.
The corresponding approximate problem is then

$$ \tilde\delta_\beta \spe{\in} \arg\min_{\delta \mid x+\delta \in C} \left[\scal{\delta, \nabla f(x)} + \beta d_x(\delta)\right]. \label{approx step}$$

Let's now show that these problems can lead to admissible descent steps for the original problem.
We can follow a similar reasoning to that which led us to show the non-degeneracy of $\mathcal D_x$.
In particular, observe that as $\beta\to\infty$, $\|\tilde\delta_{\beta}\|\to 0$.
Hence, there exists a $\beta^\bullet$ large enough such that for any $\nu \ge \beta^\bullet$, $\|\tilde\delta_\nu\|$ is small enough for $\tilde\delta_\nu$ to be in $\mathcal D_x$.

### GPGD is back

Now that we know that \eqref{approx step} can lead to an admissible step, we can suggest iterating over the problem with a sequence of $\{\beta_k\}$:

$$ \tilde\delta_{\beta_k} \spe{\in} \arg\min_{\delta\mid x_k+\delta \in C} \,\, \left[\scal{\delta, \nabla f(x_k)} + \beta_kd_x(\delta_k)\right].$$

However, basic manipulation of that expression show that this is in fact the generalised projected gradient descent (GPGD) that we [saw before](\cvx{mda.html}).

@@colbox-blue
The generalised projected gradient descent (GPGD) corresponds to the following iteration:

$$ x_{k+1} \spe{\in} \arg\min_{x\in C} \left\{\scal{x, \nabla f(x_k)} + {1\over \alpha_k}d(x, x_k)\right\} $$

for some $\alpha_k>0$ and for any positive-definite function $d$ that is strictly convex in its first argument. It generates a minimising sequence for $f$ provided the $\alpha_k$ are small enough.
@@

This may seem like it's not telling us that much, in particular it should be clear that you could pick the $\alpha_k$ infinitesimally small, that it would indeed give you a minimising sequence but also that it wouldn't bring you very far.
So at this point there's two comments we can make:

1. ideal $\alpha_k$ encapsulate a tradeoff between leading to steps that are too big and may not be admissible an steps that are too small to provide useful improvement,
1. a key element that should hopefully be obvious by now corresponds to how we can interpret $d$: if we know nothing about the function at hand, we can just use a default $\|\cdot\|_2^2$ but if we _do_ know something useful about the function (and, in fact, about $C$), then that could be encoded in $d$.

### Choice of distance and problem structure

The second point is _very important_: it should be clear to you that you'd want the local problems to be as informed as possible while at the same time you'd want the iterations to not be overly expensive to compute, two extreme cases being:

* $d(x, x_k)/\alpha_k = \|x-x_k\|_2^2/{2\alpha_k}$ <!--_--> and $\alpha_k$ small, the iterations are cheap to compute but potentially quite poor at decreasing the function, many steps are needed, minimal use of problem structure,
* $d(x, x_k)/\alpha_k = r(x, x_k)$, the iteration is maximally expensive but only a single step is needed; maximal use of problem structure.

This key tradeoff can be exposed in most iterative methods using gradient information that you'll find in the literature.

## References

1. \biblabel{elghaoui12}{El Ghaoui (2012)} **El Ghaoui**, [Interior-Point Methods](https://people.eecs.berkeley.edu/~elghaoui/Teaching/EE227A/lecture19.pdf), 2012. -- Lecture notes at Berkeley, covering another topic (IPMs) but also summarising descent methods in general.
