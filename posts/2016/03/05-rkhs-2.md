+++
title = "RKHS &ndash; pt. II"
descr = """
    Probabilistic reasoning with kernel embeddings.
    """
tags = ["statistics", "probability", "rkhs"]
+++

{{redirect /pub/csml/rkhs/intro-rkhs2.html}}

# Probabilistic reasoning with kernel embeddings

{{page_tags}}

Following notations in \cite{song13}, we still consider two random variables $X$ and $Y$ with joint distribution $P(X, Y)$ and, additionally, we consider a prior distribution $\pi$ on $Y$.

\toc

## Kernel sum rule

The marginal distribution of $X$ can be computed by integrating out $Y$ from the joint density, i.e.:

$$ Q(X) \speq \int P(X|Y) \mathrm d{\pi}(Y) \speq \E_{Y\sim\pi}[P(X|Y)]. $$

Embedding it, we have

$$ \mu_{_X}^\pi \spe{:=} \E_{X\sim Q}[k_{_X}] \speq \E_{Y\sim \pi}[\E_{X|Y}[k_{_X}]], $$

which leads to the kernel sum rule.

@@colbox-blue
Let $X$ and $Y$ denote two random variables and $\pi$ a prior on $Y$, then the **Kernel sum rule** reads
$$ \mu_{_X}^\pi \speq \mathcal C_{X|Y}\mu^\pi_{_Y} $$
@@

This is straightforward to prove using the definition of the conditional embedding (see [part 1](/pub/csml/rkhs/intro-rkhs1.html)).

\eqal{ \mu_{_X}^\pi \speq \E_{X|Y}[k_{_Y}] \esp&=\esp \E_{Y\sim \pi}[\mathcal C_{X|Y}k_{_Y}]\\
    &=\esp \mathcal C_{X|Y}\E_{Y\sim\pi}[k_{_Y}] \speq \mathcal C_{X|Y}\mu_{_Y}
}

The kernel sum rule shows that the conditional embedding operator $\mathcal C_{X|Y}$ maps the embedding of $\pi(Y)$ to that of $Q(X)$.

In practice, an estimator $\hat\mu_{_Y}^\pi$ is given in the form $\sum_{i=1}^n \alpha_i k_{\tilde y_i} = \widetilde\Phi \alpha$ based on samples $\{\tilde y_i\}_{i=1}^n$.
Let's also assume that the conditional embedding operator has been estimated from a sample $\{(x_i,y_i)\}_{i=1}^m$ drawn from the joint distribution with $\widehat{\mathcal C_{X|Y}}=\Upsilon(G+\lambda I)^{-1}\Phi$ where $\Upsilon = (k_{x_i})_{i=1}^m$, $\Phi=(k_{y_i})_{i=1}^m$, $G_{ij} = k(y_i,y_j)$ and $\widetilde G_{ij} = k(y_i, \tilde y_j)$.

@@colbox-blue
The kernel sum rule in the finite sample case has the following form:
$$ \hat\mu_{_X}^\pi \speq \widehat{\mathcal C_{X|Y}}\hat\mu_{_Y}^\pi \speq \Upsilon(G+\lambda I)^{-1}\Phi \widetilde G\alpha. $$
@@


## Kernel chain rule

A joint distribution $Q$ can be factorised into a product between conditional and marginal with $Q(X, Y)=P(X|Y)\pi(Y)$.

@@colbox-blue
The **kernel chain rule** reads
$$ \mathcal C^\pi_{XY} \speq \mathcal C_{X|Y}\mathcal C^\pi_{YY}. $$
@@

This is straightforward to prove:

\eqal{
    \mathcal C^\pi_{XY} \esp&=\esp \E_{(X,Y)\sim Q}[k_{_X}\otimes k_{_Y}] \speq \E_{Y\sim\pi}[\E_{X|Y}[k_{_X}] \otimes k_{_Y}]\\
    &= \esp \mathcal C_{X|Y}\E_{Y\sim \pi}[k_Y \otimes k_Y] \speq \mathcal C_{X|Y}\mathcal C^\pi_{YY}.
}

@@colbox-blue
The kernel chain rule in the finite sample case has the following form:
$$ \widehat{\mathcal C}_{XY}^\pi \speq \widehat{\mathcal C}_{X|Y}\widehat{\mathcal C}^\pi_{YY} \speq \Upsilon(G+\lambda I)^{-1}\widetilde G\mathrm{diag}(\alpha)\widetilde\Phi^t,$$
using $\widehat{\mathcal C}^\pi_{YY} = \widetilde\Phi \mathrm{diag}(\alpha)\widetilde\Phi^t$ and $\widehat{\mathcal C}_{X|Y} = \Upsilon(G+\lambda I)^{-1}\Phi$.
@@

## Kernel Bayes rule

A posterior distribution can be expressed in terms of a prior and a likelihood as

$$ Q(Y|x) \speq {P(x|Y)\pi(Y)\over Q(x)}, $$

where $Q(x)$ is the relevant normalisation factor.
We seek to construct the conditional embedding operator $\mathcal C^\pi_{Y|X}$.

@@colbox-blue
The **kernel Bayes rule** reads

$$ \mu^\pi_{_Y|x} \speq \mathcal C^\pi_{Y|X}k_x \speq \mathcal C^\pi_{YX} (\mathcal C^\pi_{XX})^{-1}k_x, $$
with then $\mathcal C^\pi_{Y|X} = \mathcal C^\pi_{YX}(\mathcal C^\pi_{XX})^{-1}$.
@@

Using the sum rule, $\mathcal C^\pi_{XX}=\mathcal C_{(XX)|Y}\mu_{_Y}^\pi$ and, using the chain rule, $\mathcal C^\pi_{YX}=(\mathcal C_{X|Y}\mathcal C^\pi_{YY})^t$.
The finite sample case can also be obtained (and is a bit messy).

## Kernel Bayesian average and posterior decoding

Say we're interested in evaluating the expected value of a function $g\in \mathcal H$ with respect to the posterior $Q(Y|x)$ or to decode $y^{\star}$ most typical of the posterior.
Assume that the embedding $\widehat\mu^{\pi}_{_{Y|x}}$ is given as $\sum_{i=1}^n \beta_{i}(x)k_{\tilde y_{i}}$ and $g=\sum_{i=1}^m\alpha_{i}k_{y_{i}}$ then

@@colbox-blue
the **kernel Bayes average** reads

$$
    \left\langle g,\widehat{\mu_{Y|x}}^{\pi}\right\rangle_{\mathcal H} \speq \beta^{t} \widetilde G  \alpha \speq \sum_{ij} \alpha_{i}\beta_{j}(x)k(y_{i},\tilde y_{j}),
$$

 and the **kernel Bayes posterior decoding** reads

$$
y^{\star} \speq \arg\min_{y} \,\, -2\beta^{t}\widetilde G_{:y}+k(y,y).
$$

The second expression coming from the minimisation $\min_{y}\|\widehat{ \mu^{\pi}_{_{Y|x}}}-k_{y}\|_{\mathcal H}^{2}$.
@@
<!--_-->
In general, the optimisation problem is difficult to solve.
It corresponds to the so-called "pre-image" problem in kernel methods.

## References

1. \biblabel{song13}{Song et al. (2013)} **Song**, **Fukumizu** and **Gretton**,  [Kernel embeddings of conditional distributions](https://www.cc.gatech.edu/~lsong/papers/SonFukGre13.pdf), 2013. The paper these notes are mainly based on.

*See also the references given in the [first part](/pub/csml/rkhs/intro-rkhs1.html).*
