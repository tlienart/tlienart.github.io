@def title = "CS/ML"
@def date = Dates.today()

# Computer science & machine learning notes

The aim of the notes you'll find here is to suggest a direct, constructive path to results I find useful, beautiful, or simply interesting.
This stems mainly from my experience reading papers where the presentation sometimes trades clarity for generality.

The emphasis is on intuition rather than rigour though I try to indicate where simplifications are made and what they may imply.
Often, these simplifications allow for straightforward demonstrations.
The references to more technical work can then be helpful to learn the results in full.

**Target audience**: advanced undergrads or grads in quantitative fields such as applied-maths, stats, comp-sci, etc, assuming a decent background in basic maths (in particular linear algebra, real analysis and probability theory).
When the level of the notes is judged (arbitrarily) to be a bit more advanced, it is marked by a "⭒" symbol.

**Errors & Comments**: if you find anything dubious in the notes, please send me an email, feedback is always much appreciated.

**Browser note**: the notes use a recent version of [KaTeX](https://katex.org/) to render the maths which requires you to have Javascript on. The rendering has been tested on Firefox 61, Safari 12 and Chromium 71. If you use an older version or another browser it may be that some things don't render properly. If that's the case, kindly let me know by email, thanks!

<!-- TODO
Once a bit clearer, think of a way to explain what exactly is kept here and how to navigate it otherwise might pile up quite quickly
-->

## Stats, ML and related topics

<!--
* **notes on approximated bayesian inference** (*assumes knowledge of the bayesian framework, familiarity with the exponential family and convex optimisation*)
    * [introduction](/pub/csml/abi/intro.html): 🚫🚫🚫🚫 (ongoing) + discussion of whether it's a good idea + setup for experiments discussed here + references //
        - http://www.orchid.ac.uk/eprints/40/1/fox_vbtut.pdf
        -
    * [exponential family and convexity part 1](/pub/csml/abi/ef-cvx1.html): 🚫🚫🚫🚫 (ongoing)
    * [exponential family and convexity part 2](/pub/csml/abi/ef-cvx2.html): 🚫🚫🚫🚫 (ongoing)
    * [online bayesian learning and assumed density filtering](/pub/csml/abi/obl-adf.html): 🚫🚫🚫🚫 (ongoing)
    * [expectation propagation](/pub/csml/abi/ep.html): 🚫🚫🚫🚫 (ongoing)
    * (⭒) [EP and distributed bayesian inference part 1](/pub/csml/abi/ep-dbi1.html): 🚫🚫🚫🚫 (ongoing)
    * (⭒) [EP and distributed bayesian inference part 1](/pub/csml//abi/ep-dbi2.html): 🚫🚫🚫🚫 (ongoing)
    * (⭒) [EP and distributed bayesian inference part 2](/pub/csml//abi/ep-dbi2.html): 🚫🚫🚫🚫 (ongoing) natural parameter space update, links with SMS
    * (⭒) [EP and distributed bayesian inference part 3](/pub/csml//abi/ep-dbi3.html): 🚫🚫🚫🚫 (ongoing) mean parameter space
    * (⭒) [EP and distributed bayesian inference part 4](/pub/csml//abi/ep-dbi4.html): 🚫🚫🚫🚫 (ongoing) ep energy perspective
    * (⭒) [EP and distributed bayesian inference part 5](/pub/csml//abi/ep-dbi5.html): 🚫🚫🚫🚫 (ongoing) mirror descent for ep energy
-->

<!-- * **adversarial ML** (*research notes on the topic*) -->
    <!-- * [Overview](/pub/csml/advml/overview.html): brief discussion of some interesting recent advances. --> <!--👷-->
    <!-- * [Robust stats](/pub/aml/robust-stats.html): --> <!--👷-->

<!-- 🍺 * *notes on inference on graphical models* -->

* **kernel methods** (*assumes good knowledge of stats and real analysis*)
    * (⭒) [RKHS embeddings part 1](/pub/csml/rkhs/intro-rkhs1.html): notes from a 2015 "kernel methods reading group" introducing *reproducing kernel Hilbert space* embeddings of distributions and their use.
    * (⭒) [RKHS embeddings part 2](/pub/csml/rkhs/intro-rkhs2.html): rest of the notes where we discuss probabilistic reasoning with kernel embeddings. <!--👷-->

## Applied maths

* **convex optimisation** (*assumes familiarity with convexity*):  
<!--
NOTE TODO:
    - harmonise presentation, include a brief overview of each page at top, and summary linking to rest.
-->
    * [introduction](\cvx{intro.html}): introduction of the general minimisation problem and hint at generic iterative methods. <!-- ✅ 12/9/18 -->
    * [convex analysis part 1](\cvx{ca1.html}): the *subdifferential* and the *first-order optimality condition*. <!-- ✅ 12/9/18 -->
    * (⭒) [convex analysis part 2](\cvx{ca2.html}): the *convex conjugate* along with some useful properties. <!-- ✅ 12/9/18 -->
    * (⭒) [convex analysis part 3](\cvx{ca3.html}): *strict* and *strong* convexity, the *Bregman divergence* and link between *lipschitz continuity* and *strong convexity*. <!-- ✅ 23/9/2018-->
    * [projected gradient descent](\cvx{pgd.html}): _normal cone_, _Euclidean projection_ and _projected gradient descent_. <!-- ✅ 10/10/2018 -->
    * [mirror descent algorithm](\cvx{mda.html}): _generalised projected gradient descent_ and the _mirror descent algorithm_. <!-- 🚫 27/10/2018 TODO: review -->
    * [thoughts on first order methods](\cvx{fom.html}): _first order methods_, _minimising sequence_, _admissible direction_, _generalised projected gradient descent_ (again). <!-- 🚫 27/10/2018 TODO: review, add summary at bottom hinting at approximation of r_x with Bregman div for instance -->
    <!-- * [thoughts on first order methods](\cvx{fom.html}) -->

* **Matrix theory**:
    * [matrix inversion lemmas](\mth{matinvlem.html}): _woodbury formula_ and a couple of useful related results.

<!-- 🍺
* *notes on Krylov subspace methods*
    * conjugate gradient
-->
<!-- 🍺 * *notes on matrix theory* -->

<!-- 🍺  **unsorted**
* woodbury formula, link in rkhs part 1 -->
