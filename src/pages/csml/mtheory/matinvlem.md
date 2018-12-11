@def title = "Matrix inversion lemmas"

# Matrix inversion lemmas

The _Woodbury formula_ is maybe one of the most ubiquitous trick in basic linear algebra: it starts with the explicit formla for the inverse of a block 2x2 matrix and results in identities that can be used in kernel theory, the Kalman filter, to combine multivariate normals etc.

## Partitioned matrix inversion

Consider an invertible matrix $M$ made of invertible blocks $A$, $B$, $C$ and $D$ with appropriate dimensions.
Then, the inverse of $M$ can be written as

$$
M \speq \begin{pmatrix} A & B \\ C & D \end{pmatrix} \spe{\text{and}} M^{-1} \speq \begin{pmatrix} W & X \\ Y& Z \end{pmatrix},
$$

for some $W$, $X$, $Y$ and $Z$ to be determined.
Clearly, we need to have $MM^{-1} = \mathbf I$ since $M$ is assumed to be invertible, this gives:

$$
\begin{cases}
    AW + BY &=\esp \mathbf I \\
    AX + BZ &=\esp \mathbf 0 \\
    CW + DY &=\esp \mathbf 0 \\
    CX + DZ &=\esp \mathbf I
\end{cases}
$$

Solving that system using $A\inv B\inv = (BA)\inv$, we get

$$
\begin{cases}
    W &=\esp (A - BD\inv C)\inv \\
    Y &=\esp -D\inv CW \\
    Z &=\esp (D-CA\inv B)\inv \\
    X &=\esp -A\inv B Z
\end{cases}
$$

### Basic lemmas

We started with $MM\inv = \mathbf I$ but we could have started with $M\inv M=\mathbf I$ of course.
This gives an equivalent result but the form obtained for $Y$ and $X$ is different:

$$
\begin{cases}
    Y &=\esp -ZCA\inv\\
    X &=\esp -WBD\inv
\end{cases}
$$

Equating the expressions for $Y$ gives $D\inv CW = ZCA\inv$ from which we get the first lemma.

@@colbox-blue
(**Lemma I**) the following identity holds for matrices $A$, $B$, $C$ and $D$ of appropriate dimensions:
$$ (A-BD\inv C)\inv \speq C\inv D(D-CA\inv B)\inv CA\inv, $$
assuming $A$, $C$, $D$ and $(A-BD\inv C)$ are invertible.
@@

Equating the expressions for $X$ gives $A\inv B Z = WBD\inv$ from which we get the second lemma.

@@colbox-blue
(**Lemma II**) the following identity holds:
$$ A\inv B(D-CA\inv B)\inv \speq (A-BD\inv C)\inv BD\inv $$
with the same assumptions as for lemma I.
@@


### Woodbury formula

In the right-hand side of lemma I, if we replace the left factor $C\inv D$ by $C\inv(D-CA\inv B)$ and adjust accordingly, we get the **Woodbury formula** (also known as the *Sherman-Morrison-Woodbury formula*).

@@colbox-blue
(**Woodbury formula**) the following identity holds:
$$ (A-BD\inv C)\inv \speq A\inv + A\inv B (D-CA\inv B)\inv CA\inv $$
with the same assumptions as for lemma I.
@@
