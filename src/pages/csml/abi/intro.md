@def title = "Approximate Bayesian Inference - Introduction"

# Introduction to Approximate Bayesian Inference

In *Bayesian Machine Learning* (BML), one is broadly interested in recovering a posterior distribution over the parameters $x$ (with typically $x\in\mathcal X\subseteq \R^d$) of some parametric model of interest for which we have a likelihood $p(\mathcal D|x)$ (where $\mathcal D$ denotes the data) using Bayes' trick:

$$ p(x|\mathcal D) \spe{\propto} p(\mathcal D|x)p(\theta). \label{bayes-ml-1}$$

In equation \eqref{bayes-ml-1}, $p(x)$ denotes our *prior* belief on what the parameters should be and $p(x|\mathcal D)$ is the *posterior distribution* over $x$.
The posterior is then used to make more robust predictions with the model and, in particular, to account for **uncertainty** in the model parameters.

This approach is optimal under two key assumptions:
1. the prior is chosen appropriately,
1. the posterior is tractable (or at least we can sample from it).

The first assumption is usually overlooked by researchers in computational Bayesian statistics who usually assume the prior is given (and, in practice, it typically encodes a regularisation).
This is not without its weaknesses but it would require an entire set of notes to be discussed appropriately. \br
The second assumption is generally far from true especially with complex models and many approaches have been suggested such as MCMC methods; while these can do very well when $\theta$ is low-dimensional, they typically struggle when the dimensionality is high.

In these notes we define *Approximate Bayesian Inference* (ABI) in broad terms as the class of methods attempting to recover a distribution $q$ such that $q$ is a good *proxy* for the posterior distribution of interest $p$.
A number of such methods are commonly used when the dimensionality of the problem makes MCMC-like methods computationally too expensive.

## Variational problem

In what follows we simplify the context a little bit by considering methods which find good proxy $q$ to some target distribution $p$.
We write $\mathcal F\mathcal \subset \mathcal P(\mathcal X)$ the space of candidate proxy distributions where $\mathcal P(\mathcal X)$ designates all probability distributions on $\mathcal X$.

Let $D:\mathcal P(\mathcal X)\times \mathcal P(\mathcal X) \mapsto \R_+$ denote a discrepancy measure between two probability distribution functions.
Then, the generic variational problem considered in ABI is the minimisation of this $D$ between the candidate $q\in \mathcal F$ and the target $p$:

$$ q^\star \spe{\in} \arg\min_{q\in\mathcal F} D(q, p). \label{eq:basic-abi}$$

Techniques attempting to solve such problems rely upon exploiting at least one of the following three main characteristics:

1. the definition of the discrepancy measure $D$ (aka. divergence),
1. the definition of the restricted set of probability distributions $\mathcal F$,
1. the structure of the target distribution $p$.

Many discrepancy measures can be considered such as the total variation distance, Wasserstein distances or $f$-divergences.
However, most of these choices can lead to the corresponding problem \eqref{eq:basic-abi} being computationally (very) expensive to solve in general, especially if the space $\mathcal X$ is continuous.

In these notes we will focus on the Kullback-Leibler (KL) divergence which, as we'll see, can lead to optimisation problems for which efficient computational methods exist.
As a reminder, the KL divergence between two distributions $p$ and $q$ is defined as

$$ \KL(p, q) \speq \E_p[\log p(X) - \log q(X)]. $$

We will look at both $\KL(p, q)$ and $\KL(q, p)$ and, while in both case \eqref{eq:basic-abi} is intractable, in both cases proxy problems can be obtained and lead to two well known algorithms (along with related variants):

* the (Mean-Field) Variational Bayes algorithm ((MF)VB), which we will discuss [here](\abi{vb.html}),
* the Expectation Propagation algorithm (EP), which we will discuss [here](\abi{ep.html}).

## A warning note

At the risk of stating the obvious, it must stressed that ABI algorithms do in general *not lead to the correct posterior* but rather to a proxy which may be a very poor approximation to the target posterior.
Therefore, no matter what ABI algorithm you use, you should in general be very careful about how you interpret the recovered proxy $q$ and should ideally refrain from making strong statements about the uncertainty in the model parameters based upon $q$ unless you've tested it somehow.

While there are some cases where ABI algorithms can give good proxy (in particular if $p$ is known to be log-concave and thin-tailed), in many circumstances, and especially in the context of complex/high-dimensional models such as neural networks, ABI algorithms lead to proxy distributions which may

* typically recover reasonable location (e.g. the most likely $\theta$ according to the proxy $q$ is a good parameter for the model in terms of generalisation error)
* typically recover appalling uncertainty (often catastrophically underestimated).
ABI is a nice theoretical field with interesting mathematical tools but that should not prevent you from checking that the results obtained are sensible.
If you are not in a position to check the validity of the obtained proxy, you should probably revert to simply considering the maximum a posteriori (MAP) and avoid fooling yourself into thinking that you have a workable model of the uncertainty.
