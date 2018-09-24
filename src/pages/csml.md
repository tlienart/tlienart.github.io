@def title = "CS/ML"
@def date = Dates.today()

# Computer science & machine learning notes

The aim of the notes you'll find here is to suggest a direct, constructive path to results I find useful, beautiful, or simply interesting.
This stems mainly from my experience reading papers where the presentation sometimes trades clarity for generality.

The emphasis here is on building intuition rather than mathematical rigour though I try to indicate clearly where simplifications are made and what they may imply.
Often, these simplifications allow for straightforward demonstrations.
The references to more technical work can then be helpful to learn the results in full.

The target audience is advanced undergrads or grads in quantitative fields such as applied-maths, comp-sci, etc, assuming a decent background in basic maths (in particular linear algebra and real analysis).

If you find anything dubious in the notes, please send me an email, feedback is always much appreciated.

## Stats, ML and related

<!-- * *notes on variational inference* -->
<!-- * *notes on inference on graphical models* -->
<!-- * *notes on RKHS embeddings* -->

## Applied maths

* **notes on convex optimisation** (*assumes basic knowledge of convexity*) <!-- 🚫🚫🚫 12/9/18
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


<!-- * *notes on Krylov subspace methods* -->
<!-- * *notes on matrix theory* -->
