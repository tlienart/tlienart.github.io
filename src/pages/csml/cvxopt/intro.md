@def title = "Convex Optimisation I"

<!--
TODO:

* add link to gradient descent (last paragraph before references)
* add link to mirror descent (same place)
-->

# Introduction

In these notes, we consider the standard *constrained minimisation problem* in convex optimisation:

$$
	\min_{x\in C}\quad f(x) \label{initial-min-problem}
$$

where $C$ is a *nice* convex set and $f$ a *nice* convex function. In these notes, the following notions of *niceness* are used (unless explicitly specified)

* $C\subseteq \R^n$ and is non-empty,
* $\mathrm{dom}\, f \supseteq C$, i.e.: the domain of $f$ covers $C$,
* $f$ is in the set $\Gamma_0(C)$ of convex functions on $C$ that are *proper* and *lower semi-continuous* (see [further](/pub/csml/cvxopt/ca_1.html)),
* $f$ achieves its minimum on the *interior* of $C^\circ$.

Roughly speaking, these conditions guarantee that there is a solution to the problem and that we can find one applying some simple iterative algorithm.
We will come back to these assumptions as we get to use them throughout the notes.

We will also consider the unconstrained form of the problem, i.e.: when $C=\mathbb R^n$ (and will then just write $\min_x f(x)$).
Constrained problems can always be interpreted as unconstrained problems: indeed, if we define the *indicator* of a convex set $C$ as

\eqa{
	i_C(x) &:=& \begin{cases} 0 & (x\in C) \\\\ +\infty & (x\notin C) \end{cases}
}

then the constrained problem \eqref{initial-min-problem} can be written equivalently as

$$
	\min_x \quad f(x)+i_C(x).
$$

This is not entirely pointless as will become apparent when deriving the projected gradient descent.

## Iterative methods

Before delving into the details it's important to understand how many algorithms for optimisation can be constructed.

A big part of convex optimisation aims at defining clever *iterative algorithms* which, ideally, enjoy the following properties when started from a sensible initial point $x_0$:

* the iterations converge "quickly" to a minimiser (i.e. a point $x^\sharp$ such that $f(x)\ge f(x^\sharp)$ for all $x\in C$)
* the iterations are "cheap" to compute.

Often these iterative algorithms can be derived from some kind of *fixed point equation* that is satisfied by a minimiser, i.e.: an equation of the form

\eqa{
	x^\sharp &=& P(x^\sharp)
}

where $P$ is an appropriate operator and $x^\sharp$ is a minimiser.
Provided we have such a fixed point equation, we can consider a *fixed point algorithm* with the simplest form being:

\eqa{
	x_{k+1} &=& P(x_k).
}

Under some conditions on the operator $P$ and possibly on $x_0$, such an  algorithm will provably converge to $x^\sharp$.
This may seem reasonably straightforward but there are quite a few questions to solve in order to make this work in practice:

* how to get a decent starting point? (quite a hard problem in general)
* how to pick an operator $P$ that is numerically stable and converges quickly?
* how to offer guarantees at any one point of how close we are to the true minimiser?
* etc.

In the rest of these notes, we will show how to obtain the fixed point equations and useful fixed point algorithms for a variety of scenarios and, by doing so, will recover well known algorithms such as the classical gradient descent and the mirror descent.

## General references

More precise pointers will be given on subsequent pages but most of the content in these notes relates in some way or another to the following references (in particular the first one):

1. **Rockafellar**: [Convex analysis](http://press.princeton.edu/titles/1815.html). Probably the best book in convex analysis. A reference of choice for technical details.
2. **Nesterov**: [Introductory Lectures on Convex Optimization](https://www.springer.com/us/book/9781402075537). Another must-read with all the technical details.
3. **Boyd** and **Vandenberghe**: [Convex Optimization](https://stanford.edu/~boyd/cvxbook/). More accessible and more oriented towards giving "tools" to the reader.
