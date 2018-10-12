\newcommand{\eqa}[1]{\begin{eqnarray}#1\end{eqnarray}}
\newcommand{\eqal}[1]{\begin{align}#1\end{align}}

\newcommand{\esp}{\quad\!\!}
\newcommand{\spe}[1]{\esp#1\esp}
\newcommand{\speq}{\spe{=}}

\newcommand{\E}{\mathbb E}
\newcommand{\R}{\mathbb R}
\newcommand{\eR}{\overline{\mathbb R}}

\newcommand{\scal}[1]{\left\langle#1\right\rangle}


@def title = "RKHS Embeddings"

## Introduction

These notes were prepared with help from [Dino Sejdinovic](http://www.stats.ox.ac.uk/~sejdinov/) for a talk to a *kernel methods reading group* given in Oxford in July 2015, they're mostly based on a 2013 paper by Song, Fukumizu and Gretton: *Kernel embeddings of conditional distributions*

### Basic definitions

@@colbox-blue
A Hilbert space $\mathcal H$ of functions $f:\mathcal X\mapsto \R$ defined on a non-empty set $\mathcal X$ is said to be a *reproducing kernel Hilbert space* (RKHS) if *evaluation functionals* $\delta_x: f\mapsto f(x)$ are continuous for all $x\in\mathcal X$
@@

If we consider a RKHS then, by Riesz's representation theorem, since $\delta_x$ is a continuous functional, it has a *representer* in $\mathcal H$ that we can denote $k_x$ such that

\eqa{  \scal{f, k_x}_{\mathcal H} &=& \delta_x(f) \speq f(x). }

We can then define a (positive-definite) bilinear form $k:\mathcal X\times\mathcal X \to \R$ as $k(x, x'):=\scal{k_x, k_{x'}}_{\mathcal H}$.
This is known as the **reproducing kernel** of $\mathcal H$; we will also write $k_x = k(\cdot, x)$.

There's then an important theorem that links the two (and that we won't prove) reproduced in a simplified form below:

@@colbox-blue
(**Moore-Aronszajn**) Every positive-definite bilinear form $k$ is a reproducing kernel for some Hilbert space $\mathcal H_k$.
@@

When the kernel is clear from the context, we will simply write $\mathcal H$ for the RKHS and $k$ for its reproducing kernel.

## Kernel embedding of a distribution

### Mean embedding

A classical way to try to represent points in a given space $\mathcal X$ is to *embed* them in $\R^s$ using a $s$-dimensional *feature map* $\Phi:\mathcal X\to \R^s$ with
\eqa{   x\esp\mapsto\esp\Phi(x)\,\,=\,\, (\varphi_1(x), \varphi_2(x), \dots, \varphi_s(x)). }
Instead, we can now consider embedding points in a RKHS with the infinite dimensional feature map $x\mapsto k_x$.
In that case, we have an easily computable inner product between points with

\eqa{   \scal{k_x, k_y}_{\mathcal H} &=& \scal{k(\cdot, x), k(\cdot, y)}_{\mathcal H} \speq k(x, y).       }

Recall that an inner product is a *measure of alignment* so that this automatically gives us a measure of similarity between points through this kernel.

When the embedding is *injective* (i.e.: different objects are mapped to different points in the RKHS), the corresponding kernel is said to be **characteristic** (this is often the case for standard kernels).

An example of objects we can embed in an RKHS are distributions.
Each distribution is then considered as a point which we can embed through the *mean-embedding*.

@@colbox-blue
Let $P$ denote a distribution among a set of distributions, the **mean embedding** is defined as follows:

\eqa{  P \mapsto \mu_X(P, k) \esp:=\esp \E_{X\sim P}[k(\cdot, X)]\speq \E_X[k_X],}
and, naturally, $\mu_X(P, k)\in\mathcal H$.
@@

When the kernel and the distribution are clear from the context, we will simply write $\mu_X$.
As before, note that we inherit a notion of *similarity* between probability measures by looking at the inner product on the RKHS:
\eqa{
    \scal{\mu_X(P, k), \mu_Y(Q, k)}_{\mathcal H} \speq \E_{X, Y}[k(X, Y)],
}
and this can easily be estimated if we have samples from both $P$ and $Q$.

Note finally that $\mu_X$ represents *expectations with respect to $P$* i.e.: for any $f\in\mathcal H$,
\eqa{
    \scal{f, \mu_X}_{\mathcal H} &=& \E_X[{\scal{f, k_X}_{\mathcal H}}] \speq \E_X[f(X)] .
}

### Joint embedding

The generalisation to joint distributions is straightforward using tensor product feature spaces.

@@colbox-blue
Let $X, Y$ be jointly distributed according to some distribution $P$, the **joint embedding** of $P$ is defined as
\eqa{
    P \mapsto \mathcal C_{XY}(P) \spe{:=} \E_{XY}[k_X\otimes k_Y],
}
assuming that the two variables share the same kernel.
@@

### MMD and HSIC

### Finite sample embeddings

## Kernel embeddings of conditional distributions

### Pointwise definition

### Conditional operator

### Finite sample kernel estimator

## Probabilistic reasoning with kernel embeddings

### Kernel sum rule

### Kernel chain rule

### Kernel Bayes rule

### Kernel Bayesian average and posterior decoding

## References
