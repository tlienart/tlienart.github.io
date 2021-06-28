+++
title = "CV Ridge &ndash; pt. II"
mintoclevel = 2

descr = """
  Trying to generalise the LOO-CV trick for the Ridge regression.
  """
tags = ["machine learning", "linear algebra", "prospective"]
+++

{{redirect /pub/csml/glr/ridgecv-2.html}}

# CV Ridge (K-Folds)

{{page_tags}}

Where in [the first part](/pub/csml/glr/ridgecv.html), we showed that the LOOCV trick could be obtained by using the Sherman-Morrison formula for the inversion of a rank-1 perturbation of an invertible matrix, in the general case we want to sequentially drop more than one point.
In other words, we would like to consider the case where we consider not just a single rank-1 but a sum of rank-1 perturbations.

In these notes we investigate using Sherman-Morrison recursively and discuss in which circumstances this makes sense.

\toc

## Prelims

When considering a leave-some-out scheme (e.g. K-folds), we consider Ridge problems with data $X_{S}$ and $y_{S}$ where $S\subset \{1,\dots,n\}$ is a set of rows to drop.
As in the first part, we can write $X_{S} = Ω_{S}X$ and $y_S = Ω_{S}y$ where $Ω_{S}$ is the identity matrix with the rows in $S$ removed.
Much like in the first part, $\Omega_{S}^t\Omega_{S} = (I-D_{S})$ where $D_{S}$ is a zero matrix with 1 on the diagonal for indices in $S$.
Observe also that:

$$ X^t D_{S} X \speq \sum_{i ∈ S} x_ix_i^t  $$

and that $X^tD_S y = z - \sum_{i∈S} y_ix_i$ where $z=X^ty$.

The solution of the Ridge regression problem corresponding to the subset $S$ is therefore

$$ β_S \quad=\quad \left(H - \sum_{i\in S} x_ix_i^t\right)^{-1} \left(z - \sum_{i\in S} y_i x_i\right), \label{eq-1}$$

where $H = (X^tX + λI) = V(Σ^2+λI)V^t$ if $X=UΣV^t$.

As before, we care about the prediction error on the points that were removed: the vectors $e_S$ with entries

$$ (e_S)_i =  x_j^t β_S - y_j, \quad\text{where}\quad j = S_i. $$ <!--_-->

We now turn our attention to the efficient computation of the matrix inversion in \eqref{eq-1}.

### Recursive Sherman-Morrison (RSM)

Let us compute, step-by-step, the inversion of $(H - x_1 x_1^t - x_2x_2^t)$ and show how this can be generalised.
Let $H_1 = H - x_1 x_1^t$ and $H_2 = H_1 - x_2x_2^t$.
Then, Sherman-Morrison gives

\eqa{
  H_1^{-1} &=& \displaystyle H^{-1}  + {H^{-1}x_1 x_1^t H^{-1} \over 1 - x_1^t H^{-1} x_1}, \\
  H_2^{-1} &=&\displaystyle H_1^{-1} + {H_1^{-1}x_2 x_2^t H_1^{-1} \over 1 - x_2^t H_1^{-1} x_2}. }

Let us now write $b_1 = H^{-1}x_1$, $γ_1 = x_1^t b_1$, $b_2=H_1^{-1}x_2$ and $γ_2=x_2^tb_2$ then:

\eqa{
  H_1^{-1} &=& \displaystyle H^{-1}  + {b_1 b_1^t \over 1 - γ_1}, \\
  H_2^{-1} &=&\displaystyle H^{-1}  + {b_1 b_1^t \over 1 - γ_1} + {b_2 b_2^t \over 1 - γ_2}. }

It's straightforward to generalise this:

$$ \left( H - \sum_{i\in S} x_ix_i^t\right)^{-1} \quad=\quad H^{-1} + \sum_{i\in S} {b_ib_i^t\over 1-γ_i} \label{recursive sm}$$

which can be computed recursively interlacing the computations for $b_i$ and $γ_i$ and the computation of the next term in the sum.

### Complexity of the recursion

Let $M=|S|$ the number of rows dropped per selection/fold.
Then there are $M$ terms in the sum \eqref{recursive sm}.
Each $b_i$ is given by the application of a $p\times p$ matrix on a vector.
So, inherently, the complexity of this recursive inverse is $O(Mp^2)$ and it shouldn't be used if $M$ is of order comparable to $p$.

In K-folds cross validation, $M = O(n/K)$ where $K$ might typically be around $5$ or $10$ so that  $M$ may very well be of order $p$ or larger.
We will come back to this in the next section.

## Applying RSM in the tall case

One unfortunate element of RSM is that it is not possible (to the best of my knowledge) to easily get the inverse of the matrix for several $λ$ without recomputing the recursion each time.
This is because the computation of each $b_i$ after the initial one will involve non-diagonal matrices  that are shaped by $\lambda$.
Note that in the LOO case, this was not the case because we only had one diagonal matrix to update which is $O(p)$ (i.e. negligible).

The observation above means that for a single selection/fold, we have to pay $O(κMp^2)$ if $κ$ is the number of $λ$ we want to test. Assuming we do $K$ folds/selections, the overall cost is therefore $O(κKMp^2)$ to form all of the  $e_S$ vectors.

### K-folds CV

In K-folds CV, $M$ is $O(n/K)$ and the total cost with RSM is thus $O(κnp^2)$.

If, instead, we were to re-compute an SVD of $X_S^tX_S$ per fold and recycle the computations for the $λ$, the cost per fold is $O((n - M + κ)p^2)$ or $O(Knp^2)$ overall assuming that $κ$ is dominated by $n$.

Since, in general, we are much more likely to want to  test many $λ$ (large $κ$) with a few folds (with $K$ of order $5$-$10$), doing re-computations per fold makes more sense than applying RSM.

**Note**: it is still important to recycle computations otherwise we pay $O(κKnp^2)$ by doing a naive grid-computations for every fold and every $\lambda$; surprisingly this seems to be what is currently done in SkLearn as per [these lines of code](https://github.com/scikit-learn/scikit-learn/blob/e94b67a4d36bfa68f5a864a6401253846bac7138/sklearn/linear_model/_ridge.py#L1576-L1579).


## Fat case

Since the complexity of RSM is $O(Mp^2)$, it shouldn't be considered.
Computing $K$ problem with $n-M$ rows and recycling computations for the $λ$ is best.

## Conclusion

So disappointingly the generalisation of the LOO trick to the more general case is not particularly useful compared to simply re-computing things per-folds and recycling computations for the $λ$.
This could maybe have been expected, we have to deal with an expansion in $M$ terms where $M$ scales like $n$ in $K$ folds with low $K$ (the usual case).
