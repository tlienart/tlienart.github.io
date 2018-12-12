@def title = "Matrix inversion lemmas"
@def hascode = true

# Matrix inversion lemmas

The _Woodbury formula_ is maybe one of the most ubiquitous trick in basic linear algebra: it starts with the explicit formla for the inverse of a block 2x2 matrix and results in identities that can be used in kernel theory, the Kalman filter, to combine multivariate normals etc.

## Partitioned matrix inversion

Consider an invertible matrix $M$ made of blocks $A$, $B$, $C$ and $D$ with

$$
M \speq \begin{pmatrix} A & B \\ C & D \end{pmatrix}
$$

where both $A$ and $D$ are assumed to be square and invertible.
The aim is to express the inverse of $M$ in terms of the blocks $A$, $B$, $C$ and $D$ and the inverse of $A$ and $D$.
We can write the inverse of $M$ using an identical structure:

$$
M^{-1} \speq \begin{pmatrix} W & X \\ Y& Z \end{pmatrix},
$$

for some $W$, $X$, $Y$ and $Z$ to be determined.
Using $MM^{-1} = \mathbf I$ since $M$ is assumed to be invertible, we get the following system of equations:

$$
\begin{cases}
    AW + BY &=\esp \mathbf I \\
    AX + BZ &=\esp \mathbf 0 \\
    CW + DY &=\esp \mathbf 0 \\
    CX + DZ &=\esp \mathbf I
\end{cases}
$$

Left multiplying the first two equations by $A\inv$ and the last two by $D\inv$ and re-arranging a little gives
$$
\begin{cases}
    (\mathbf I - A\inv B D\inv C)W  &=\esp A\inv\\
    (\mathbf I - D\inv CA\inv B)Z   &=\esp D\inv\\
\end{cases}
\quad\text{and}\quad
\begin{cases}
    X &=\esp -A\inv B Z\\
    Y &=\esp -D\inv C W
\end{cases}\label{step-A}
$$

The first two equations can be further simplified using that $(E F)\inv = F\inv E\inv$ for square invertible matrices $E$ and $F$:

$$
\begin{cases}
    W &=\esp (A - BD\inv C)\inv\\
    Z &=\esp (D - CA\inv B)\inv
\end{cases}\label{step-WZ}
$$

We started with $MM\inv = \mathbf I$ but we could have started with $M\inv M=\mathbf I$ of course.
This gives an equivalent result but the form obtained for $Y$ and $X$ is different:

$$
\begin{cases}
    Y &=\esp -ZCA\inv\\
    X &=\esp -WBD\inv
\end{cases}
\label{step-B}
$$

### Basic lemmas

Equating the expressions in \eqref{step-A} and \eqref{step-B} for $Y$ gives $D\inv CW = ZCA\inv$ which, combined with \eqref{step-WZ} gives the first lemma.

@@colbox-blue
(**Lemma I**) let $A$ and $D$ be square, invertible matrices of size $n_A\times n_A$ and $n_D\times n_D$ and $B$ and $C$ be matrices of size $n_A\times n_D$ and $n_D\times n_A$, the following identity holds:
$$
D\inv C (A-BD\inv C)\inv \speq (D - CA\inv B)\inv CA\inv.
$$
@@

Equating the expressions in \eqref{step-A} and \eqref{step-B} for $X$ gives $WBD\inv = A\inv B Z $ which, combined with \eqref{step-WZ} gives the second lemma.

@@colbox-blue
(**Lemma II**) under the same assumptions as for Lemma I, the following identity holds:
$$
(A - BD\inv C)\inv BD\inv \speq A\inv B (D - CA\inv B)\inv.\label{lemma2}
$$
@@


### Woodbury formula

One little bit of dark magic is required to get the Woodbury formula (also known as the *Sherman-Morrison-Woodbury formula*): observe that if we take the term $(A-BD\inv C)$ and right-multiply it by $-A\inv$ we get

$$ (A-BD\inv C)(-A\inv) \speq \textcolor{green}{BD\inv}\textcolor{blue}{CA\inv} - \mathbf I  $$

and therefore $BD\inv CA\inv = (I + (A-BD\inv C)(-A\inv)$.
Now if we post-multiply \eqref{lemma2} by $CA\inv$ and re-arrange the expression, we get the desired lemma.

@@colbox-blue
(**Woodbury formula**) under the same assumptions as for Lemma I, the following identity holds:
$$
(A-BD\inv C)\inv \speq A\inv + A\inv B(D-CA\inv B)\inv CA\inv.
$$
@@

of course the same gymnastics can be applied with the term $(D-CA\inv B)\inv$ to obtain

@@colbox-blue
$$
(D-CA\inv B)\inv \speq D\inv + D\inv C(A-BD\inv C)\inv BD\inv.
$$
@@

## A bit of code

If you want to convince yourself that these equations "work", here's a simple script that shows it at work:

```julia
using Test
using Random: seed!
seed!(11325)
n_A = 15; n_D = 7;
A = randn(n_A, n_A);
B = randn(n_A, n_D);
C = randn(n_D, n_A);
D = randn(n_D, n_D);
iA, iD = inv(A), inv(D);
@test inv(A-B*iD*C) ≈ iA + iA*B*inv(D-C*iA*B)*C*iA
@test inv(D-C*iA*B) ≈ iD + iD*C*inv(A-B*iD*C)*B*iD
```

Where we profit from the fact that invertible matrices are dense among square matrices so that there's little chance that `A` and `D` are not invertible in the script above for a given seed.

<!-- ## Useful derived formulas

When considering regularised inverse, we often have to consider expressions of the form $(\lambda I + BC)\inv$.
Using \eqref{lemma2} and letting $C\leftarrow -C$, $A\leftarrow \mathbf I$ and $D\leftarrow \lambda I$, we get

$$
(\lambda \mathbf I + BC)\inv B \speq B(\lambda I -CB)\inv
$$

A simple example for this (though not particularly useful) is the ridge regression with:

$$ \beta_{\text{ridge}} \speq (\lambda\mathbf I + X^TX)\inv X^T y \speq X^T(\lambda\mathbf I + XX^T)\inv y. $$

It is not particularly useful as, usually, $X$ is of size $n\times p$ with $p\ll n$ and therefore we prefer solving a system of size $p\times p$ instead of one of size $n\times n$... -->
