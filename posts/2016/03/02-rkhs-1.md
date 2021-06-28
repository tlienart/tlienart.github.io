+++
title = "RKHS &ndash; pt. I"
descr = """
    Introduction to Reproducing Kernel Hilbert Spaces (RKHS) and embedding
    of distributions.
    """
tags = ["statistics", "probability", "rkhs"]
+++

{{redirect /pub/csml/rkhs/intro-rkhs1.html}}

\newcommand{\C}{\mathcal C}

# Introduction to RKHS

{{page_tags}}

These notes were prepared with help from [Dino Sejdinovic](http://www.stats.ox.ac.uk/~sejdinov/) for a talk to a *kernel methods reading group* given in Oxford in July 2015.
The notes are fairly dry, I intend to come back and add more comments on the intuition in the future (in particular for the second part).

\toc

## Basic definitions

@@colbox-blue
A Hilbert space $\mathcal H$ of functions $f:\mathcal X\mapsto \R$ defined on a non-empty set $\mathcal X$ is said to be a *reproducing kernel Hilbert space* (RKHS) if *evaluation functionals* $\delta_x: f\mapsto f(x)$ are continuous for all $x\in\mathcal X$
@@

If we consider a RKHS then, by [Riesz's representation theorem](https://en.wikipedia.org/wiki/Riesz_representation_theorem), since $\delta_x$ is a continuous functional, it has a *representer* in $\mathcal H$ that we can denote $k_{x}$ such that

\eqa{  \scal{f, k_{x}}_{\mathcal H} &=& \delta_x(f) \speq f(x). }

We can then define a (positive-definite) bilinear form $k:\mathcal X\times\mathcal X \to \R$ as $k(x, x'):=\scal{k_{x}, k_{x'}}_{\mathcal H}$.
This is known as the **reproducing kernel** of $\mathcal H$; we will also write $k_{x} = k(\cdot, x)$.

There's then an important theorem that links the two (and that we won't prove, though a detailed proof can be found [here](https://members.cbio.mines-paristech.fr/~jvert/svn/kernelcourse/notes/aronszajn.pdf)) reproduced in a simplified form below:

@@colbox-blue
(**Moore-Aronszajn**) Every positive-definite bilinear form $k$ is a reproducing kernel for some Hilbert space $\mathcal H_k$.
@@

When the kernel is clear from the context, we will simply write $\mathcal H$ for the RKHS and $k$ for its reproducing kernel.

In essence we consider spaces of functions that can be characterised by a kernel function.
As will be seen, this kernel function encapsulates important properties of the type of functions that can be found in the space (e.g. how smooth they are etc.).

## Kernel embedding of a distribution

A classical way to try to represent points in a space $\mathcal X$ is to *embed* them in $\R^s$ using a $s$-dimensional *feature map* $\Phi:\mathcal X\to \R^s$ with
\eqa{   x\esp\mapsto\esp\Phi(x)\,\,=\,\, (\varphi_1(x), \varphi_2(x), \dots, \varphi_s(x)). }
Instead, we can now consider embedding points in a RKHS with the infinite dimensional feature map $x\mapsto k_{x}$.
In that case, we have an easily computable inner product between points with

\eqa{   \scal{k_{x}, k_{y}}_{\mathcal H} &=& \scal{k(\cdot, x), k(\cdot, y)}_{\mathcal H} \speq k(x, y).       }

Recall that an inner product is a *measure of alignment* so that this automatically gives us a measure of similarity between points through this kernel.

When the embedding is *injective* (i.e.: different objects are mapped to different points in the RKHS), the corresponding kernel is said to be *characteristic* (this is often the case for standard kernels).

### Mean embedding

An example of objects we can embed in an RKHS are probability distributions.
Each distribution is then considered as a point which we can embed through the *mean-embedding*.

@@colbox-blue
Let $P$ denote a distribution among a set $\mathcal P(\Omega)$ of distributions over some $\Omega$, the **mean embedding** is defined as follows:

\eqa{  P \spe{\mapsto} \mu(P; k) \spe{:=} \E_{X\sim P}[k(\cdot, X)] \speq \E_{X\sim P}[k_{_X}],}

where $\E_{X\sim P}$ denotes the expectation with respect to the random variable $X$ distributed as $P$. Naturally, $\mu(P; k)\in\mathcal H$. When the kernel and distribution are clear from the context, we will simply write $\mu(P; k)=\E_X[k_X]=:\mu_{_X}$ where, implicitly $X\sim P$.
@@

Observe that we now have this continuous embedding instead of a finite-dimensional embedding that we could have considered such as $P\mapsto (\E[\varphi_1(X)], \dots, \E[\varphi_s(X)])$.
Also, as before, we inherit a notion of *similarity* between points (here probability distributions) by considering the inner product on the RKHS:
\eqa{
    \scal{\mu(P; k), \mu(Q; k)}_{\mathcal H} \speq \E_{X Y}[k(X, Y)],
}
and this can easily be estimated if we have samples from both $P$ and $Q$.

Note finally that $\mu_{_X}$ represents *expectations with respect to $P$* i.e.: for any $f\in\mathcal H$,
\eqa{
    \scal{f, \mu_{_X}}_{\mathcal H} &=& \E_X[{\scal{f, k_{_X}}_{\mathcal H}}] \speq \E_X[f(X)] .
}

### Joint embedding

The generalisation to joint distributions is straightforward using tensor product feature spaces.

@@colbox-blue
Let $X, Y$ be jointly distributed according to some distribution $P$, the **joint embedding** of $P$ is defined as
\eqa{
    P \spe{\mapsto} \mathcal C_{XY}(P) \spe{:=} \E_{XY}[k_{_X}\otimes k_{_Y}],
}
assuming we use the same kernel for both variables.
@@

The tensor product satisfies $\scal{k_{_x} \otimes k_{_y}, k_{x'} \otimes k_{y'}}_{\mathcal H\otimes \mathcal H} = k(x, x')k(y, y')$.

In the same way that $\mu_{_X}$ represents the expectation operator, the joint-embedding $\mathcal C_{XY}$ can be viewed as the *uncentered cross-covariance operator*: for any two functions $f, g \in \mathcal H$, their uncentered covariance is given by

\eqa{\E_{XY}[f(X)g(Y)] &=& \scal{f\otimes g, \mathcal C_{XY}}_{\mathcal H\otimes \mathcal H} \speq \scal{f, \mathcal C_{XY} g}_{\mathcal H}. \label{covariance op 1}}

Following the same reasoning, we can define the *auto-covariance operators* $\mathcal C_{XX}$ and $\mathcal C_{YY}$.
Note also that, where $\mu_{_X}$ represents expectations with respect to $P$ (the distribution of $X$), these operators represent cross-covariance/auto-covariance with respect to $P$.

**Remark**: we have assumed that both random variables share the same kernel but this need not be the case: we can consider a second kernel $k'$ with a RKHS $\mathcal H'$; the cross-covariance operator then belongs to the product space $\mathcal H\otimes \mathcal H'$ (which is also a RKHS).

### MMD and HSIC

We have now seen two ways of embedding a distribution into a RKHS, now let's see why that can be useful.
When considering a characteristic kernel (such as, for example, the Gaussian RBF with $k(x, x')=\exp(-\sigma\|x-x'\|^2_2)$), the RKHS embedding is *injective*.
In that case, we can use the distance in the RKHS (induced by the inner-product) as a proxy for similarity in the distribution space.
This can be used in the two-sample test (to test whether two random variables are distributed according to the same distribution) or when testing for independence between random variables.

In the *kernel two sample test* \citep{gretton12a}, the test statistic is the squared distance between the embeddings of the two distributions:

@@colbox-blue
The kernel **Maximum Mean Discrepancy** (**MMD**) measure is defined for two distributions $P$ and $Q$ by
\eqa{\mathrm{MMD}(P, Q) &:=& \|\mu_{_X} - \mu_{_Y}\|_{\mathcal H}^2, } <!--_-->
where $X\sim P$ and $Y\sim Q$. @@

It is then possible to study the asymptotic properties of both the MMD and the MMD² and build hypothesis tests at a given level, independently of the distributions considered (see \cite{gretton12a} corollary 9 and 11).

When testing for *independence*, the test statistic can be the squared distance between the embeddings of the joint distribution and the product of its marginals which leads to the *kernel independence test* \citep{gretton07}:

@@colbox-blue
The **Hilbert-Schmidt Independence Criterion** (**HSIC**) is defined for two distributions $P$ and $Q$ by
\eqa{\mathrm{HSIC}(P, Q) &:=& \|\mathcal C_{XY} - \mu_{_X} \otimes \mu_{_Y}\|_{\mathcal H}^2, }<!--_-->
where $X\sim P$ and $Y\sim Q$.
@@

Again, it is then possible to study the asymptotic properties of the HSIC and build a hypothesis test at a given level, independently of the distributions considered (cf. \citep{gretton07}).

### Finite sample embeddings

All of the embeddings defined above can readily be estimated using samples drawn from the distributions of interest.
Let $\{x_1, \dots, x_n\}$ be an iid. draw from $P$, the *empirical kernel mean embedding* is defined as

$$  \widehat{\mu}_{_X} \spe{:=} n^{-1}\sum_{i=1}^n k_{x_i}. $$

As for standard Monte Carlo estimators, the rate of convergence is $\mathcal O(1/\sqrt{n})$ (an hence does not depend upon the dimensionality of the underlying space).
Similarly, for an iid draw of pairs $\{(x_1,y_1), \dots, (x_n, y_n)\}$, the *empirical covariance operator* is defined as

\eqal{\widehat{\mathcal C}_{XY}  \esp&=\esp n^{-1}\sum_{i=1}^n k_{x_i} \otimes k_{y_i} \\
&=\esp n^{-1}\Upsilon\Phi^t \label{empirical cxy}}
where $\Upsilon := (k_{x_1}, \dots, k_{x_n})$ and $\Phi:=(k_{y_1}, \dots, k_{y_n})$ are the *feature matrices*.

To conclude, it is straightforward to obtain empirical estimators for the MMD and HSIC criterion considering kernel elements $k(x_i, x_j)$, $k(y_i, y_j)$ and $k(x_i, y_j)$.
In the case of the MMD for instance, one has:

$$  \widehat{\mathrm{MMD}}(P, Q) \speq {1\over n^{2}}\sum_{i,j=1}^n \left(k(x_{i},x_{j})+k(y_{i},y_{j})-2k(x_{i},y_{j})\right) $$

## Kernel embeddings of conditional distributions

### Pointwise definition

In line with the definitions presented earlier, the kernel embedding of a conditional distribution $P(Y|X)$ is defined as

\eqa{  \mu_{_{Y|x}} &=& \mathbb E_{Y|x}[k_{_Y}], }

and the conditional expectation of a function $g\in \mathcal H$ can be expressed as

\eqa{  \E_{Y|x}[g(Y)] &=& \scal{g, \mu_{_{Y|x}}}_{\mathcal H}. }

Note that we now have a family of points in the RKHS indexed by $x$, the value upon which we condition.

### Conditional operator

We can also define an operator $\mathcal C_{Y|X}$ such that

\eqa{\mu_{_{Y|x}} &=& \mathcal C_{Y|X} k_x.}

To do so, we must first introduce a result for which we will provide a partial proof (the full proof can be found in \cite{fukumizu04}).

@@colbox-blue
The following identity holds (under mild technical conditions):

\eqa{  \mathcal C_{XX} \E_{Y|X}[g(Y)] &=& \mathcal C_{XY}g. \label{identity cxx cxy}  }
@@

To prove this, note that for $f \in \mathcal H$, using the definition of the joint embedding, we have

\eqal{ \scal{f, \mathcal C_{XX} \E_{Y|X}[g(Y)]}_{\mathcal H} \esp &=\esp \E_X[f(X)\E_{Y|X}[g(Y)]] \\
&=\esp \E_X[\E_{Y|X}[f(X)g(Y)]] \speq \E_{XY}[f(X)g(Y)],   }
where at the last equality, we used the [tower property of expectations](https://en.wikipedia.org/wiki/Law_of_total_expectation).
Comparing with \eqref{covariance op 1} we get \eqref{identity cxx cxy}.

With this, we can show another nice identity.
Using the definition of $\mu_{Y|x}$, we have
\eqa{
    \scal{g, \mu_{Y|x}}_{\mathcal H} &=& \mathbb E_{Y|x}[g(Y)] \speq \scal{\E_{Y|X}[g(Y)], k_x}_{\mathcal H}.
}
But, using \eqref{identity cxx cxy}, we have
\eqa{
    \scal{\E_{Y|X}[g(Y)], k_x}_{\mathcal H} &=& \scal{\mathcal C_{XX}^{-1}\mathcal C_{XY} g, k_x}_{\mathcal H} \speq \scal{g, \mathcal C_{YX}C_{XX}^{-1} k_x}_{\mathcal H}
}
where at the last equality we took the adjoint of $\mathcal C_{XX}^{-1}\mathcal C_{XY}$ which allows us to introduce the definition that follows.

@@colbox-blue
The **conditional embedding operator** is defined as
$$ \C_{Y|X} \spe{:=} \C_{YX}\C_{XX}^{-1}. $$
@@

In practice, $\C_{XX}$ is a *compact operator* which means that its eigenvalues go to zero and hence its inverse is not a bounded operator.
So the definition of $\C_{Y|X}$ given above is a slight abuse of notation.
The inversion of $\C_{XX}$ can be replaced by the *regularised inverse* $(\C_{XX}+\lambda I)^{-1}$ where $\lambda$ is a positive factor that can be determined by cross-validation.

### Finite sample kernel estimator

If we consider an iid draw $\{(x_i, y_i)\}_{i=1}^m$ from a joint distribution $P$, we know that the empirical estimators for $\C_{YX}$ and $\C_{XX}$ can be written as

$$
  \widehat{\C_{YX}} \speq {1\over n}\Phi\Upsilon^t\esp\text{and}\esp \widehat{\C_{XX}} \speq = {1\over n}\Upsilon\Upsilon^t,
$$

where $\Phi$ and $\Upsilon$ are defined as before (see equation \eqref{empirical cxy}).
Using a trick from linear algebra for the regularised inverse (coming from an application of Woodbury's formula), we have:

$$ \widehat{\C_{Y|X}} \speq n^{-1} \Phi \left[\Upsilon^t\left(\lambda I + n^{-1}\Upsilon\Upsilon^t\right)\right] \speq n^{-1}\Phi\left[n(\lambda I + \Upsilon^t\Upsilon)\Upsilon^t\right],$$

which gives an estimator for the conditional embedding operator.

@@colbox-blue
A finite sample estimator for the conditional embedding operator is
$$ \widehat{\C_{Y|X}} \speq \Phi[K+\lambda I]^{-1}\Upsilon^t $$
where $K:=\Upsilon^t\Upsilon$ is the Gram matrix.
@@

The regularisation parameter $\lambda$ helps to control for overfitting.
The resulting kernel embedding is then

$$ \widehat\mu_{Y|x} \speq \Phi\beta(x)   $$

where $\beta(x):= (K+\lambda I)^{-1}K_{:x}$ and $K_{:x}:=[k(x, x_i)]_{i=1}^m$ <!--_-->.
It is thus a weighted sum of samples of $Y$ in the feature space with weights depending on the conditioning variable $x$.

## References

1. \biblabel{fukumizu04}{Fukumizu et al. (2004)} **Fukumizu**, **Bach** and **Jordan**, [Dimensionality reduction for supervised learning with reproducing kernel Hilbert spaces](http://www.jmlr.org/papers/volume5/fukumizu04a/fukumizu04a.ps), 2004. A key paper in the RKHS literature.
1. \biblabel{gretton07}{Gretton et al. (2007)} **Gretton**, **Fukumizu**, **Hui Teo**, **Le Song**, **Schölkopf**, **Smola**, [A kernel statistical test of independence](http://www.kyb.mpg.de/fileadmin/user_upload/files/publications/attachments/NIPS2007-Gretton_%5b0%5d.pdf), 2007. Paper describing how to perform an independence test using the HSIC.
1. \biblabel{gretton12a}{Gretton et al. (2012a)} **Gretton**, **Borgwardt**, **Rasch**, **Schölkopf**, **Smola**, [A kernel two-sample test](http://www.jmlr.org/papers/volume13/gretton12a/gretton12a.pdf), 2012. Paper describing how to perform a two-sample test using the MMD.
1. \biblabel{gretton12b}{Gretton et al. (2012b)} **Gretton**, **Sriperumbudur**, **Sejdinovic**, **Strathmann**, **Balakrishnan**, **Pontil** and **Fukumizu**, [Optimal kernel choice for large-scale two-sample tests](http://www.gatsby.ucl.ac.uk/~gretton/papers/GreSriSejStrBalPonFuk12.pdf), 2012. Another paper describing how to perform a two-sample test using the MMD focusing on computational perspectives.
1. \biblabel{song13}{Song et al. (2013)} **Song**, **Fukumizu** and **Gretton**,  [Kernel embeddings of conditional distributions](https://www.cc.gatech.edu/~lsong/papers/SonFukGre13.pdf), 2013. The paper these notes are mainly based on.
