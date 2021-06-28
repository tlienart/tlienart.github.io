+++
title = "CV Ridge &ndash; pt. I"
mintoclevel = 2

descr = """
    Recycling computations in Ridge regression with <nobr>LOO-CV</nobr>.
    """
tags = ["linear algebra", "machine learning"]
+++

{{redirect /pub/csml/glr/ridgecv.html}}

# CV Ridge (LOO)

{{page_tags}}

\toc

## Brief recap

The Ridge regression is a simple penalised regression model corresponding to a L2 loss with L2 penalty on the coefficients:

$$ β_{\text{ridge}} \speq \arg\min \|X\beta - y\|_2^2 + \lambda \|\beta\|_2^2, $$ <!--_-->

where $X$ is $n\times p$ and $\lambda > 0$ is the penalty (hyper)parameter.
We'll drop the subscript "ridge" as it's now obvious from the context.

The minimum verifies

$$ (X^tX + λ I) β \quad = \quad X^ty. \label{ridge-tall}$$

## Complexity of solving Ridge

### Tall case ($n>p$)

The computational cost of solving \eqref{ridge-tall} directly is $O(np^2 + p^3)$:
- building $X^tX$ is $O(np^2)$,
- solving the resulting $p\times p$ system is $O(p^3)$.

In the case where $n > p$ (_tall_ case), this is asymptotically dominated by the first term: $O(np^2)$.

### Fat case ($p>n$)

In the case where $p > n$ (_fat_ case), it is more efficient to solve a derived system obtained by pre-multiplying \eqref{ridge-tall} by $X$:

$$ (XX^t + λ I)Xβ \quad = \quad XX^t y  \label{ridge-fat}$$

indeed, in that case $XX^t$ is $n\times n$ which is then smaller than $p \times p$.
It is useful to show a way to solve this explicitly: consider the SVD $X = UΣ V^t$, then $XX^t = UΣ^2 U^t$ and the equation \eqref{ridge-fat} becomes

$$ U(Σ^2 + λ I) Σ V^t β \quad=\quad U Σ^2U^t y$$

taking advantage from the fact that $U$ is orthogonal so that $UU^t = I$ (same with $V$).
This can be further massaged into

\eqa{ β &=&  V Σ (Σ^2 + \lambda I)^{-1}U^t y \label{ridge-fat-sol}\\
    &=& X^t U(Σ^2 + \lambda I)^{-1}U^t y,   }

using that $X=UΣ V^t$ so that $V = X^t U Σ^{-1}$.
Overall, the complexity is asymptotically dominated by the construction of $XX^t$ which is $O(pn^2)$ followed by the complexity of computing its SVD which is $O(n^3)$.

### Conclusion

* **tall case**: $n > p$, $O(np^2)$, dominated by the construction of  $X^tX$,
* **fat case**: $n < p$, $O(pn^2)$, dominated by the construction of $XX^t$.

## Recycling computations when changing $λ$

When tuning the hyperparameter $λ$, we will potentially want to compute $β_λ$ for a number of different $λ$; in Ridge regression we can ensure that this is done efficiently so that trying out different $λ$ is cheap after having computed the first solution.

We will again consider separately the tall and fat case, and will assume that it is reasonable to form either $X^tX$ or $XX^t$, for each case we will consider its SVD.

### Tall case

Let $X = UΣV^t$ and consequently $X^tX = V\Sigma^2V^t$ then \eqref{ridge-tall} can be written

$$ V(Σ^2 + λ I)V^t β \quad =\quad X^ty $$

and consequently $\beta = V(Σ^2 + λ I)^{-1}X^ty$.

Once the SVD has been formed, we are left, for any $λ$, with computing $VD_λz$ where $z = X^ty$ can be computed once in $O(np)$, $D_λ = (Σ^2 + λ I)^{-1}$ is a diagonal matrix which is computed and applied in $O(p)$ and the application of $V$ is $O(p^2)$.

Overall:

@@ctable
Operation | Cost
:--- | :---
initial computation of $X^tX$ | $O(np^2)$
initial SVD of $X^tX$ | $O(p^3)$
computation of $VD_λz$ | $O(p^2)$ per $λ$
@@

in other words, computing the solution for $O(n)$ different $\lambda$ is only twice as expensive asymptotically as computing the solution for a single one.

### Fat case

In the fat case, we already have the equation \eqref{ridge-fat-sol}: $β = X^t U(Σ^2+λI)^{-1}U^ty$, we get an analogous argument:

@@ctable
Operation | Dominating Cost
:--- | :---
initial computation of $XX^t$ | $O(pn^2)$
initial SVD of $XX^t$ | $O(n^3)$
initial computation of $w = U^ty$ | $O(pn)$
computation of $X^t U D_λ w$ | $O(np)$ per $λ$
@@

in other words, computing the solution for $O(n)$ different $\lambda$ is only twice as expensive asymptotically as computing the solution for a single one.

**Notes**:
* Observe that for *both* the tall and fat case, paying around _twice_ the cost of the initial computation, allows to compute the solutions for $O(n)$ different $λ$.
* thus far we have not considered the computation of the intercept but it's not hard to do and does not change the complexity analysis.

### Simple code

We can easily check all this with code in Julia; for instance, let's consider the fat case:

```!
using LinearAlgebra

basic_ridge_solve(X, y, λ=1) = (X'X + λ*I) \ X'y

X_fat = randn(50, 500)
y_fat = randn(50)

λ = 1

# slow solve requiring the solution of a 500x500 system
β_fat = basic_ridge_solve(X_fat, y_fat, λ);
```

Now let's check that we can recover it the cheaper way (via the SVD of $XX^t$)

```!
# SVD of a 50x50 system
F = svd(Symmetric(X_fat * X_fat'))
U, S = F.U, F.S
w_fat = U'y_fat ./ (S .+ λ)
β_fat ≈ X_fat' * (U * w_fat)
```

Now let's change $λ$:

```!
λ′ = 3

# naive route
β_fat′ = basic_ridge_solve(X_fat, y_fat, λ′)

# efficient route
w_fat′ = U'y_fat ./ (S .+ λ′)
β_fat′ ≈ X_fat' * (U * w_fat′)
```

## LOOCV trick

In Leave-One-Out CV, for a given $λ$ we want to train the model for each of $n-1$ cases where we consider only $n-1$ data points and want to report the error on the last point.

Let $X_{(i)}$ (resp $y_{(i)}$) be the matrix (resp. vector) with the $i$th row removed, and let $β_{(i)}$ be the Ridge coefficients in that case.
We are interested in the predicted error on the dropped point:

$$ e_i \quad=\quad x_i^tβ_{(i)} - y_i$$

We know that for a fixed $i$, we can compute that error efficiently for many $\lambda$ but it does require one initial SVD.
That's a bit annoying because we have to do that for every $i$, meaning a lot of SVDs to compute; this seems silly, surely we can re-use some computations!

It's well known that we can indeed speed things up.
See for instance \cite{rifkin07} whose formula is used in Sklearn's [RidgeCV](https://scikit-learn.org/stable/modules/generated/sklearn.linear_model.RidgeCV.html) model, or \cite{golub78} for a statistical perspective.
The presentation below is different but the gist in terms of the complexity gain is the same.

### Tall case

Let us write $X_{(i)} = Ω_{(i)} X$ where $Ω_i$ is the identity matrix with the $i$th row removed.
We then also have $y_{(i)}=\Omega_{(i)}y$.
It is not hard to show that $Ω_{(i)}^tΩ_{(i)} = (I - D_{(i)})$ where $D_{(i)}$ is an all-zero matrix with a 1 on the \nobr{$i$th} diagonal element.

The $i$th Ridge solution verifies $(X_{(i)}^tX_{(i)} + λI)β_{(i)} = X_{(i)}^t y_{(i)}$.
Using the notations introduced in the previous paragraph, we can rewrite this as

$$ ((X^tX + λI) - X^tD_{(i)}X)β_{(i)} \quad=\quad X^t(I-D_{(i)})y \label{loo1}$$

If we write $H = (X^tX + λI)$, then we know that it can be efficiently inverted assuming  we have initially computed the SVD of $X^tX$.
Note also that $X^tD_{(i)}X = x_i x_i^t$.

On the left-hand side of \eqref{loo1} we have therefore a rank-1 perturbation of an invertible matrix.
The inverse of such a matrix can be readily expressed using the Sherman-Morrison formula (see the page on [matrix inversion lemmas](/pub/csml/mtheory/matinvlem.html) for details):

$$ (H - x_ix_i^t)^{-1} \quad=\quad H^{-1} + {H^{-1}x_i x_i^t H^{-1} \over 1 - x_i^t H^{-1} x_i}. $$

Plugging this in the lhs of \eqref{loo1}, we can get an explicit expression for $β_{(i)}$.
But remember that what we really want is $e_i$ so that we're more interested in $x_i^t β_{(i)}$:

$$ x_i^tβ_{(i)} \quad=\quad \left(x_i^t H^{-1} + {x_i^tH^{-1}x_i x_i^t H^{-1}\over 1-x_i^tH^{-1}x_i}  \right)X^t(I-D_{(i)})y. $$  

As it turns out, this can be simplified a fair bit.
Note that the second factor can be re-written $X^ty - X^tD_{(i)}y$ but that last term is simply $x_iy_i$; let also $z=X^ty$ which can be pre-computed and let $γ=x_i^tH^{-1}x_i$.
Then, massaging a bit, we get

$$ x_i^tβ_{(i)} \quad=\quad {x_i^t H^{-1}z - γy_i\over 1-γ}, $$

and, correspondingly, $e_i = (x_i^tH^{-1}z - y_i) / (1-γ)$.

To conclude, with $H^{-1} = V(Σ^2+λI)^{-1}V^t$, $w = V^tz$, $g_i=V^tx_i$ and $g̃_i = (Σ^2+λI)^{-1}g_i$, we can rewrite the computation of $e_i$ as

$$ e_i \quad = \quad {g̃_i^t w - y_i \over 1 - g̃_i^tg_i} \label{loo-trick} $$

and  the cost of computing _all_ the LOO errors is:

@@ctable
Operation | Dominating complexity
:-------- | :--------------------:
form $X^tX$ and compute its SVD | $O(np^2)$
pre-compute $z=X^ty$ and $w=V^tz$ | $O(pn)$
($∀i$) compute $g_i = V^tx_i$ | $O(p^2)$
($∀i,λ$) compute $g̃_i = (Σ^2+λI)^{-1} g_i$ | $O(p)$
($∀i,λ$) compute $e_i = (g̃_i^tw - y_i) / (1-g̃_i^tg_i)$ | $O(p)$
@@

So overall, the initial setup cost is dominated by $O(np^2)$ and the subsequent cost is that of computing each $g_i$: $O(np^2)$; finally there's a cost $O(npκ)$ where $κ$ is the number of $λ$ tested.

In other words, modulo constant factors, it costs the same to get _all_ the LOO errors for $O(p)$ different $\lambda$ than to get a single Ridge solution!

### Fat case

When $p > n$, we already know that it's beneficial to consider the SVD of $XX^t = UΣ^2U^t$ instead of that of $X^tX$.
Here it turns out that just taking \eqref{loo-trick} and computing $g_i, g̃_i$ and $w$ in terms of $U$ and $X$ instead of $V$ is all we need to do; for this recall that $X = UΣV^t$ so that $V^t = Σ^{-1}U^tX$:

@@ctable
Operation | Dominating complexity
:-------- | :--------------------:
form $K = XX^t$ and compute its SVD | $O(pn^2)$
pre-compute $w=Σ^{-1}U^t K y$ | $O(n^2)$
($∀i$) compute $g_i = Σ^{-1} U^t X x_i$ | $O(np)$
($∀i,λ$) compute $g̃_i = (Σ^2+λI)^{-1} g_i$ | $O(n)$
($∀i,λ$) compute $e_i = (g̃_i^tw - y_i) / (1-g̃_i^tg_i)$ | $O(n)$
@@

So overall, the initial setup cost is dominated by $O(pn^2)$ and the subsequent cost is that of computing each $g_i$: $O(pn^2)$; finally there's a cost $O(n^2κ)$ where $κ$ is the number of $λ$ tested.

Again, modulo constant factors, it costs the same to get all the LOO errors for $O(p)$ different $λ$ than to get a single Ridge solution.

### Simple code

We can easily check all this with code again, let's extend the previous case:

```!
using InvertedIndices
i = 5   # random index between 1 and n
λ = 2.5

X̃ᵢ = X_fat[Not(i),:]
ỹᵢ = y_fat[Not(i),:]
β̃ᵢ = basic_ridge_solve(X̃ᵢ, ỹᵢ, λ)

xᵢ = vec(X_fat[i,:])
yᵢ = y_fat[i]
rᵢ = dot(xᵢ, β̃ᵢ) - yᵢ; # this the i-th LOO residual
```

Now let's show we can recover this using the previous point:

```!
K = Symmetric(X_fat * X_fat')
F = svd(K)
U, Ut, S = F.V, F.Vt, F.S
Σ² = S
Σ  = sqrt.(S)

w  = (Ut * (K * y_fat)) ./ Σ
gᵢ = (Ut * (X_fat * xᵢ)) ./ Σ
g̃ᵢ = gᵢ ./ (Σ² .+ λ)

rᵢ ≈ (dot(g̃ᵢ, w) - yᵢ) / (1 - dot(g̃ᵢ, gᵢ))
```

Now if we change $i$ and $λ$,

```!
i = 7
λ = 5.5

X̃ᵢ = X_fat[Not(i),:]
ỹᵢ = y_fat[Not(i),:]
β̃ᵢ = basic_ridge_solve(X̃ᵢ, ỹᵢ, λ)

xᵢ = vec(X_fat[i,:])
yᵢ = y_fat[i]
rᵢ = dot(xᵢ, β̃ᵢ) - yᵢ;
```

we only have to recompute `gᵢ` and `g̃ᵢ`:

```!
gᵢ = (Ut * (X_fat * xᵢ)) ./ Σ
g̃ᵢ = gᵢ ./ (Σ² .+ λ)

rᵢ ≈ (dot(g̃ᵢ, w) - yᵢ) / (1 - dot(g̃ᵢ, gᵢ))
```

## Conclusion

In short, provided that computing the SVD of either a $p \times p$ or $n\times n$ matrix is manageable, it's not much more expensive to compute a single Ridge solution than to compute a bunch of solutions or to compute all the LOO errors for a number of different $λ$.

This LOO trick can be generalised to an extent to all leave-some-out schemes; this is covered in the [second part](/pub/csml/glr/ridgecv-2.html).


## References

1. \biblabel{rifkin07}{Rifkin and Lippert (2007)} **Rifkin** and **Lippert**, [Notes on  Regularized Least Squares]( http://cbcl.mit.edu/publications/ps/MIT-CSAIL-TR-2007-025.pdf), 2007. -- Detailed development of a way to get the LOO error in (Kernel) Ridge efficiently, note that their development is not the same than the one presented here but the end result is comparable. Their formula is the one implemented in Sklearn's RidgeCV.
1. \biblabel{golub78}{Golub, Heath and Wahba (1978)} **Golub**, **Heath** and **Wahba**, [Generalized Cross-Validation as a Method for Choosing a Good Ridge Parameter](http://w3.atomki.hu/~efo/hornyak/Tikhonov_references/Technometrics_Golub_Heath_Wahba), 1978. -- Introduction of the GCV parameter, appropriate for selecting $λ$ in the tall case.
