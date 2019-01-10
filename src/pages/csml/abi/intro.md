@def title = "Approximate Bayesian Inference - Introduction"

# Introduction to Approximate Bayesian Inference

In *Bayesian Machine Learning* (BML), one is broadly interested in recovering a posterior distribution over the parameters $\theta$ of some model of interest for which we have a likelihood $p(\mathcal D|\theta)$ (where $\mathcal D$ denotes the data) using the usual Bayes' trick:

$$ p(\theta|\mathcal D) \spe{\propto} p(\mathcal D|\theta)p(\theta), $$

where $p(\theta)$ denotes our prior belief on what the parameters should be.
The posterior distribution $p(\theta|\mathcal D)$ can then in theory be used to make more robust predictions with the model and, in particular, to account for **uncertainty** in the model parameters.

This approach is optimal under two key assumptions:
1. your prior is chosen appropriately,
1. the posterior is tractable (at the very least we'd like to be able to sample from it).

The first point is usually overlooked by researchers in computational Bayesian statistics who usually assume the prior is given (and, in practice, it typically encodes a regularisation).
The second point is generally far from true especially with complex models and many approaches have been suggested such as the well known MCMC methods.

In these notes we define *Approximate Bayesian Inference* (ABI) in broad terms as the class of methods attempting to recover a distribution $q$ in a restricted family of distributions such that $q$ is a good *proxy* for some posterior distribution of interest $p$.

## Context

In what follows we will write $\mathcal F\mathcal \subset \mathcal P(\mathcal X)$ the restricted family of candidate proxy distributions where $\mathcal P$ designates all probability distributions on the domain $\mathcal X$.

This context leaves significant room to describe different methods based on the definition of what a "good proxy" means.
Let $D:\mathcal P(\mathcal X)\times \mathcal P(\mathcal X) \mapsto \R_+$ denote a discrepancy measure between two probability distribution functions.
Then, the generic variational problem considered in (our interpretation of) ABI is the minimisation of this $D$ between the candidate $q\in \mathcal F$ and the target $p$:

$$ q^\star \spe{\in} \arg\min_{q\in\mathcal F} D(q, p). \label{eq:basic-abi}$$

Techniques attempting to solve such problems rely upon exploiting at least one of the following three main characteristics:

1. the definition of the discrepancy measure $D$ (aka. divergence),
1. the definition of the restricted set of probability distributions $\mathcal F$,
1. the structure of the target distribution $p$.

Many discrepancy measures can be considered such as the total variation distance, Wasserstein distances or $f$-divergences.
However, most of these choices can lead to the corresponding problem \eqref{eq:basic-abi} being computationally (very) expensive to solve in general, especially if the space $\mathcal X$ is continuous.

In the notes we will focus on the Kullback-Leibler (KL) divergence which, as we'll see, can lead to optimisation problems for which efficient computational methods exist.
As a reminder, the KL divergence between two distributions $p$ and $q$ is defined as

$$ \KL(p, q) \speq \E_p[\log p(X) - \log q(X)]. $$

In the rest of the notes we will look at both $\KL(p, q)$ and $\KL(q, p)$.
While in both case \eqref{eq:basic-abi} is intractable, in both cases a proxy problem can be obtained and worked with.
This leads namely to two well known algorithms that we will discuss (along with related variants):

* the mean-field variational inference algorithm (MFVI),
* the expectation propagation algorithm (EP).

## A warning note

At the risk of stating the obvious, it is absolutely crucial to note that ABI algorithms do *not lead to the correct posterior* but rather a proxy which may be quite far off the target.
Therefore, it goes without saying that no matter what ABI algorithm you use, you should in general be very careful about how you use the recovered proxy $q$ and should ideally refrain from making strong statements about the uncertainty in the model parameters based upon $q$.

There are some cases where ABI does give a pretty good proxy (in particular if $p$ is known to be log-concave and thin-tailed) but unless you know for sure that you're in one of those cases, you should remain careful.

### Short rant

In many circumstances and especially in the context of complex / high-dimensional models such as neural networks, ABI algorithms lead to proxy distributions which recover reasonable location (i.e. the most likely $\theta$ according to the proxy $q$ is a good parameter for the model in terms of generalisation) but appalling uncertainty (often catastrophically underestimated).

<!-- NOTE: HERE HERE HERE, add that basically amounts to regularised MLE which is much much faster, of course no uncertainty estimate but between un-usable ones and none with a fast method... -->
