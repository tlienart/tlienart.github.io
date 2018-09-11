@def title = "Convex Optimisation I"

<!--
TODO:

* add link to gradient descent (last paragraph before references)
* add link to mirror descent (same place)
-->

# Convex Optimisation (part. 1)

> *If you haven't already, please take a minute to read !LINK HERE! explaining the approach taken in the notes on this website.*

In these notes, we consider the standard *constrained minimisation problem* in convex optimisation:

$$
	\min_{x\in C}\quad f(x)
$$

where $C$ is a *nice* convex set and $f$ a *nice* convex function.
Usual assumptions of *niceness* (that are typically verified in problems of interest) are:

* $C$ is *closed*, has *non-empty interior* and is a subset of $\mathbb R^n$,
* $f$ is in the set $\Gamma_0(X)$ of convex functions on $X$ that are *proper* and *lower semi-continuous*,
* one can compute a gradient or subgradient of $f$ at a given point.

Roughly speaking, these conditions guarantee that there is a solution to the problem and that we can find one applying some simple iterative algorithm.
We shall try to make these assumptions clearer as we get to use them throughout the notes (and, it is therefore not required to look them up on Wikipedia quite just yet).

We will also consider the unconstrained form of the problem, i.e.: when $C=\mathbb R^n$ (and will then just write $\min_x f(x)$).
Constrained problems can always be interpreted as unconstrained problems: indeed, if we define the *indicator* of a convex set $C$ as

$$
	i_C(x) = \begin{cases} 0 & (x\in C) \\\\ +\infty & (x\notin C) \end{cases}
$$

then the constrained problem can be written as

$$
	\min_x f(x)+i_C(x).
$$

This is not entirely pointless as will become apparent when deriving the projected gradient descent.

## Iterative methods

So far we have kept concepts at a high level, there will be enough occasions to delve into the details but it's important to understand how algorithms for optimisation are (generally) designed.

A big part of convex optimisation aims at defining clever *iterative algorithms* which, ideally, enjoy the following properties when started from a sensible initial point $x_0$:

* the iterations converge "quickly" to a minimiser (i.e. a point $x^\sharp$ such that $f(x)\ge f(x^\sharp)$ for all $x\in C$)
* the iterations are "cheap" to compute.

Often these iterative algorithms can be derived from some kind of *fixed point equation* that is satisfied by a minimiser, i.e.: an equation of the form

$$
	x^\sharp = P(x^\sharp)
$$

where $P$ is some appropriate operator and $x^\sharp$ is a minimiser.
Provided we have such a fixed point equation, we can consider a *fixed point algorithm* with the simplest form being:

$$
	x_{k+1} = P(x_k).
$$

Under some conditions on the operator $P$ and possibly on $x_0$, such an  algorithm will provably converge to $x^\sharp$.

In the rest of these notes, we will show how to obtain the fixed point equations and useful fixed point algorithms for a variety of scenarios and, by doing so, will recover well known algorithms such as the classical gradient descent as well as more sophisticated algorithms such as the mirror descent.

## General references

More precise pointers will be given on subsequent pages but most of the content in these notes relates in some way or another to the following references (in particular the first one):

1. **Rockafellar**: [Convex analysis](http://press.princeton.edu/titles/1815.html). Probably the best book in convex analysis. A reference of choice for technical details.
2. **Nesterov**: [Introductory Lectures on Convex Optimization](https://www.springer.com/us/book/9781402075537). Another must-read with all the technical details.
3. **Boyd** and **Vandenberghe**: [Convex Optimization](https://stanford.edu/~boyd/cvxbook/). More accessible and more oriented towards giving "tools" to the reader.
