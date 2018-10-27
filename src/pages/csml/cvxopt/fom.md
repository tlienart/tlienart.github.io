@def title = "First order methods"

# Thoughts on first order descent methods

First order methods broadly designate iterative methods for continuous and differentiable optimisation that mainly use information coming from the gradient of the function at the current point.
The success of first order methods is often related to the fact that iterations are cheap to compute compared to, say, second order methods that use information coming from the hessian of the function at the current point.

In these notes we consider again the constrained minimisation problem $\min_C f$ and, to simplify the presentation, we'll assume that $C$ is closed and convex and that $f$ is strictly convex and smooth on $C$.
What we're interested in is discussing, at a high level, how to generate a _minimising sequence_ for $f$ i.e., a sequence $\{x_k\}$ with $x_k\in C$ such that $f(x_{k+1}) < f(x_k)$ and $f(x_k) \to f(\xopt)$ as $k$ grows.

All norms $\|\cdot\|$ are 2-norms unless otherwise mentioned.

## Local linearisation

Local linearisation is basically what first order methods are about: form a linear approximation of the function around a current point.
Still, let's try to look at this from scratch: consider the local linearisation of $f$ around a point $a\in C^\circ$:

$$ f(x) \speq f(a) + \scal{x-a, \nabla f(a)} + r(x, a) $$

where $r(x, a)$ is the _remainder function_.

**Note**: here you may be thinking: _Taylor expansion_, but actually let's put that on the side for now and just assume that you're building this $f(a)+\scal{x-a,\nabla f(a)}$ and that you want to investigate the properties of the remainder function.

That function enjoys the following properties:

1. $r(a, a)=0$, and $r(x, a)>0$ for all $x\neq a$ by strict convexity of $f$,
1. $r(\cdot, a)$ is also strictly convex and smooth for all $a\in C^\circ$.

Let us now introduce the following notation: $r_a(\delta) := r(a+\delta, a)$ which will be quite useful.
It is easy to note that $r_a$ is smooth and strictly convex with $r_a(0)=0$ and, in fact, is globally minimised at $0$.
By definition of strict convexity, we have

$$ r_a(\delta') \spe{>} r_a(\delta) + \scal{\delta'-\delta, \nabla r_a(\delta)}, \quad \forall\delta' \neq \delta. $$

Taking $\delta'=0$ and rearranging terms yields

$$ r_a(\delta) \spe{<} \scal{\delta, \nabla r_a(\delta)} \spe{\le} \|\delta\|\|\nabla r_a(\delta)\|, $$

using Cauchy-Schwartz for the second inequality.
Rearranging again gives $r_a(\delta)/\|\delta\| < \|\nabla r_a(\delta)\|$ for all $\delta\neq 0$.
Since $r_a$ is smooth away from $0$ and since $\nabla r_a(0)=0$ (minimiser), we can take the limit on both sides of the inequality as $\|\delta\|\to 0$ and get the following result.

@@colbox-blue
The function $r_a$ is $o(\|\delta\|)$ meaning
$$ \lim_{\|\delta\|\to 0} {r_a(\delta)\over \|\delta\|} \speq 0. $$
@@

This could have been obtained directly from consider the Taylor expansion of $f$ but I think it's nice to obtain it using only the notion of convexity.
Another note is that the reasoning still holds if $f$ is only convex and sub-differentiable (though you'd need to be a bit careful )


## Admissible descent steps

Let's now consider a point $x$ in $C$ and a step from $x$ to $x+\delta$ for some $\delta\neq 0$.
Using the notations from the previous point, we have

$$ f(x+\delta) \speq f(x)+\scal{\delta, \nabla f(x)} + r_x(\delta). $$

Such a step will be called an _admissible descent step_ if $x+\delta\in C$ and if it decreases the function, i.e. if $f(x+\delta) < f(x)$ or:

$$ \scal{\delta, \nabla f(x)} + r_x(\delta) \spe{<} 0. $$

@@colbox-red
ongoing
@@

## References

1. \biblabel{elghaoui12}{El Ghaoui (2012)} **El Ghaoui**, [Interior-Point Methods](https://people.eecs.berkeley.edu/~elghaoui/Teaching/EE227A/lecture19.pdf), 2012. Lecture notes at Berkeley, covering another topic (IPMs) but also summarising descent methods in general.
