+++
pretitle = "GMRES & Conjugate Gradient"
title = "$pretitle &ndash; pt. I"
mintoclevel = 2

descr = """
    Direct and iterative methods for solving a linear system of equations, including GMRES, with code.
    """
tags = ["linear algebra", "code"]
+++

\newcommand{\postGS}{/posts/06/25-gram-schmidt/}
\newcommand{\postQR}{/posts/06/29-qr-iteration/}
\newcommand{\postCG}{/posts/07/05-cg/}

# {{pretitle}} (part I)

{{page_tags}}

Let $A \in \R^{n\times n}$ non singular and $b\in \R^n$, we want to find (or approximate) $x\in \R^n$ such that $Ax = b$.
In this first part we briefly discuss _direct methods_, where one recovers $x$ exactly, and a set of simple _iterative methods_ including the _Generalised Minimal Residual Method_ or GMRES, where one constructs a sequence $x_k \to x$.
Most of what we cover also holds for the case where either $A$ or $b$ have complex entries though we stick to the real case for ease of presentation.

In the [second part](\postCG) we discuss how GMRES is related to Krylov Subspaces as well as improvements when it is known that $A$ is positive definite or symmetric or both.

\toc

## Direct methods

There are plenty of direct methods to solve a linear system, a common one is the [LU-factorisation](https://en.wikipedia.org/wiki/LU_decomposition) where $A$ is decomposed into $A=LU$ with $L$ a lower-triangular matrix and $U$ an upper-triangular one.\\
We won't cover LU here but will briefly cover another approach that leverages the QR-factorisation of $A$ which we introduced in [a previous post](\postGS).
If $A=QR$ with $Q^tQ=QQ^t=I$ and $R$ upper-triangular, then the problem to solve becomes

$$
    Rx = Q^tb. \label{qrls1}
$$

Since $R$ is an upper triangular matrix, this can be solved directly: denoting $x_i$ the $i$-th component of $x$ and letting $\tilde{b} = Q^tb$, equation \eqref{qrls1} can be expanded into

\eqa{
    r_{nn}x_n &=& \tilde{b}_n\\
    r_{n-1,n-1}x_{n-1} + r_{n-1,n}x_n &=& \tilde{b}_{n-1}\\
        &\vdots&
}

which can be iteratively solved with

$$
    x_{k} \speq r_{kk}\inv\left(\tilde{b}_k - \sum_{i=1}^{n-k}r_{k,k+i}x_{k+i}\right)\quad\text{for}\quad k=n,n-1,...,1. \label{qrls2}
$$

Here's a simple implementation in Julia:

```!
using StableRNGs, LinearAlgebra
rng = StableRNG(111)

n = 5
A = rand(rng, n, n)
b = rand(rng, n)

Q, R = qr(A)
x = zero(b)
b̃ = Q' * b
for k = n:-1:1
    w = b̃[k]
    for i = 1:n-k
        w -= R[k, k+i] * x[k+i]
    end
    x[k] = w / R[k, k]
end

e = round(norm(A * x - b), sigdigits=2)
println("‖Ax-b‖ = $e")
```

For pairs $(A, b)$ with no specific properties, these direct methods typically have complexity $\mathcal O(n^3)$.
In the QR approach above, the factorisation is the most expensive part, solving the triangular system \eqref{qrls1} is only $\mathcal O(n^2)$.
LU-based solvers typically have a better complexity constant (about half that of QR) and so are preferred in practice but either way, for $n$ "large" (typically, larger than 1000), these methods all become prohibitively expensive.

In what follows, we consider iterative methods which start from a candidate vector $x_0$ and generate a sequence of $x_k$ such that $x_k \to x$ in some sense as $k$ increases with the hope that for some $k$ sufficiently large (and yet $k\ll n$), the solution is "good enough".
Of course each step of such methods should be cheap so that the overall cost of the method to reach a suitable approximation is significantly lower than the $\mathcal O(n^3)$ of a direct method.


## Iterative methods to solve a linear system

We consider iterative methods of the form

$$
    x_{k} \speq x_{k-1} + \alpha_{k} p_{k} \speq x_0 + \sum_{i=1}^{k} \alpha_i p_i \label{iter1}
$$

for some initial candidate $x_0\in\R^n$, a set of linearly independent $p_k \in\R^n$ and some coefficients $\alpha_k\in\R$, all such that $x_k \to x$ as $k$ increases and with  $x_n=x$ (since, ultimately, the $p_k$ form a basis of $\R^n$).

Such a set of vectors $p_k$ can be orthogonalised along the way using the Gram-Schmidt procedure (which we covered in a [previous post](\postGS)) so that $p_k\in \mathrm{span}(q_1,\dots,q_k)$ and \eqref{iter1} can then be expressed as

$$
    \begin{cases}
        q_k &\propto& \,\, p_k - \sum_{i=1}^{k-1} \scal{p_k, q_i} q_i\\
        x_{k} &=& x_0 + \sum_{i=1}^k \beta_i q_i
    \end{cases}
$$

for some coefficients $\beta_i\in\R$.
This amounts to iteratively building an orthonormal basis $\{q_1, \dots, q_k\}$ of a subspace of dimension $k$ and determining an approximate solution $x_{k}$ in it.

There's two elements that can be adjusted in the above procedure:

1. how to pick the $\beta_i$,
2. how to pick the vectors $p_{k}$.

Both of these can be guided by how easy/cheap the iterations are, and how good an approximation $x_{k+1}$ is to the solution $x$.

### Minimum residual criterion

The criterion we'll use on this page is the **minimum residual criterion**.
We will discuss another one in the [follow up post](\postCG).
It's a fairly natural criterion that requires taking the $\beta_i$ such that the 2-norm of the residual $r_{k} = Ax_{k} - b$ is minimised with

$$
    \|Ax_k - b\|_2 \speq \left\|r_0 + \sum_{i=1}^k\beta_i Aq_i\right\|_2.
$$

Writing $Q^{(k)}$ the matrix with columns $\{q_1,\dots,q_k\}$ and $\beta^{(k)}$ the vector in $\R^k$ with components $\{\beta_1,\dots,\beta_k\}$, the above can be expressed in matrix form as

$$
    \beta^{(k)} \speq \arg\min_{\beta\in\R^k} \quad\left\| r_0 + AQ^{(k)}\beta \right\|_2
$$

which is just a least-square regression in $k$ dimensions.
These subsequent regressions can each be solved cheaply as we show below.

Assume we simultaneously orthogonalise the vectors $Aq_i$ to get another orthonormal basis  $\{\tilde{q}_1,\dots,\tilde{q}_k\}$.
Let $\tilde{Q}^{(k)}$ be the matrix with columns $\tilde{q}_i$.
Then, at step $k$, we can write $AQ^{(k)} = \tilde{Q}^{(k)}R^{(k)}$, and the least-square problem becomes

$$
    \gamma^{(k)} \speq \arg\min_{\gamma \in \R^k}\quad \left\| r_0 + \tilde{Q}^{(k)}\gamma \right\|_2 \quad\text{with}\quad \gamma^{(k)} = R^{(k)}\beta^{(k)}.
$$

Since $\tilde{Q}^{(k)}$ has orthogonal columns, the least-square solution to this problem is simply
\eqa{
    \gamma^{(k)} &=& -({\tilde{Q}^{(k)}}^t \tilde{Q}^{(k)})\inv{\tilde{Q}^{(k)}}^t r_0 \\
                 &=& -{\tilde{Q}^{(k)}}^t r_0
}
and finding $\beta^{(k)}$ such that $R^{(k)}\beta^{(k)} = \gamma^{(k)}$ can be done directly and cheaply since $R^{(k)}$ is upper triangular (using the same iteration as in \eqref{qrls2}). Note also that we get the residual $r_k$ directly from $\gamma^{(k)}$ since \nobr{$r_k = r_0 + \tilde{Q}^{(k)}\gamma^{(k)}$}.

Picking this criterion as well as the "Krylov" directions (see below) leads to the vanilla version of the **GMRES** algorithm (_Generalised Minimal Residual Method_).

### Generating directions

Ideally, we would like the space $\mathcal P_k$ spanned by the $\{p_1, \dots, p_k\}$ to be such that the projection of $x$ on $\mathcal P_k$ is close to $x$.
This, unfortunately, is not very easy to translate into a cheap procedure for generating a good sequence of $p_k$ not least because we don't have access to $x$.
After executing step $k-1$, the only new information we can compute is the new residual $r_{k-1}$ and so, naturally, we could try using that in forming the new direction $p_k$.

In this point we will briefly discuss three approaches to generating the $p_k$:

* **random**, where the $p_k$ are drawn at random e.g. with $(p_k)_i \sim \mathcal N(0, 1)$,
* **Krylov**, where the $p_k$ are the residuals $r_{k-1}$,
* **gradient**, where the $p_k$ are $A^tr_{k-1}$.

The first one is not motivated by anything else than "it should work" but should not be expected to work very well, the second one is a common choice, that links with Krylov subspace methods (as [discussed in the second part](\postCG)), and finally, the third one is motivated by the gradient of \nobr{$F(x) = \|Ax - b\|_2^2$} which is $A^t(Ax-b)$ so that

$$
    \nabla F(x_{k-1}) \speq A^tr_{k-1}.
$$

Of course there could be other approaches than these three but they have the advantage of being simple and illustrative.

**Note**: in a number of important cases, $A$ is not built explicitly. Rather we just have a procedure to compute $Ax$ for a given $x$. In such cases it might be impractical to compute $A^tx$ explicitly.

<!-- A final comment can be made by considering that for any matrix $P$ of size $n\times n$, solving $Ax=b$ is equivalent to solving the fixed point $x = x + P(Ax - b)$ with iterations $x_{k+1} = x_k + \alpha_kP_kr_k$ (we could have different matrices at each step).
Turning equations into fixed points is not always a recipe for success but here it allows for another interpretation of the Krylov case ($P=I$) and the gradient case ($P=A^t$). -->

### Connection to fixed-point methods

In a different context, we had discussed [splitting methods](/posts/2018/12/08-split/) where one decomposes the matrix $A$ into a sum: $A=B+C$ for some matrices $B$ and $C$ to transform the problem into a _fixed point_ equation:

$$
    Bx = b - Cx
$$

that can be approached with a damped fixed-point iteration:

$$
    Bx_{k+1} = (1-\theta_k)x_k + \theta_k ( b - Cx_k)
$$

for some $\theta_k \in (0, 1]$.
Picking $B= I$ and $C=(A- I)$, the iteration is

\eqa{
     x_{k+1} &=& (1-\theta_k)x_k + \theta_k(b + x_k - Ax_k)\\
            &=& x_k - \theta_k r_k
}

with $r_k = Ax_k-b$.
In that sense, the "Krylov" choice earlier can be connected to a fixed-point iteration with a specific decomposition of $A$.

## Implementation

We've now discussed the different moving parts and can build a simple implementation which, at step $k$, does the following:

1. gets a new direction $p_k$ and finds the corresponding orthonormal $q_k$,
2. computes $Aq_k$ and finds the corresponding orthonormal $\tilde{q}_k$ as well as the $r_{i,k}$,
3. computes $\gamma_k = - (\tilde{Q}^{(k)})^t r_0$,
4. solves $R^{(k)}\beta^{(k)}=\gamma_k$ (a triangular system of size $k$).

For step (1) and (2) we can use the modified Gram-Schmidt procedure.

In the points below, we show code that solves each of these steps and ultimately put them all together to form a working iterative solver.
The code is not optimised but should hopefully be easy to read and to analyze.

### Modified-GS step

This code computes the $k$-th column of $Q$ and $R$ in place by orthogonalising a given vector $v$ against the first $(k-1)$ columns of $Q$.

```!
using LinearAlgebra, StableRNGs

function mgs!(Q::AbstractMatrix, R::AbstractMatrix, v::Vector, k::Int)
    n = length(v)
    Q[:, k] .= v
    for i = 1:k-1
        R[i, k] = dot(Q[:, k], Q[:, i])
        Q[:, k] .-= R[i, k] .* Q[:, i]
    end
    Q[:, k] = normalize(Q[:,k])
    R[k, k] = dot(v, Q[:, k])
    return
end

# simple check
begin
    rng = StableRNG(1234)
    n = 5
    A = randn(rng, n, n)
    Q = zeros(n, n)
    R = zeros(n, n)
    for k = 1:n
        mgs!(Q, R, A[:, k], k)
    end
    e1 = round(maximum(abs.(Q'*Q - I)), sigdigits=2)
    e2 = round(maximum(abs.(A - Q*R)), sigdigits=2)
    println("max entry in |Q'Q-I|: $e1")
    println("max entry in |A-QR|: $e2")
end
```

The computational complexity (ignoring constants) of this function is:

* computation of $r_{ik}$: $(k-1)$ dot products i.e. $\mathcal O(kn)$,
* computation of the entries of $q_k$: $\mathcal O(kn)$,
* normalisation of $q_k$ and computation of $r_{kk}$: $\mathcal O(n)$

so $\mathcal O(kn)$ overall.

### Upper triangular solve

The code below is just a simple function implementing \eqref{qrls2}:

```!
function trisolve(R::AbstractMatrix, v::Vector)
    k = size(R, 1)
    β = zero(v)
    for j = k:-1:1
        β[j] = v[j]
        for i = 1:k-j
            β[j] -= R[j, j+i] * β[j+i]
        end
        β[j] /= R[j, j]
    end
    return β
end

# simple check
begin
    rng = StableRNG(414)
    m = 5
    R = randn(rng, m, m)
    for i=1:m, j=1:i-1
        R[i, j] = 0
    end
    β = randn(rng, m)
    v = R * β
    β̂ = trisolve(R, v)
    e = round(norm(β-β̂), sigdigits=2)
    println("‖β-β̂‖: $e")
end
```

The computational complexity (ignoring constants) of this function is:

* for each index $j$ compute $(k-j)$ products and subtractions and one division.

so overall $\mathcal O(k^2)$ complexity where $k$ is the size of $v$.

### Core method

We now put all the blocks together to form the `itersolve` function.
In the function you'll see that we keep track of elapsed time, and the norm of the residuals, this is to facilitate analysis and comparison later on.

```!
function itersolve(A::Matrix, b::Vector, x0::Vector;
                   niter::Int=10, dirs=:rand)
    start = time()
    n = size(A, 1)
    r0 = A * x0 - b

    # objects we'll use to store the results
    xk = copy(x0)
    rk = copy(r0)
    pk = zeros(n)
    Q = zeros(n, niter)
    Q̃ = zeros(n, niter)
    R = zeros(niter, niter)
    norm_rk = zeros(niter + 1)
    norm_rk[1] = norm(r0)
    times = zeros(niter+1)
    times[1] = time() - start

    @views for k = 1:niter
        # <O> Obtain a new direction pk
        if dirs == :rand
            pk = randn(n)
        elseif dirs == :krylov
            pk = rk
        elseif dirs == :grad
            pk = A' * rk
        end

        # <A> Orthog. of pk using MGS. We don't care about R[:, k] here,
        # it will be overwritten at the next step anyway
        mgs!(Q, R, pk, k)

        # <B> Orthog. of A*qk using MGS, we do care about R[:, k] here
        mgs!(Q̃, R, A*Q[:, k], k)

        # <C> Solving the least-square problem
        γk = -Q̃[:, 1:k]' * r0

        # <D> Solving the triangular problem
        βk = trisolve(R[1:k, 1:k], γk)

        # <E> Approximation + residuals
        xk .= x0 .+ Q[:, 1:k] * βk
        rk .= r0 .+ Q̃[:, 1:k] * γk

        norm_rk[k+1] = norm(rk)
        times[k+1] = time() - start
    end
    return xk, norm_rk, times
end

# quick check (n steps must lead to the correct solution)
begin
    rng = StableRNG(908)
    n = 5
    A = randn(rng, n, n)
    x = randn(rng, n)
    b = A * x

    x0 = randn(rng, n)
    _, nrk_random, _ = itersolve(A, b, x0; niter=n, dirs=:rand)
    norm_rn = round(nrk_random[end], sigdigits=2)
    println("‖Axn - b‖: $norm_rn (random)")

    _, nrk_krylov, _ = itersolve(A, b, x0; niter=n, dirs=:krylov)
    norm_rn = round(nrk_krylov[end], sigdigits=2)
    println("‖Axn - b‖: $norm_rn (krylov)")

    _, nrk_grad, _ = itersolve(A, b, x0; niter=n, dirs=:grad)
    norm_rn = round(nrk_grad[end], sigdigits=2)
    println("‖Axn - b‖: $norm_rn (grad)")
end
```

The computational complexity (ignoring constants) at iteration $k$ of this function is:

* (O) for `grad`: one matrix-vector product with $A^t$ i.e. $\mathcal O(n^2)$,
* (A, B) two MGS steps i.e. $\mathcal O(kn)$
* (B) one matrix-vector product with $A$ i.e. $\mathcal O(n^2)$
* (C) one matrix-vector product with $\tilde{Q}^{(k)}$ i.e. $\mathcal O(kn)$
* (D) one upper-triangular solve of a $k\times k$ system i.e. $\mathcal O(k^2)$
* (E) one application of $Q^{(k)}$ and one of $\tilde{Q}^{(k)}$ i.e. $\mathcal O(nk)$

The step with dominant complexity is the matrix-vector multiplication (computation of $Aq_k$) (and computation of $A^tr_k$ in the `grad` case).
Applying a $n\times n$ matrix has complexity $\mathcal O(n^2)$ making the overall procedure $\mathcal O(Kn^2)$ with $K$ the number of steps.

@@alert,alert-secondary **Note**: in many cases, there is a specific procedure available to compute (exactly or approximately) $Ax$ for some $x$ with complexity better than $\mathcal O(n^2)$. This can for instance be the case when $A$ is very sparse, or in some physics problem where the the Fast Multipole Method (FMM) can be used (see e.g. \citet{bg97}). @@

### Comparison

In the code below, we consider a random $n\times n$ linear system that is poorly conditioned and check the norm of the residuals $\|r_k\|$ as $k$ increases for the different direction choices.
We also use the `gmres!` function from the excellent [IterativeSolvers.jl](https://github.com/JuliaLinearAlgebra/IterativeSolvers.jl) package as a rough sanity check that our code is correct.

@@alert,alert-secondary **Note**: this is just meant to be a quick benchmark which highlights some interesting points for discussion, it's not meant to be an in-depth comparison.\\
Note also that we use random matrices with no or very little structure, so iterative methods need a number of iteration comparable to the dimension to get satisfactory results, for more useful $A$ the convergence is typically much faster.
@@

```!
using IterativeSolvers, PyPlot

rng = StableRNG(908)

n = 50
A = randn(rng, n, n)^4 .+ rand(rng, n, n)
x = randn(rng, n)
b = A * x
x0 = randn(rng, n)
r0 = A * x0 - b

κ = round(cond(A), sigdigits=2)
println("cond(A): $κ")

cases = Dict()
for dirs in (:rand, :grad, :krylov)
    cases[dirs] = itersolve(A, b, x0; niter=n, dirs=dirs)
end

# Using the IterativeSolvers
x_gmres, log_gmres = gmres!(copy(x0), A, b; maxiter=n, restart=n+1, log=true)

figure(figsize=(8, 6))
for dirs in (:rand, :grad, :krylov)
    plot(cases[dirs][2], label=dirs)
end
plot([norm(r0), log_gmres.data[:resnorm]...], label="gmres", ls="none", marker="x")

xlabel("Number of iterations")
ylabel("Norm of the residuals")

legend()

savefig(joinpath(@OUTPUT, "comp_1.svg")) # hide
```

@@reduce-vspace \fig{comp_1.svg}@@

On this first plot we can see a number of interesting things:

1. the "krylov" directions (where $p_k = r_k$) leads to identical iterations as those from `gmres!` which gives some confidence in the implementation of the `itersolve` function in terms of correctness,
2. the "random" directions have a generally worse performance as could be expected since there's no information in the direction $p_k$,
3. the "grad" directions (where $p_k = A^tr_k$) lead to much faster convergence than the other two,
4. all choices eventually lead to $\|r_n\|\approx 0$ as expected.

@@alert,alert-info **Note**: when writing this post and running experiments, I was a bit surprised by how much better the "grad" version behaves compared to the others here, especially since I had not seen that choice discussed in the literature.
It may well be an artefact of the benchmark though (see e.g. [next post](/posts/2021/05-cg/)), or a well known fact. Either way if you have thoughts on this, I'll be glad to [hear from you](https://github.com/tlienart/tlienart.github.io/issues/new/choose). @@

We can repeat a similar experiment with a larger matrix and more iterations and look at the time taken since the start instead of the number of iterations. Before doing so note that:

1. if you try to reproduce these experiments, you should run them a couple of times to make sure the pre-compilation of the function `itersolve` is factored away,
1. if you compare the timings with `gmres!` you'll see that `itersolve` is significantly slower, this is essentially because its implementation is geared for readability rather than speed,
1. the main aim of the experiment below is to show that the "grad" choice is still much better here even though each step is twice as expensive as the other two.

```!
rng = StableRNG(9080)

n = 250
# a random matrix with some sparsity
A = 10 * randn(rng, n, n) .* rand(rng, n, n) .* (rand(rng, n, n) .> 0.3)
nz = sum(A .== 0)
sp = round(nz / (n * n) * 100)
println("Sparsity ≈ $sp%")

x = randn(rng, n)
b = A * x
x0 = randn(rng, n)

cases = Dict()
for dirs in (:rand, :grad, :krylov)
    cases[dirs] = itersolve(A, b, x0; niter=n, dirs=dirs)
end

figure(figsize=(8, 6))
for dirs in (:rand, :grad, :krylov)
    semilogy(cases[dirs][3], cases[dirs][2], label=dirs)
end

xlabel("Time elapsed [s]")
ylabel("Norm of the residuals")
legend()

savefig(joinpath(@OUTPUT, "comp_2.svg")) # hide
```

@@reduce-vspace \fig{comp_2.svg} @@

Again, this should not be considered to be a thorough benchmark but one can see that even taking into account the extra time needed per step in the grad case, the convergence is significantly faster in the low iteration count for the "grad" choice.

As a final note, we look at the time taken per method when the matrix size increases and with a fixed number of iteration:

```!
rng = StableRNG(90801)

K = 50
times = Dict(:rand=>[], :grad=>[], :krylov=>[], :gmres=>[])
N = collect(200:100:3_000)
for n in N
    A = randn(rng, n, n)
    x = randn(rng, n)
    b = A*x
    x0 = randn(rng, n)

    for dirs in (:rand, :grad, :krylov)
        start = time()
        itersolve(A, b, x0; niter=K, dirs=dirs)
        push!(times[dirs], time()-start)
    end
    start = time()
    gmres!(copy(x0), A, b, maxiter=K, restart=K+1)
    push!(times[:gmres], time()-start)
end

figure(figsize=(8, 6))
for dirs in (:rand, :grad, :krylov)
    plot(N, times[dirs], label=dirs)
end
plot(N, times[:gmres], label="gmres")
legend()

xlabel("Matrix size")
ylabel("Time taken [s]")

savefig(joinpath(@OUTPUT, "comp_3.svg")) # hide
```

@@reduce-vspace \fig{comp_3.svg}@@

As could be expected, the `gmres!` function is significantly faster (our code is really not optimised) but all methods exhibit the same behaviour, scaling like $n^2$ as expected.
Note that only the trend should be looked at, the peaks and trophs should be ignored and are mostly due to how un-optimised our implementation is and how well Julia manages to optimise the steps at various sizes.


## Short references

1. \biblabel{vd05}{Van Dooren (2005)} **Van Dooren**, [Krylov methods: an introduction](https://perso.uclouvain.be/paul.vandooren/Krylov.pdf), 2005. -- A set of slides on Krylov methods and GMRES.
1. \biblabel{t19}{Townsend (2019)} **Townsend**, [Krylov subspace methods](http://pi.math.cornell.edu/~web6140/TopTenAlgorithms/KrylovSubspace.html), 2019. -- A tutorial on Krylov subspace methods using Julia.
1. \biblabel{bg97}{Beatson and Greengard (1997)} **Beatson**, **Greengard**, [A short course on fast multipole methods](https://math.nyu.edu/~greengar/shortcourse_fmm.pdf), 1997.
1. \biblabel{saad03}{Saad (2003)} **Saad**, [Iterative Methods for Sparse Linear Systems](https://www-users.cs.umn.edu/~saad/IterMethBook_2ndEd.pdf), 2003. -- A reference book on iterative methods by one of the author of GMRES.
1. \biblabel{vv03}{van der Vorst (2003)} **van der Vorst**, [Iterative Krylov Methods for Large Linear Systems](http://www.lmn.pub.ro/~daniel/ElectromagneticModelingDoctoral/Books/Numerical%20Methods/VanDerVorst2003%20Iterative%20Krylov%20Methods%20for%20Large%20Linear%20Systems.pdf), 2003. -- A reference book on iterative methods for linear systems by the author of the Bi-CGSTAB paper.
