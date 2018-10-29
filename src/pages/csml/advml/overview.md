@def title = "Adversarial ML - overview"

# Overview of adversarial machine learning

Very broadly, adversarial ML considers a situation where one is assuming the data to come from some distribution $P$ when, in fact, a portion of the data may have been corrupted by an attacker.

This was exemplified when some pre-trained ConvNets were presented with adversarially modified images and consequently badly misclassified the image even though it was visually similar to an image that was adequately classified; the image below, drawn from \citet{goodfellow15}, illustrates this clearly.

![](/assets/csml/advml/advnoise.jpg)

The field grew a lot recently with advances both on the attack and the defense side for a multitude of scenarios.
These notes summarise briefly some of the important approaches for adversarial learning, some of which will be revisited in more depths in subsequent notes.

## Defense

### Data corruption and robust statistics

Consider $n$ data points $X_i$ that we assume to be iid from a distribution $P$ except that a portion $\epsilon$ was adversarially modified ($\epsilon$-corrupted samples).
We could be interested in the following questions:

1. recover an estimate $\hat P$ such that for some appropriate divergence $d$ between probability measures, $d(\hat P, P)$ is small,
1. recover an estimate $\hat\mu$ of $\mu:=\E_P[\phi]$ for some $\phi$ such that for some appropriate norm, $\|\hat\mu - \mu\|$ is small.
1. quantify

There is a wide existing literature on robust statistics that this overlaps with but recently researchers have re-visited these questions in modern settings.

In particular, \citet{diakonikolas16} and related works discuss the problem in a high-dimensional setting where classical estimators are computationally intractable and suggest an efficient methods to recover a good estimate $\hat P$ in specific settings.

### Robust risk minimisation

Standard statistical learning considers the problem of picking a model $f \in \mathcal M$ to minimise the expected risk with respect to a loss function $\ell$ and distribution $P$:

$$ f \spe{\in}\arg\min_{f\in \mathcal M}\,\, \E_P[\ell_f] . $$

In the adversarial learning setting however, we can consider the _robust risk minimisation_ where we consider a _family of distributions_ $\mathcal P$ over which to minimise the expected risk:

$$ f \spe{\in} \arg\min_{f\in \mathcal M}\,\,\left[\sup_{Q\in\mathcal P} \E_Q[\ell_f]\right] $$

## Attack

## References

1. \biblabel{goodfellow15}{Goodfellow et al. (2015)} **Goodfellow**, **Shiens** and **Szegedy**, [Explaining and harnessing adversarial examples](https://ai.google/research/pubs/pub43405), ICLR 2015.
2. \biblabel{madry18}{Madry et al. (2018)} **Madry**, **Makelov**, **Schmidt**, **Tsipras** and **Vladu**, [Towards deep learning models resistant to adversarial attacks](https://arxiv.org/abs/1706.06083), ICLR 2018.
3. \biblabel{papernot16}{Papernot et al. (2016)} **Papernot**, **McDaniel**, **Jha**, **Fredrikson**, **Celik** and **Swami** [The limitations of deep learning in adversarial settings](https://arxiv.org/pdf/1511.07528.pdf), ESSP 2016.
4. \biblabel{diakonikolas16}{Diakonikolas et al. (2016)} **Diakonikolas**, **Kamath**, **Kane**, **Li**, **Moitra** and **Stewart**, [Robust estimators in high dimensions without the computational intractability](https://arxiv.org/pdf/1604.06443.pdf), FOCS 2016.
