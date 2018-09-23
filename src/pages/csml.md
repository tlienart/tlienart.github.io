@def title = "CS/ML"
@def date = Dates.today()

# Computer science & machine learning notes

The aim of the notes you'll find here is to suggest a direct, constructive path to results I find useful, beautiful, or simply interesting.
This stems mainly from my experience as a student reading papers where the presentation often aims at proving results in their most general form which can sometimes obfuscate what the result really is or how it can be applied.

The emphasis here is on building intuition rather than mathematical rigour though I try to indicate clearly where simplifications are made and what they may imply.
Often though, these simplifications allow for straightforward, constructive demonstrations that, in my view, can help the reader get a good idea of where result come from and how they may be applied.
The references to more technical work can then be helpful to learn the results and the proofs in full.

The target audience is advanced undergrads or grads in quantitative fields such as applied-maths, comp-sci, etc, assuming a decent background in foundational mathematics (in particular linear algebra and real analysis).

If you find anything dubious in the notes, please send me an email, feedback is always much appreciated.

## Stats, ML and related

<!-- * *notes on variational inference* -->
<!-- * *notes on inference on graphical models* -->
<!-- * *notes on RKHS embeddings* -->

## Applied maths

* **notes on convex optimisation** (*assumes knowledge of convexity and basic real analysis*) <!-- 🚫🚫🚫 12/9/18
NOTE TODO:
    🍺 add references to Nesterov's course (+link)
    🍺 add references in ca3 (see note)
-->
    * [introduction](/pub/csml/cvxopt/intro.html): introduction of the general minimisation problem and hint at generic iterative methods. <!-- ✅ 12/9/18 -->
    * [convex analysis part 1](/pub/csml/cvxopt/ca1.html): the *subdifferential* and the *first-order optimality condition*. <!-- ✅ 12/9/18 -->
    * [convex analysis part 2](/pub/csml/cvxopt/ca2.html): the *convex conjugate* along with some useful properties. <!-- ✅ 12/9/18 -->
    * [convex analysis part 3](/pub/csml/cvxopt/ca3.html): *strict* and *strong* convexity, the *Bregman divergence* and link between *lipschitz continuity* and *strong convexity*. <!-- 🚫 12/9/18 NOTE: ok but needs references for Lipschitz <> strong convex maybe as well as something nice on Bregman -->


<!-- * *notes on Krylov subspace methods* -->
<!-- * *notes on matrix theory* -->
