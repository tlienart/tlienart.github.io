@def title = "CS/ML"
@def date = Dates.today()

# Computer science & machine learning notes

The aim of the notes you'll find here is to suggest a direct, constructive path to results I find useful, beautiful, or simply interesting.
This stems mainly from my experience reading papers where the presentation sometimes trades clarity for generality.

The emphasis here is on building intuition rather than mathematical rigour though I try to indicate clearly where simplifications are made and what they may imply.
Often, these simplifications allow for straightforward demonstrations.
The references to more technical work can then be helpful to learn the results in full.

The target audience is advanced undergrads or grads in quantitative fields such as applied-maths, comp-sci, etc, assuming a decent background in basic maths (in particular linear algebra. real analysis and basic probability theory).
When the level of the notes is judged to be close to research, it is marked by a "⭒" symbol.

If you find anything dubious in the notes, please send me an email, feedback is always much appreciated.

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

* **Kernel methods**
    * (⭒) [RKHS embeddings part 1](/pub/csml/rkhs/intro-rkhs1.html): notes from a reading group kernel methods introducing *reproducing kernel Hilbert space* embeddings of distributions and their use.
    * (⭒) [RKHS embeddings part 2](/pub/csml/rkhs/intro-rkhs2.html): where we discuss probabilistic reasoning with kernel embeddings.


<!-- 🍺 * *notes on inference on graphical models* -->

<!-- 🍺  **unsorted** --> woodbury formula, link in rkhs part 1 -->


## Applied maths

* **notes on convex optimisation** (*assumes basic knowledge of convexity*):  <!-- 🚫🚫🚫 12/9/18
NOTE TODO:
    🍺 continue to port things from old website
        ✅ intro
        ✅ convex analysis (pt 1 and 2)
        🚫 projected gradient descent
        🚫 mirror descent
        🚫 general descent method
-->
    * [introduction](/pub/csml/cvxopt/intro.html): introduction of the general minimisation problem and hint at generic iterative methods. <!-- ✅ 12/9/18 -->
    * [convex analysis part 1](/pub/csml/cvxopt/ca1.html): the *subdifferential* and the *first-order optimality condition*. <!-- ✅ 12/9/18 -->
    * [convex analysis part 2](/pub/csml/cvxopt/ca2.html): the *convex conjugate* along with some useful properties. <!-- ✅ 12/9/18 -->
    * [convex analysis part 3](/pub/csml/cvxopt/ca3.html): *strict* and *strong* convexity, the *Bregman divergence* and link between *lipschitz continuity* and *strong convexity*. <!-- ✅ 23/9/2018-->
    * [projected gradient descent](/pub/csml/cvxopt/pgd.html): _normal cone_, _Euclidean projection_ and _projected gradient descent_.
    <!-- * [mirror descent](/) -->

<!-- 🍺
* *notes on Krylov subspace methods*
    * conjugate gradient
-->
<!-- 🍺 * *notes on matrix theory* -->
