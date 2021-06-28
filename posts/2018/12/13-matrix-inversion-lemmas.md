+++
title = "Matrix inversion lemmas"
descr = "Investigating the Woodbury formula and the Sherman-Morrison formula."
tags = ["linear algebra"]
+++

# Matrix inversion lemmas

{{page_tags}}

{{redirect /pub/csml/mtheory/matinvlem.html}}

The _Woodbury formula_ is maybe one of the most ubiquitous trick in basic linear algebra: it starts with the explicit formula for the inverse of a block 2x2 matrix and results in identities that can be used in kernel theory, the Kalman filter, to combine multivariate normals etc.

In these notes I present a simple development leading to the Woodbury formula, and the special case of the Sherman-Morrison formula with some code to show those at work.

\toc

## Partitioned matrix inversion

Consider an invertible matrix $M$ made of blocks $A$, $B$, $C$ and $D$ with

$$
M \speq \begin{pmatrix} A & B \\ C & D \end{pmatrix} \label{block-m}
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

Let us assume that both $(\mathbf I - A\inv B D\inv C)$ and $(\mathbf I - D\inv CA\inv B)$ are invertible, then the first two equations can be further simplified using that $(E F)\inv = F\inv E\inv$ for invertible matrices $E$ and $F$:

$$
\begin{cases}
    W &=\esp (A - BD\inv C)\inv &=\esp (D^s)\inv\\
    Z &=\esp (D - CA\inv B)\inv &=\esp (A^s)\inv
\end{cases}\label{step-WZ}
$$

where the matrix $D^s := (A-BD\inv C)$ (resp. $A^s := (D-CA\inv B)$) are called the _Schur-Complement_ of $D$ (resp. $A$).
We will come back to these when revisiting the assumptions made in [a subsequent point](#revisiting_the_assumptions)

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
D\inv C (A-BD\inv C)\inv \speq (D - CA\inv B)\inv CA\inv.\label{lemma1}
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

One little bit of dark magic is required to get the Woodbury formula: observe that if we take the term $(A-BD\inv C)$ and right-multiply it by $-A\inv$ we get

$$ (A-BD\inv C)(-A\inv) \speq \textcolor{green}{BD\inv} \textcolor{blue}{CA\inv} - \mathbf I  $$

and therefore $BD\inv CA\inv = (\mathbf I + (A-BD\inv C)(-A\inv))$.
Now if we post-multiply \eqref{lemma2} by $CA\inv$ and re-arrange the expression, we get the third lemma.

@@colbox-blue
(**Lemma III**) under the same assumptions as for Lemma I, the following identity holds:
$$
(A-BD\inv C)\inv \speq A\inv + A\inv B(D-CA\inv B)\inv CA\inv.\label{lemma3}
$$
@@

of course the same gymnastics can be applied with the term $(D-CA\inv B)\inv$ to obtain a similar identity.

To obtain the classical Woodbury formula though, we just need to reassign letters with $E\leftarrow A$, $F\leftarrow -B$, $G\leftarrow D\inv$ and $H\leftarrow C$.
(So Lemma III is already the Woodbury formula, the re-assignment only leads to a somewhat more visually pleasing form)

@@colbox-blue
(**Woodbury formula**) let $E$, $G$ be square invertible matrices of dimensions $n_E \times n_E$ and $n_G\times n_G$ respectively, let $F$ and $H$ be matrices of size $n_E\times n_G$ and $n_G\times n_E$ respectively, then the following identity holds:
$$ (E+FGH)\inv \speq E\inv - E\inv F(G\inv + HE\inv F)\inv H E\inv\label{woodbury} $$
@@

### Sherman-Morrison formula

Consider again \eqref{woodbury} and let $G=1$, $F=u$ and $H=v$ with $u, v\in\R^{n_E}$ then the formula gives

$$ (E+uv^T)\inv \speq E\inv -{E\inv u v^T E\inv\over 1 + v^T E\inv u}, $$

a useful expression for the inverse of a matrix combined with a rank-1 perturbation.
This is used for instance in the development of the famous BFGS flavour of the Quasi-Newton iterations (see e.g. the [wikipedia article](https://en.wikipedia.org/wiki/Broyden%E2%80%93Fletcher%E2%80%93Goldfarb%E2%80%93Shanno_algorithm)).  

## Revisiting the assumptions

> thanks to [Christopher Yeh](https://github.com/chrisyeh96) for the interesting discussion on this topic. Chris also wrote [a post](https://chrisyeh96.github.io/2021/05/19/schur-complement.html) on this topic.

In the development above, we made a few assumptions to simplify the development, sometimes stronger than needed.
We can now make those more precise without risking confusion.

Let us start with the same description of $M$ as in \eqref{block-m}; we had introduced the _Schur-Complement_ of $A$ as $A^s := (D - CA\inv B)$, and that of $D$ as $D^s := (A - BD\inv C)$.

With those definitions, we have the following set of properties:

@@colbox-blue
(**Theorem**) Let $M$ be as in \eqref{block-m}:
* (1A) if both $M$ and $A$ are invertible then $A^s$ is invertible,
* (1B) if both $M$ and $D$ are invertible then $D^s$ is invertible,
* (2A) if $A$ and $A^s$ are invertible then $M$ is invertible,
* (2B) if $D$ and $D^s$ are invertible then $M$ is invertible,
* (3) if both $A$ and $D$ are invertible as well as one of $\{M, A^s, D^s\}$, then they all are.
@@

(**1A - proof**) take $z = (x_1, x_2)$ a vector of dimension compatible with $M$ and such that $A^s x_2 = 0$ so that $Dx_2 = CA\inv B x_2$.
Then, considering $Mz$ gives:

$$
  Mz = (Ax_1 + Bx_2, Cx_1 + CA\inv B x_2)
$$

since $A$ is invertible, we can form $x_1 = -A\inv B x_2$ so that $Mz=0$.
Since $M$ is invertible, $z=0$ and thus necessarily $x_2=0$ so that $A^s$ is invertible.
Proof of **1B** is identical.

(**2A - proof**) let $z=(x_1, x_2)$ such that $Mz=0$ then

\eqa{
  Ax_1 + Bx_2 &=& 0\\
  Cx_1 + Dx_2 &=& 0
}

since $A$ is invertible, we can write $x_1 = -A\inv Bx_2$ and the second equation becomes

$$
  (D - CA\inv B)x_2 \speq 0
$$

or $A^s x_2 = 0$. But since $A^s$ is invertible, $x_2=0$ and therefore $x_1=0$ so that $z$ is necessarily $0$ and $M$ is invertible. Proof of **2B** is identical.

(**3 - proof**) this is trivially implied by combining the previous properties.

### Back to the development

In the development we were working under (**3**) with $A$, $D$ and $M$ invertible (and therefore $A^s$ and $D^s$ as well).
We had then made the assumption that $(\mathbf I-A\inv BC)$ and $(\mathbf I - D\inv CA\inv)$ were invertible, but these are actually implied by the fact that respectively $D^s$ and $A^s$ are invertible.
Indeed, taking the first one, if we take $z$ such that

$$
  (\mathbf I-A\inv B D\inv C)z \speq 0
$$

and left-multiply by $A$, we have

$$
  (A - BD\inv C)z \speq D^sz \esp = \esp 0
$$

but since $D^s$ is invertible (by **3**), $z=0$ so that $(\mathbf I-A\inv BD\inv C)$ is invertible (the second case is identical).

## A bit of code

If you want to see these equations at work, here's a simple Julia script:

```julia
using Test
using LinearAlgebra: dot

# Woodbury formula
n_E, n_G = 13, 15;
E = randn(n_E, n_E);
F = randn(n_E, n_G);
G = randn(n_G, n_G);
H = randn(n_G, n_E);
iE, iG = inv(E), inv(G);
@test inv(E+F*G*H) ≈ iE - iE*F*inv(iG + H*iE*F)*H*iE

# Sherman-Morrison formula
n_E = 23;
E = randn(n_E, n_E);
u = randn(n_E);
v = randn(n_E);
iE = inv(E)
iEu = iE*u
@test inv(E + u*v') ≈ iE - (iEu*(v'*iE))/(1+dot(v, iEu))
```

(Recall that invertible matrices are dense among square matrices so that using randomly generated matrices for $E$ and $G$ is unlikely to cause problems).

[Tim Holy](https://github.com/timholy) has written a simple  package for this called [`WoodburyMatrices.jl`](https://github.com/timholy/WoodburyMatrices.jl).

```julia
using WoodburyMatrices
W = Woodbury(E, F, G, H);
b = randn(n_E);
# using the package
s1 = W\b;
# hand-coding using the formula
iEb = iE*b;
s2  = iEb - iE*(F*((iG+H*iE*F)\(H*iEb)))
@test s1 ≈ s2
```
