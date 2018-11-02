@def title = "Adversarial ML - overview"

# Overview of adversarial machine learning

Very broadly, adversarial ML considers a situation where one is assuming the data to come from some distribution $P$ when, in fact, a portion of the data may have been corrupted by an attacker.

This was exemplified when some pre-trained ConvNets were presented with adversarially modified images.
These images were misclassified even though they were visually very similar to  images that were adequately classified; the image below, drawn from \citet{goodfellow15}, illustrates this.

![](/assets/csml/advml/advnoise.jpg)

The field grew a lot recently with advances both on the attack and the defense side for a multitude of scenarios.
On the attack side, we are interested in building approaches to construct adversarial data points which deteriorate the performance of a given system.
On the defense side, we are interested in either filtering out adversarial examples or implementing methods that are robust to them.

These notes summarise briefly some of the important approaches for adversarial learning, some of which will be revisited in more depths in subsequent notes.

## Attack

In these notes we will generally consider attacks on classifiers.
Such an attack can either happen before training (corruption of the training data) with the goal of modifying the learned model or after the training (crafting adversarial example) in order for the learned model to produce a different output than it would have for an unaltered example.

A key element to take into account is what the attacker has access to with two extremes: in a _white box attack_, the attacker has full access to the model being trained and, in particular, knows the loss-function being optimised over;
in a _black box attack_, the attacker does not know anything about the model but usually has access to (input, output) pairs.

Of course there can be variations of these scenarios: an attacker could have partial knowledge of the model or could have limited access to the amount of (input, output) pairs it can analyse.

### White-box attacks

In \cite{goodfellow15}, the authors suggest generating adversarial examples from a "clean" pair $(x, y)$ by linearising the cost function $J$ around the current value of the model parameters $\theta$:

$$ x^{\mathrm{adv}} \speq x + \epsilon\, \mathrm{sign}(\nabla_x J(\theta; x, y)) $$

In \cite{papernot16}, the authors formulate the problem as

$$ \arg\min_{\delta_{x}}\,\,\|\delta_x\|, \quad \text{s.t.}\quad F(x^* ) = y^* $$

where $x$ is a normal sample, $\delta_x$ is a perturbation, $x^* := (x+\delta_x)$ is the adversarial example and $y^* $ a desired adversarial output.
In other words, find the minimum perturbation to a normal example $x$ so that it gets misclassified as a target class $y^* $.

@@colbox-red
ongoing
@@


## Defense

When trying to defend a machine learning system, there are effectively two (overlapping) approaches to doing so:

1. _robust risk minimisation_: where instead of doing empirical risk minimisation with respect to the empirical distribution function built on the data, we consider risk minimisation with respect to a _set of distributions_ around the empirical distribution to account for uncertainty.
1. _data "cleaning"_: assume that the data is corrupted and develop approaches that can either filter out seemingly corrupted samples, use weights for samples according to their likelihood of being corrupted, or summarise the data in a way that is robust to perturbations,

The first approach is somewhat geared to fighting corruption of the training data and building a model that is more robust in general whereas the second approach could be used to ward off both corruption of training data or of data submitted to a trained model.


### Data corruption and robust statistics

Consider $n$ data points $X_i$ that we assume to be iid from a distribution $P$ except that an unknown portion $\epsilon$ was adversarially modified ($\epsilon$-corrupted samples).
We could be interested in the following couple of questions:

* recover an estimate $\hat P$ from the data such that for some appropriate divergence $d$ between probability measures, $d(\hat P, P)$ is small,
* recover an estimate $\hat\mu$ of $\mu:=\E_P[\phi]$ for some $\phi$ such that for some appropriate norm, $\|\hat\mu - \mu\|$ is small.

Generic approaches to dealing with $\epsilon$-corruption are:

1. using robust statistics such as the median,
1. filtering the samples to remove the ones that are corrupted,
1. weighing the samples according to their likelihood of being corrupted.

All three approaches have been fairly widely studied in low-dimensional settings (e.g. \cite{huber09}) but the classical approaches tend to suffer in a high-dimensional setting as discussed in \citet{diakonikolas16} where the authors suggest efficient methods for the latter two approaches in a Gaussian setting that can scale up to high-dimension.

### Robust risk minimisation

Standard statistical learning considers the problem of picking a model $f \in \mathcal M$ to minimise the expected risk with respect to a loss function $\ell$ and distribution $P$:

$$ f \spe{\in}\arg\min_{f\in \mathcal M}\,\, \E_P[\ell_f] . $$

In the adversarial learning setting however, we can consider the _robust risk minimisation_ problem where we consider a _family of distributions_ $\mathcal P$ with $P\in \mathcal P$ over which to minimise the expected risk:

$$ f \spe{\in} \arg\min_{f\in \mathcal M}\,\,\left[\sup_{Q\in\mathcal P} \E_Q[\ell_f]\right] $$

Recently, authors have shown that, if $\mathcal P$ is a Wasserstein ball then

$$ f\spe{\in} \arg\min_{f\in\mathcal M}\,\, \E_P[\ell_f] + L(f) $$

where $L(f)$ is a regularisation term which, in some cases, can be upper-bounded by a function related to the Lipschitz constant of the model $f$ (see e.g. \cite{cranko18} and references therein).
This has allowed to gain insight as to why Lipchitz regularisation of some models such as neural networks had proved successful (which has been discussed in e.g. \cite{szegedy14, shaham16, cisse17}).

## References

1. \biblabel{goodfellow15}{Goodfellow et al. (2015)} **Goodfellow**, **Shiens** and **Szegedy**, [Explaining and harnessing adversarial examples](https://ai.google/research/pubs/pub43405), ICLR 2015.
1. \biblabel{madry18}{Madry et al. (2018)} **Madry**, **Makelov**, **Schmidt**, **Tsipras** and **Vladu**, [Towards deep learning models resistant to adversarial attacks](https://arxiv.org/abs/1706.06083), ICLR 2018.
1. \biblabel{papernot16}{Papernot et al. (2016)} **Papernot**, **McDaniel**, **Jha**, **Fredrikson**, **Celik** and **Swami** [The limitations of deep learning in adversarial settings](https://arxiv.org/pdf/1511.07528.pdf), ESSP 2016.
1. \biblabel{diakonikolas16}{Diakonikolas et al. (2016)} **Diakonikolas**, **Kamath**, **Kane**, **Li**, **Moitra** and **Stewart**, [Robust estimators in high dimensions without the computational intractability](https://arxiv.org/pdf/1604.06443.pdf), FOCS 2016.
1. \biblabel{huber09}{Huber and Ronchetti (2009)} **Huber**, **Ronchetti**, Robust Statistics, 2nd ed, Wiley 2009.
1. \biblabel{cranko18}{Cranko et al. (2018)} **Cranko**, **Kornblith**, **Shi** and **Nock**, [Lipschitz networks and distributional robustness](https://arxiv.org/abs/1809.01129), ArXiv 2018.
1. \biblabel{szegedy14}{Szegedy et al. (2014)} **Szegedy**, **Zaremba**, **Sutskever**, **Bruna**, **Erhan**, **Goodfellow** and **Fergus**, [Intriguing properties of neural networks](https://arxiv.org/pdf/1312.6199.pdf), ArXiv 2014.
1. \biblabel{shaham16}{Shaham et al. (2016)} **Shaham**, **Yamada** and **Negahban** [Understanding adversarial training: increasing local stability of neural nets through robust optimization](https://arxiv.org/pdf/1511.05432.pdf), ArXiv 2016.
1. \biblabel{cisse17}{Cisse et al. (2017)} **Cisse**, **Bojanowski**, **Grave**, **Dauphin** and **Usunier**, [Parseval Networks: improving robustness to adversarial examples](https://arxiv.org/abs/1704.08847), ArXiv 2017.
