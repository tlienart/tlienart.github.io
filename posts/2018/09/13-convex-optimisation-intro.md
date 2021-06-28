+++
title = "Convex Optimisation &ndash; intro"
descr = """
	Introduction to the general convex minimisation problem and generic iterative methods.
	"""
tags = ["optimisation"]
+++

{{redirect /pub/csml/cvxopt/intro.html}}

<!--
TODO:

* add link to gradient descent (last paragraph before references)
* add link to mirror descent (same place)
-->

# Introduction to convex optimisation

{{page_tags}}

We'll consider the standard *constrained minimisation problem* in convex optimisation:

$$
	\min_{x\in C}\quad f(x) \label{initial-min-problem}
$$

where $C$ is a non-empty convex subset of $\R^n$ and $f$ a *nice* convex function.
The following notions of *nice* are used (unless explicitly specified):

* $\mathrm{dom}\, f \supseteq C$, i.e.: the domain of $f$ covers $C$,
* $f\in\Gamma_0(C)$, the set of convex functions that are *proper* and *lower semi-continuous* on $C$ (see [further](/posts/2018/09/23-convex-optimisation-1/), though you can ignore this for now),
* $f$ achieves its minimum on the interior of $C$ denoted $C^\circ$, i.e.: there is a $\xopt\in C$ such that $f(z)\ge f(\xopt)$ for all $z\in C$.

<!-- NOTE keep the restriction on C∘ as then you're sure that there's a subgradient and it simplifies stuff. Of course you'd have to discuss boundaries later on. -->

Roughly speaking, these conditions guarantee that there is a solution to the problem and that we can find one applying some simple iterative algorithm.
We will come back to these assumptions as we get to use them throughout the notes.

We will also consider the unconstrained form of the problem, i.e.: when $C=\mathbb R^n$ (and will then just write $\min_x f(x)$).
Constrained problems can always be interpreted as unconstrained problems: indeed, if we define the *indicator* of a convex set $C$ as

\eqa{
	i_C(x) &:=& \begin{cases} 0 & (x\in C) \\\\ +\infty & (x\notin C) \end{cases}
}

then the constrained problem \eqref{initial-min-problem} is equivalent to

$$
	\min_{x\in \R^n} \quad f(x)+i_C(x).
$$

This is not entirely pointless as will become apparent when deriving the projected gradient descent.

## Iterative methods <!-- ✅ 19/9/2018 -->

Before delving into the details it's useful to understand how algorithms for optimisation can often be constructed.

A big part of convex optimisation aims at defining clever *iterative algorithms* which, ideally, enjoy the following properties when started from a sensible initial point $x_0$:

* the iterations converge "quickly" to a minimiser,
* the iterations are "cheap" to compute.

Often these iterative algorithms can be derived from some kind of *fixed point equation* that is satisfied by a minimiser $\xopt$, i.e.: an equation of the form

\eqa{
	\xopt &=& P(\xopt)
}

where $P$ is an appropriate operator.
Provided we have such a fixed point equation, we can consider a *fixed point algorithm* with the simplest form being:

\eqa{
	x_{k+1} &=& P(x_k).
}

Under some conditions on the operator $P$ and possibly on $x_0$, such an  algorithm will provably converge to $\xopt$.
This may seem reasonably straightforward but there are quite a few difficult questions that need be addressed and will be investigated in the notes:

* how can we get a decent starting point? (quite a hard problem in general)
* how can we pick an operator $P$ that is numerically stable and converges quickly?
* how can we offer guarantees of how close we are to the true minimiser at a step $k$?

In the rest of these notes, we will show how to obtain the fixed point equations and useful fixed point algorithms for a variety of scenarios and, by doing so, will recover well known algorithms such as the classical gradient descent and the mirror descent.

## General references

More precise pointers will be given on subsequent pages but most of the content in these notes relates in some way or another to the following references (in particular the first one):

1. **Rockafellar**: [Convex analysis](http://press.princeton.edu/titles/1815.html), 1970. -- A "must-read" in convex analysis, a reference of choice for technical details.
1. **Nesterov**: [Introductory Lectures on Convex Optimization](https://www.springer.com/us/book/9781402075537), 1998. -- Another must-read with all the technical details and more focused on algorithms and convergence rates than Rockafellar's book.
1. **Ben-Tal**, **Nemirovski**, [Lectures on Modern Optimization](https://www2.isye.gatech.edu/~nemirovs/Lect_ModConvOpt.pdf), 2013. -- A recent perspective on optimisation methods.
1. **Boyd** and **Vandenberghe**: [Convex Optimization](https://stanford.edu/~boyd/cvxbook/), 2004. -- More accessible and more oriented towards giving "tools" to the reader than the previous references.
