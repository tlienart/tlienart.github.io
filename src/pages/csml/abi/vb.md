@def title = "Variational Bayes"

\newcommand{\fmf}{\mathcal F_{_{\text{MF}}}}

# Variational Bayes

In VB the starting point is the variational problem where the discrepancy measure that we attempt to minimise is $\KL(q, p)$ with $p$ the target distribution, $q$ the proxy and
\eqa{
     \KL(q, p) &=& \E_q[\log q(X) - \log p(X)].
}
The KL is a divergence and so verifies $\KL(q, p)\ge 0$ and $\KL(p,p)=0$ for all $p, q\in\mathcal P(\mathcal X)$ (which is easy to prove).
Of course if we try to minimise it without further constraining the space in which candidates $q$ belong, we find the trivial answer $q^\star = p$.

## Mean-Field approximation

A way forward is to consider the space of distributions that fully factorise (*mean-field* approximation):
$$
    \fmf \spe{:=} \left\{q \mid q(x)\propto \prod_{i=1}^d q_i(x_i)\right\}.
$$
Note that we could relax this a bit by considering the space of distributions that only factorise according to a specific graphical model but that may generally not lead to as nice simplifications as with "naive" MF and typically requires extra assumptions (but it's doable, see e.g. \cite{ghahramani00} or search *generalised mean field*).

Under $q\in\fmf$, the KL decomposes as
$$
    \KL(q, p) \speq \E_q\left[\sum_i \log q_i(X_i) - \log p(X)\right] + \kappa\label{KL-2}
$$
where $\kappa$ corresponds to the log of the normalisation constant of $q$ and can be ignored in the minimisation.

### Coordinate descent

Let us denote $q_{\neg i}$ the distribution proportional to $q/q_i$ so that we can write $\E_q[\cdot]=\E_{q_i}[\E_{q_{\neg i}}[\cdot]]$.
The expectation in \eqref{KL-2} can then be expressed as
$$
    \E_{q_i}\left[ \log q_i(X_i) - \E_{q_{\neg i}}[\log p(X)]  \right] + \E_{q_{\neg i}}\left[\sum_{j\neq i} \log q_j(X_j)\right].\label{KL-3}
$$
This is amenable to a coordinate descent scheme (see e.g. \cite{wright15}) where we cyclically optimise one of the $q_i$ while keeping all the others fixed.
Keeping all $q_j$ fixed with $j\neq i$, the second term in \eqref{KL-3} can be ignored and we're left with
$$
    \min_{q_i \in \mathcal P(\mathcal X_i)} \,\, \E_{q_i}[\log q_i(X_i) - \E_{q_{\neg i}}[\log p(X)]].\label{KL-4}
$$
The second expectation can be written as $\log g_u(X_i)$ for some positive function $g_u$.
Let's further assume that $g_u$ is integrable so that there exists a constant $Z$ with $g:=g_u/Z$ a probability distribution function over $\mathcal X_i$.
Then, since $Z$ does not depend on $q_i$, we can ignore it and the problem \eqref{KL-4} effectively amounts to
$$
    \min_{q_i \in\mathcal P(\mathcal X_i)} \,\, \KL(q_i, g),
$$
for which a solution is simply $q_i^\star=g$ or
$$
    q_i^\star \spe{\propto} \exp(\E_{q_{\neg i}}[\log p(X)]).
$$

Putting the bits together, MFVB at its core corresponds to the following iteration:
\begin{align}
    q_i^{t+1} \esp&\propto\esp \exp(\E_{q_{\neg i}}[\log p(X)])\\
    q \esp&\propto\esp q(q_i^{t+1}/ q_i^t)\\
    q_{\neg (i+1)} \esp&\propto\esp q/q_(i+1)^t
\end{align}
where the second and third line indicate how $q$ and $q_{\neg j}$ are updated.
There is thus an outer loop over the number of descent steps $t=1,2,\dots$ and an inner loop over each of the dimension $i=1,\dots,d$.

### Computing the update

### Convergence and quality

A nice thing about MFVB is that the scheme provably **converges** in general (thanks to the convergence properties of coordinate descent).
This is generally a very appreciated property of any schemes though your next question should be *what does it converge to and how good is it?*.
To which the answer is, it converges to $q^\star \in \fmf$ and it can be... quite bad in general.

To see how bad, let's consider a simple 2D Gaussian $p$ with zero mean and a dense covariance matrix.
MFVB will give you something like $q(x_1)q(x_2) \approx p(x_1, x_2)$.
So without even doing any of the calculations, you can already see that cross terms in $x_1x_2$ will be completely ignored.
If the off-diagonal terms of the covariance matrix are large, this can be very bad.

To summarise, MFVB will give a very poor proxy for any target distribution which has strong dependence structure between (some of) its variables.
As a result it may severely underestimate the uncertainty of model variables.

<!-- That being said, variable transformations can be applied to help with this

NOTE: stop here, proof read, maybe look up

- https://papers.nips.cc/paper/5755-linear-response-methods-for-accurate-covariance-estimates-from-mean-field-variational-bayes.pdf
- kukulbir with ADVI

add citations and close this

maybe say that model with sparse dependence structure do arise (e.g. LDA / topic stuff maybe)

Also need to discuss the update, basically say that in quite a few applications the update is in fact possible to compute so that's not too much of an issue. Maybe also check SVI to make a mention of that?
-->


## References

1. \biblabel{elghaoui12}{Fox and Roberts (2011)} **Fox** and **Roberts**, [A tutorial on variational Bayesian inference](http://www.orchid.ac.uk/eprints/40/1/fox_vbtut.pdf), 2011. -- Introductory notes covering VB and MFVB.
1. \biblabel{ghahramani00}{Ghahramani and Beal (2000)} **Ghahramani** and **Beal**, [Propagation algorithms for variational Bayesian learning](http://papers.nips.cc/paper/1907-propagation-algorithms-for-variational-bayesian-learning.pdf), 2000. -- NIPS paper discussing VB with different restrictions for the space of proxy distributions $\mathcal F$.
1. \biblabel{wright15}{Wright (2015)} **Wright**, [Coordinate descent algorithms](https://arxiv.org/pdf/1502.04759.pdf), 2015. -- More than you wanted to know about coordinate descent algorithms with proofs of convergence.
