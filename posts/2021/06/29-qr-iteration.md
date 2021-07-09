+++
title = "QR for eigen decomposition"
mintoclevel = 2

descr = """
    Power method and the QR iteration, with code.
    """
tags = ["linear algebra", "code"]
+++

# QR for eigen decomposition

{{page_tags}}

\toc

## Diagonalisation

Let $A \in \mathbb C^{n\times n}$, we call an eigenpair a nonzero vector $v\in\mathbb C^n$ and a scalar $\lambda \in \mathbb C$ if $Av = \lambda v$.
If we can find $n$ linearly independent $\{v_1, \dots, v_n\}$ with corresponding $\{\lambda_1, \dots,\lambda_n\}$ then $A$ is said to be _diagonalisable_ and we can write

$$
  AV \speq V\Lambda
$$

where the columns of $V$ are the $v_k$ and $\Lambda$ is a diagonal matrix with $\Lambda_{kk} = \lambda_k$.
Further, since the $v_k$ are linearly independent, $V$ is invertible and

$$
 A \speq V\Lambda V\inv.
$$

We will focus on determining eigenvalues and eigenvectors of a real-symmetric matrix with distinct eigenvalues which is a simple yet useful base scenario.
As we show below, in that case the eigenvalues are real and the eigenvectors are orthogonal which will allow us to connect things nicely with the previous post on [Gram-Schmidt orthogonalisation and QR factorisation](/posts/2021/06/25-gram-schmidt/).

@@colbox-blue
    **Theorem**: A Hermitian matrix $A$ (i.e. such that $A^\star=A$) has real eigenvalues.
@@

Let $(v, \lambda)$ be any eigenpair for $A$ so that $Av = \lambda v$.
Then, since $A = A^\star$ we have

\eqa{
    (Av)^\star v &=& v^\star A^\star v \speq v^\star (Av)
}
the left and right term imply
\eqa{
    \lambda^\star v^\star v &=& \lambda v^\star v
}
and therefore $\lambda = \lambda^\star$ since $v$ is nonzero.

@@colbox-blue
    **Theorem**: the eigenvectors of a Hermitian matrix $A$ corresponding to distinct eigenvalues are orthogonal.
@@

Let $(v_1, \lambda_1)$ and $(v_2, \lambda_2)$ be two eigenpairs with $\lambda_1\neq \lambda_2$; then,

\eqa{
    (Av_1)^\star (Av_2) &=& (\lambda_1v_1)^\star A v_2 \speq \lambda_1 (Av_1)^\star v_2 \speq \lambda_1^2 v_1^\star v_2 \\
        &=& v_1^\star A (\lambda_2 v_2) \speq \lambda_2^2 v_1^\star v_2.
}
Thus, we have $\lambda_1^2 v_1^\star v_2 = \lambda_2^2 v_1^\star v_2$, but since $\lambda_1 \neq \lambda_2$ we must necessarily have $v_1^\star v_2 = 0$.

@@colbox-blue
  **Corollary**: let $A$ be real-valued and symmetric, then its eigenvectors are real-valued.
@@

This is a trivial consequence of the first theorem: since all eigenvalues are real, for any eigenpair we have $Av = \lambda v$ but since $A$ is real-valued and $\lambda$ is real, we must necessarily have the entries of $v$ be real too.

A last thing we should prove is that a symmetric matrix is always diagonalisable but we'll shove this under the carpet and refer the reader to e.g. \citet{gvl83} for details.

For the rest of this page, we'll assume that $A$ is **real-valued**, **symmetric** and has **distinct** (real) **eigenvalues** $\lambda_k$ with normalised eigenvectors $v_k$ (i.e. the $v_k$ form an orthonormal basis of $\R^n$).
Further, we will assume (without loss of generality) that the $(v_k,\lambda_k)$ are _ordered_ by the absolute value of $\lambda_k$ so that $|\lambda_1|>|\lambda_2|>\dots>|\lambda_n|$.

## The Power Method

Let $c \in \mathbb R^n$ be an arbitrary vector. Since the normalized eigenvectors $v_k$ of $A$ form an orthonormal basis, we can write
$$
    c \speq \sum_{i=1}^n \alpha_i v_i \quad\text{with}\quad \alpha_i \,\,=\,\, \scal{c, v_i}.
$$
Then, multiplying $c$ by the matrix $A^k$ for $k\ge 1$, we have:
$$
    A^kc \speq \sum_{i=1}^n \alpha_i \lambda_i^k v_i \speq \lambda_1^k\left[\alpha_1 v_1 + \sum_{i=2}^n \alpha_i \left({\lambda_i\over \lambda_1}\right)^k v_i\right].
$$
All the ratios $|\lambda_i/\lambda_1|$ are smaller than 1 and so vanish for large $k$ since we assumed that $|\lambda_1|>|\lambda_i|$ for $i=2,\dots,n$.
Let us assume that we picked $c$ such that $\alpha_1 \neq 0$; then, for $k$ sufficiently large, $A^k c$ becomes dominated by $\alpha_1\lambda_1^k v_1$ as all other terms go to zero.

In summary, for a $c$ such that $\scal{c, v_1} \neq 0$, $A^kc$ will align with $v_1$ as $k$ gets larger.
Using $v\propto w$ to mean $v = w / \|w\|$ for nonzero $w$, we can use the following iteration:

* $w^{(1)} \propto Ac$
* $w^{(k)} \propto Aw^{(k-1)}$ for $k=2,\dots$

for sufficiently large $k$, $w^{(k)}$ is approximately aligned with $v_1$.
Correspondingly, we will have $Aw^{(k)} \approx \lambda_1 w^{(k)}$ and can recover an approximation of $\lambda_1$ considering the _Raleigh quotient_:

$$
    \rho^{(k)} \speq { \scal{Aw^{(k)}, w^{(k)}} \over \scal{w^{(k)}, w^{(k)}} }
$$

and $\rho^{(k)} \to \lambda_1$ with increasing $k$.

### Implementation

The power method is very simple to implement, here's a basic implementation in Julia which shows convergence:

```!
using LinearAlgebra, StableRNGs

function power_method(A::Symmetric, x0; iter=10)
    λ_max = eigmax(A)   # to show convergence
    w = copy(x0)
    Aw = zero(w)
    ρ = zero(eltype(w))
    for i = 1:iter
        Aw .= A * w
        ρ  = dot(Aw, w) / dot(w, w)
        w .= normalize(Aw)
        println("Step $i: ", round(abs((ρ - λ_max) ./ λ_max), sigdigits=2))
    end
    return w, ρ
end

rng = StableRNG(555)
n = 5
A = Symmetric(rand(rng, n, n))
c = randn(rng, n)

w, ρ = power_method(A, c)
err_eig = round(norm(A * w - ρ * w), sigdigits=2)
println("‖Aw - ρw‖: $err_eig")
```

## From the Power Method to the QR iteration

### Power-Method + projection

The power method as shown above can fairly easily give us $(\lambda_1, v_1)$ but what about the other eigenpairs?
Let $c_1$ be an arbitrary vector with $\scal{c_1, v_1} \neq 0$, we've shown that the power method leads to $w_1^{(k)} \approx v_1$ for suitably large $k$.
We could subtract the projection of $c_1$ onto the space spanned by $w_1^{(k)}$ and apply the power method to try to get $v_2$.
Indeed, with $c_1 = \sum_{i=1}^n \scal{c_1, v_i} v_i$, we'd have

\eqa{
    c_2 &=& c_1 - \scal{c_1, w_1^{(k)}} w_1^{(k)}\\
        &\approx& \sum_{i=2}^n \scal{c_1, v_i} v_i
}

and with the same development as that of the previous point, we get that $A^kc_2 \propto v_2$ (approximately).
We could iterate this approach until we've approximated all $v_n$:

* take $c_j = c_{j-1} - \scal{c_{j-1}, w^{(k)}_{j-1}} w^{(k)}_{j-1}$
* let $w^{(k)}_j \propto A^kc_j$

for sufficiently large $k$, each of the $w^{(k)}_j$ would be approximately equal to $v_j$.
Note that we wouldn't have to use the same $k$ at every power-step and could just use whatever $k$ is large enough to reach some notion of convergence.

### Enters the QR factorisation

We could try improving on the previous procedure so that we compute all the vectors simultaneously.
For this, consider an arbitrary matrix $C_1 \in \R^{n\times n}$ instead of a single vector $c$ and repeatedly apply the following steps:

1. compute $M_k = AC_k$
2. extract an orthonormal basis $Q_k$ out of $M_k$ via the QR algorithm i.e, $M_k = Q_kR_k$
3. let $C_{k+1}=Q_k$ and go to step 1.

this amounts effectively to the same steps as before but instead of going for all vector index $j$ and then for each power index $k$, we go for each power index $k$ and for all vector index $j$.

A specific $C_1$ we could use of course is $Q_1=Q$, the factor of $A=QR$ with then:

1. compute $M_k = AQ_{k-1}$ for $k=2, \dots$,
2. compute the QR factorisation of $M_k = Q_k R_k$.

Taking a look at the first few iterations, we have:

\eqa{
    A &=& Q_1 R_1 \\
    M_2 &=& AQ_1 \speq Q_2 R_2 \\
    M_3 &=& AQ_2 \speq Q_3 R_3
}
and so on. The second line can also be written $Q_1R_1Q_1 = Q_2R_2$ or

$$
    R_1Q_1 \speq Q_{12}R_2
$$

with $Q_{12} = Q_1^t Q_2$ (which is still orthonormal).
In a similar fashion, we can massage the third line into:

$$
    A(Q_1 Q_1^t)Q_2 \speq Q_3 R_3
$$

or $Q_2R_2Q_{12} = Q_3R_3$ which we can also write as

$$
    R_2Q_{12} = Q_{23}R_3
$$

with $Q_{23} = Q_2^tQ_3$. Bootstrapping from there, we can write $R_kQ_{k-1,k} = Q_{k,k+1}R_{k+1}$ with $Q_{01}=Q_1$ and it's easy to show that $Q_1\dots Q_k Q_{k,{k+1}} = Q_{k+1}$.

The advantage of expressing the whole iteration in terms of orthonormal matrices is that it's more numerically stable than repeatedly applying $A$ which can be poorly conditioned.
Writing it out, we have:

1. get $(Q_{k,k+1}, R_{k+1}) = \text{qr}(R_{k} Q_{k-1,k})$ with $Q_{01}, R_1=\text{qr}(A)$,
2. compute $Q_{k+1} = Q_k Q_{k,k+1}$.

This is the (basic) QR iteration algorithm, also known as the Francis QR algorithm \citep{gvl83}.
For $k$ sufficiently large, the columns of $Q_{k+1}$ will align with the eigenvectors of $A$ so that $AQ_{k+1} \approx Q_{k+1}\mathrm{diag}(\lambda_1, \dots, \lambda_n)$. Correspondingly, we approximate the eigenvalues with

$$
    Q_{k+1}^tAQ_{k+1} \spe{\approx} \text{diag}(\lambda_1, \dots, \lambda_n).
$$

### Implementation

A basic version of the QR algorithm is fairly easy to implement as shown below with an implementation in Julia.
The function is called `francis_qr` since the algorithm is sometimes called "Francis QR algorithm" in reference to the english computer scientist [John Francis](https://en.wikipedia.org/wiki/John_G._F._Francis), see e.g. \citet{gvl83}.

```!
using PyPlot

function francis_qr(A::Symmetric; iter=20)
    λ = sort(eigvals(A), by=abs, rev=true)   # to show convergence
    Q̃, R̃ = qr(A)
    Q = copy(Q̃)
    D = zero(Q)
    δ = zeros(iter)
    for i = 1:iter
        Q̃, R̃ = qr(R̃ * Q̃)    # step 1
        Q *= Q̃              # step 2
        # computations to show convergence
        D    = Q' * A * Q
        λ̂    = diag(D)
        δ[i] = maximum(abs.((λ̂ .- λ) ./ λ))
    end
    return Q, D, δ
end

rng = StableRNG(510)
n = 5
A = Symmetric(rand(rng, n, n))

Q, D, δ = francis_qr(A)

figure(figsize=(8, 6))
semilogy(δ, marker="x")
xlabel("Number of iterations")
ylabel("Maximum relative error")
xticks([1, 5, 10, 15, 20])
savefig(joinpath(@OUTPUT, "conv.svg")) # hide

Λ = Diagonal(D)

err_offdiag = round(maximum(abs.(D - Λ)), sigdigits=2)
println("|D-Λ|: $err_offdiag")

err_diag = round(maximum(abs.(A * Q - Q * Λ)), sigdigits=2)
println("|AQ-QΛ|: $err_diag")
```

@@reduce-vspace \fig{conv.svg} @@

In this form, the algorithm computes $K$ QR factorisations of an $n\times n$ matrix and computes $2K$ matrix-matrix of the same sizes.
All these operations are $\mathcal O(n^3)$ so, overall, the complexity is $O(Kn^3)$ where $K$ is the number of iterations.

### Generalisations

Here we only considered a fairly simple case (symmetric matrix with distinct eigenvalues).
In practice, the QR algorithm is more sophisticated, can deal with non-symmetric matrices and encourage convergence by introducing shifts in the iteration.

See \citet{gvl83} for a much more detailed approach on the topic, \citet{t19} is also a nice tutorial discussing the QR algorithm and its shifted variants.

## Short references

1. \biblabel{gvl83}{Golub and Van Loan (1983)} **Golub**, **Van Loan**, [Matrix Computations](https://twiki.cern.ch/twiki/pub/Main/AVFedotovHowToRootTDecompQRH/Golub_VanLoan.Matr_comp_3ed.pdf), 1983. -- Chapter 7 covers the QR algorithm and chapter 8 considers optimisations for the symmetric case.
1. \biblabel{p06}{Persson (2006)} **Persson**, [The QR algorithm II](https://dspace.mit.edu/bitstream/handle/1721.1/75282/18-335j-fall-2006/contents/lecture-notes/lec16.pdf), 2006. -- A slide deck on the QR algorithm shifted QR and numerical stability.
1. \biblabel{t19}{Townsend (2019)} **Townsend**, [The QR algorithm](http://pi.math.cornell.edu/~web6140/TopTenAlgorithms/QRalgorithm.html), 2019. -- A tutorial on the QR algorithm using Julia and discussing the shifted QR algorithm.
