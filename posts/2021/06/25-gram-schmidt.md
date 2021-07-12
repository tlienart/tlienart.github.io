+++
title = "Gram-Schmidt Orthogonalisation"
mintoclevel = 2

descr = """
    Gram-Schmidt, Modified Gram-Schmidt, QR factorisation, with code.
    """
tags = ["linear algebra", "code"]
+++

# Gram-Schmidt Procedure

{{page_tags}}

\toc

## Orthonormal basis

A set $\{u_1, \dots, u_n\}$ of vectors in $\R^n$ is an _orthonormal basis_ of $\R^n$ if $\scal{u_i, u_j}=\delta_{ij}$ for any $i,j \in \{1,\dots, n\}$.
For such a set, any vector $w$ in $\R^n$ can be expressed as a linear combination of the $u_i$:
$$ w \speq \sum_{i=1}^n \alpha_i u_i, $$
where the weights $\alpha_i$ can easily be obtained by leveraging the orthonormality:
\eqa{
    \scal{w, u_j} &=& \scal{\sum_{i=1}^n\alpha_i u_i, u_j} \\
                    &=& \sum_{i=1}^n\alpha_i \delta_{ij} \speq \alpha_j. }

Denoting $U$ the $n \times n$ matrix with columns $\{u_1, \dots, u_n\}$, the above can be written more compactly as $UU^t=I$, and

$$ w \speq Ua \quad\Longleftrightarrow\quad a \speq U^tw, $$

with $a \in \R^n$ the vector whose $j$-th component is $\alpha_j$.


## Constructing an orthonormal basis out of a set of independent vectors

Let's say we have $\{v_1, \dots, v_n\}$, a set of $n$ &nbsp;_linearly independent_ vectors in $\R^n$.
We can construct an orthonormal basis $\{q_1, \dots, q_n\}$ iteratively by starting with

$$ q_1 \spe{\propto} v_1 $$

where $\propto$ is used to mean that the left-hand-side is proportional to the right-hand-side and has euclidean norm 1 (i.e. here $q_1 = v_1/\|v_1\|$, note that $v_1$ cannot be zero otherwise the set wouldn't be independent).

The next vector, $q_2$, should be orthogonal to $q_1$ and should span $\mathrm{Im}\{v_1, v_2\}$.
Assume we have that $q_2$ for now.
We can then write:

\eqa{
     v_2 &=& \alpha_{21} q_1 + \alpha_{22} q_2
 }

From the previous point, we know that $\alpha_{21} = \scal{v_2, q_1}$ so that

$$
    q_2 \spe{\propto} v_2 - \scal{v_2, q_1} q_1.
$$

The term $\scal{v_2, q_1} q_1$ is the projection of $v_2$ onto the space spanned by $q_1$.

Iterating this is the _Gram-Schmidt procedure_ (GS):

\eqa{
    q_k \spe{\propto} v_k - \displaystyle\sum_{i=1}^{k-1}\scal{v_k, q_i} q_i \label{gs1}
}

In words, to construct the $k$-th direction of the basis, we take $v_k$ and subtract is projection onto the space spanned by $\{q_1, \dots, q_{k-1}\}$.

### Side note on the QR and Cholesky decomposition

After the $k$-th step of GS, we can express the vector $v_k$ as a linear combination of the $\{q_1,\dots,q_k\}$:

$$
    v_k \speq \sum_{i=1}^k \scal{v_k, q_i} q_i.
$$

Let $Q$ be the matrix with columns $\{q_1,\dots,q_k\}$ then the above expression can be written $v_k = Qr_k$ where $r_k$ is a vector of $n$ components with $i$-th component given by

$$
    (r_{k})_i \speq \begin{cases} \,\scal{v_k, q_i} &\text{for}\quad i \in \{1, \dots, k\}\\
    \quad\,\, 0 &\text{for}\quad i \in \{k+1, \dots, n\}\end{cases}.
$$

In matrix form, we can write

$$
    V \speq QR \label{qr1}
$$

where $V$ is the $n\times n$ matrix with columns $\{v_1, \dots, v_n\}$ and $R$ is an $n\times n$ upper triangular matrix with \nobr{$r_{ik} = \scal{v_k, q_i} 1_{i\le k}$}.

Such a decomposition of a full-rank matrix into a product of an orthogonal matrix $Q$ and an upper-triangular matrix $R$ is called a QR-decomposition or QR-factorisation.

@@alert,alert-secondary
    **Note**: while the GS procedure is one way of obtaining a QR-factorisation of a matrix, it is not the only one and usually not the one that is used in practice as other methods (Householder, Givens) have better computational properties see e.g. \citet{gvl83}.
@@

A final observation is that, starting from \eqref{qr1}, we have:

$$
    V^t V \speq R^tR.
$$

Provided the diagonal elements of $R$ are positive, the $R$ matrix is thus also the Cholesky factor of $V^tV$.
We can always constrain the diagonal elements of $R$ to be positive since $r_{ii} = \scal{v_i, q_i}$, and we can just swap the sign of $q_i$ after computing \eqref{gs1}.

### What if the original vectors are not independent?

Let's now say we have $\{v_1, \dots, v_m\}$ a set of $m$ vectors in $\R^n$ that are not necessarily linearly independent.
Let $p \le \min(m, n)$ the dimension of the space spanned by these vectors, we can apply GS to find $\{q_1, \dots, q_p\}$ an orthonormal basis of that space.
The procedure is identical except some iterations where the right-hand-side of \eqref{gs1} is zero (i.e. $v_k$ can be fully represented by the ongoing set of $q_j$), in which case we just skip that step.

More explicitly, the steps are:

1. $q_1 \propto v_1$; let $c=2, k=2$
2. compute $w = v_k - \sum_{i=1}^{c-1}\scal{v_k, q_i} q_i$
   1. if $w=0$, increment $k$ (the vector $v_k$ can already be represented by the  running $q_i$)
   2. otherwise, let $q_c \propto w$ and increment both $c$ and $k$

Once the last $v_k$ has been seen, we have a set of $p$ orthogonal vectors $\{q_1, \dots, q_p\}$ that forms a basis in which we can represent all of the $v_k$.

### Computational complexity of GS

Say we have $m$ vectors in $\R^n$ and want to form an orthonormal basis for those.
At step $c$ of the algorithm, we have to:

* compute $(c-1)$ dot products i.e. $\mathcal O(cn)$ flops,
* compute $c$ sums of vectors i.e. $\mathcal O(cn)$ flops,
* normalise a vector i.e. $\mathcal O(n)$ flops

i.e. $\mathcal O(cn)$ per step.
We have to consider all $m$ vectors (unless $m > n$ and $c$ reaches $n$ before $k$ in which case we can stop early).
To simplify let's say we consider all of them, so that we sum over $c=1,\dots,m$.
Then the overall complexity is $\mathcal O(nm^2)$.

## Implementing GS

We can code a simple version of GS in Julia, transcribing the core loop explicitly and not caring about allocations or optimisations so that the code is very simple to read:

```!
using LinearAlgebra

function gs(A::Matrix{T}; tol=1e-10) where T
    n, m = size(A)
    Q = zeros(n, n)
    R = zeros(n, m)
    c = 1
    for k = 1:m
        w = A[:, k]
        for i = 1:c-1
            R[i, k] = dot(A[:, k], Q[:, i])
            w .-= R[i, k] .* Q[:, i]            # w = a_k - ∑⟨a_k, q_i⟩q_i
        end
        η = norm(w)
        η < tol && continue                     # check if w ≈ 0
        Q[:, c] .= w ./ η
        R[c, k] = dot(A[:, k], Q[:, c])
        c += 1
    end
    p = c - 1
    return Q[:, 1:p], R[1:p, :]
end
```

@@alert,alert-warning
  **Note**: if you're not used to Julia, you might wonder about the dots (`.`) preceding operators in the code above. They generally mean "element-wise operation" so for instance `w .-= v` effectively means `w[i] -= v[i]` for each `i`. See also [this excellent post](https://julialang.org/blog/2017/01/moredots/) on the topic.
@@

We can quickly check this works as expected:

```!
using StableRNGs
rng = StableRNG(512)

err(E) = println("Max error: ", round(maximum(abs.(E)), sigdigits=2))

n, m = 10, 5
A = randn(rng, n, m)
Q, R = gs(A)
err(Q' * Q - I)
err(Q * R - A)

n, m = 10, 20
A = randn(rng, n, m)
Q, R = gs(A)
err(Q' * Q - I)
err(Q * R - A)
```

@@alert,alert-warning
  **Note**: [`StableRNGs`](https://github.com/JuliaRandom/StableRNGs.jl) is a library that offers guaranteed reproducible streams of random numbers so that if you run the code above you should get exactly the same results as shown here.
@@

The code above considers two toy examples: one where there's fewer vectors than dimensions and that are linearly independent with high probability and one where there's more vectors than dimensions and so that are necessarily not linearly independent.

In both cases, we check whether $Q^tQ=I$ (orthogonal columns) and whether $QR=A$ by looking at the residuals. As can be seen above, they're extremely small which confirms that, in simple settings, the code above does the right thing.

### Numerical stability and modified-GS

The procedure above (often referred to as _classical Gram-Schmidt_ or CGS) is not numerically stable in that floating-point errors in computation of the $q_i$ will compound badly in the expression \eqref{gs1}.
We won't do the stability analysis in details, see for instance \citet{bjorck10}.

An alternative algorithm is the _modified Gram-Schmidt_ or MGS where \eqref{gs1} is re-organised as an iteration:

* $w^{(1)} = v_k - \scal{v_k, q_1} q_1$,
* $w^{(i)} = w^{(i-1)} - \scal{w^{(i-1)}, q_{i-1}} q_{i-1}$ for $i=2, \dots, k-1$.

In exact arithmetic, this is exactly the same as \eqref{gs1}, but in the presence of numerical errors, each $w^{(1)}$ is actually obtained as $w^{(1)}+e_1$ for some small error vector $e_1$. However, whereas in \eqref{gs1} these get compounded, in MGS these get projected which leads to better numerical properties.

In Julia, it's easy to work in lower precision than 64 bits which can help highlight the benefit.
Modifying the code above for the modified variant is trivial, we just need to replace the line `R[i, k] = dot(A[:, k], Q[:, i])` for `R[i, k] = dot(w, Q[:, i])`:

```!
function mgs(A::Matrix{T}; tol=1e-10) where T
    n, m = size(A)
    Q = zeros(T, n, n)
    R = zeros(T, n, m)
    c = 1
    for k = 1:m
        w = A[:, k]
        for i = 1:c-1
            R[i, k] = dot(w, Q[:, i])           # the modification
            w .-= R[i, k] .* Q[:, i]            
        end
        η = norm(w)
        η < tol && continue
        Q[:, c] .= w ./ η
        R[c, k] = dot(A[:, k], Q[:, c])
        c += 1
    end
    p = c - 1
    return Q[:, 1:p], R[1:p, :]
end
```

Let's see how this fares:

```!
rng = StableRNG(5511)

A = Float16.(rand(rng, 50, 50).^2)

Q, R = gs(A)
Qm, Rm = mgs(A)

err(Q' * Q - I)
err(Q * R - A)
err(Qm' * Qm - I)
err(Qm * Rm - A)
```

There is an improvement though maybe not a spectacular one.
There are however cases where CGS can be catastrophically bad whereas MGS still fares well, we refer the reader to the references in \citet{bjorck10} for more on this.

## Short references

1. \biblabel{gvl83}{Golub and Van Loan (1983)} **Golub**, **Van Loan**, [Matrix Computations](https://twiki.cern.ch/twiki/pub/Main/AVFedotovHowToRootTDecompQRH/Golub_VanLoan.Matr_comp_3ed.pdf), 1983. -- Chapter 5 covers the QR factorisation with the Householder and Givens methods.
1. \biblabel{bjorck10}{Björck (2010)} **Björck**, [Gram-Schmidt Orthogonalization: 100 Years and More](https://www.cis.upenn.edu/~cis610/Gram-Schmidt-Bjorck.pdf), 2010. -- slides 16 to 23 discuss the loss of orthogonality in classical GS and bounds in modified GS.
