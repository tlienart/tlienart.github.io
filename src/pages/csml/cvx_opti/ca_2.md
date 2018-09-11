@def title = "Basics of Convex Analysis"

# More Convex Analysis

We add here a few more results of Convex Analysis which can be skipped in a first reading.
You will find here:

* convex conjugate of the convex conjugate,
* link between $\partial f$ and $\partial f^{\star}$,
* link between *Lipschitz continuity* and strong convexity,
* link between the Bregman divergence associated with a function and that of its convex conjugate.

## Conjugate of the conjugate

We had claimed that for $f\in\Gamma_{0}(X)$, $f^{\star\star}=f$.
A (slightly hand-wavy) proof for this goes as follows:

\begin{eqnarray}
f^{\star\star}(z) &=& \max_{y} \left[\langle z,y\rangle-f^{\star}(y)\right]\\
	&=& \max_{y}\min_{x} \left[\langle z-x,y\rangle + f(x) \right].
\end{eqnarray}

Provided everything is finite, the max and the min can be swapped and we are then left with

\begin{eqnarray}
f^{\star\star}(z)&=& \min_{x}\left\{ f(x)+\left[ \max_{y} \langle z-x,y\rangle\right]\right\}
\end{eqnarray}

but the inner max is infinite unless $z=x$ which leads to $f^{\star\star}(z)=f(z)$.

## Subdifferential of the convex conjugate

Recall that the subgradient of a convex function can be expressed in terms of its convex conjugate as follows:

\begin{eqnarray}
\partial f(x) &=& \{ y\,|\, f^{\star}(y) \,=\, \langle x,y\rangle - f(x)\}.
\end{eqnarray}

<!-- ~~~ -->

Rearranging terms then yields the following equivalences:

\begin{eqnarray}
f(x)+f^\star(y) \,=\, \langle x,y\rangle &\Longleftrightarrow&y \,\in\, \partial f(x)
&\Longleftrightarrow& x\,\in\, \partial f^\star(y),
\end{eqnarray}

where, for the second equivalence, we used that $f^{\star\star}=f$ when $f\in \Gamma_0(X)$.
<!-- ~~~ -->

If we consider all such couples of points, we can write $\{x,y \,|\, y\in\partial f(x)\} = \{x,y\,|\, x\in \partial f^\star(y)\}$ and
if we then consider the notion of /inverse/ of the subdifferential operator, this can be re-written as

\begin{eqnarray}
\{x,y\,|\, x\in(\partial f)^{-1}(y)\} &=& \{x,y\,|\, x\in \partial f^\star(y)\}.
\end{eqnarray}

<!-- ~~~ -->

We thus have for $f\in\Gamma_0(X)$:

\begin{eqnarray}
(\partial f)^{-1} &\equiv & \partial f^\star.
\end{eqnarray}

<!-- ~~~ -->

## Lipschitz continuity and Strong convexity

Let us first recall the definitions: a function $\phi$ is $\beta$*-Lipschitz-continuous* if $\forall u,v\in \text{dom}\, \phi$ the following inequality holds:

\begin{eqnarray}
\|\phi(u)-\phi(v)\| &\le& \beta \|u-v\|.
\end{eqnarray}

We have voluntarily left vague the definition of the domain of the function as well as that of the norms for a reason that will appear clear as we go on.

A function $\varphi$ is $\mu$*-strongly convex* if $\forall u,v\in \text{dom}\,\varphi$ the following inequality holds:

\begin{eqnarray}
{\mu\over 2}\|u-v\|^{2}_{2} &\le& B_{\varphi}(u,v).
\end{eqnarray}

Observe that this inequality must hold for all $u$ and $v$ so that we can swap $u$ and $v$. Hence, we have that

\begin{eqnarray}
\mu \|u-v\|^{2}_{2} &\le& B_{\varphi}(u,v)+B_{\varphi}(v,u) .
\end{eqnarray}

Now, recall that $B_{\varphi}(u,v):=\varphi(u)-\varphi(v)-\langle u-v, y\rangle$, where $y\in\partial\varphi(u)$ so that if we let $z\in\partial\varphi(v)$, then the previous inequality reads:

\begin{eqnarray}
\mu\| u-v\|^{2}_{2} &\le & \langle u-v, y-z \rangle \,\,\le\,\, \|u-v\|_2 \|y-z\|_2,
\end{eqnarray}

where for the last inequality, we used Cauchy-Schwartz's inequality. Rearranging terms then yields

\begin{eqnarray}
\|u-v\|_{2} &\le& {1\over \mu}\| y-z\|.
\end{eqnarray}

Observing that $u\in(\partial \varphi)^{-1}(y)$ and $v\in(\partial \varphi)^{-1}(z)$ (by definition of $y$ and $z$) leads to the following result.

<!-- ~~~ -->

Let $\varphi$ be a $\mu$-strongly convex function on $X$.
Then, the inverse subdifferential map $(\partial\varphi)^{-1}$ is $1/\mu$-Lipschitz continuous, i.e.:

\begin{eqnarray}
\| (\partial \varphi)^{-1}(y)-(\partial \varphi)^{-1}(z)  \| &\le& {1\over \mu}\|y-z\|,\quad \forall y,z\in \text{dom}\,(\partial \varphi)^{-1}.
\end{eqnarray}

Also, if $\varphi\in\Gamma_{0}(X)$ then by the set of equivalences, $(\partial \varphi)^{-1}\equiv \partial \varphi^{\star}$ so that the map $(\partial\varphi^{\star})$ is also $1/\mu$-Lipschitz continuous.
<!-- ~~~ -->

*Remarks*:

* for $\varphi \in \Gamma_{0}(X)$ and $\mu$-strongly convex, one can also show that the inverse subdifferential map $(\partial \varphi)^{-1}$ is *everywhere single-valued* so that the notion of *gradient of the convex conjugate* makes sense and we can write $\nabla \varphi^{\star}$.
* we had initially left vague the definition of the domain of the function as well as that of the norms, this is because we consider this inverse subdifferential map and hence change the space we consider along the way. It is easy to show that there is no real loss of precision incurred by this vagueness though.


## Bregman divergence and convex conjugacy

Take $\psi\in\Gamma_{0}(X)$, strictly convex and continuously differentiable, the Bregman divergence associated to it is

\begin{eqnarray}
B_{\psi}(x,y) &:=& \psi(x)-\psi(y)-\langle x-y,\nabla \psi(y)\rangle.
\end{eqnarray}

Recall that the convex conjugate is given by $\psi^{\star}(y):=\max_{x}[\langle x,y \rangle - \psi(x) ]$ which we can write

\begin{eqnarray}
\psi^{\star}(y) &=& \langle x^{+},y\rangle - \psi (x^{+})
\end{eqnarray}

with $\nabla \psi(x^{+})=y$ by the FOC. We can thus write

\begin{eqnarray}
\psi^{\star}(\nabla \psi(x)) &=& \langle x,\nabla\psi (x)\rangle - \psi(x).
\end{eqnarray}

We can then consider the Bregman divergence associated to $\psi^{\star}$ and obtain

\begin{eqnarray}
B_{\psi^{\star}}(\nabla\psi(x),\nabla\psi(y)) &=& \psi(y)-\psi(x)-\langle x-y,\nabla\psi(x)\rangle \,\,=\,\, B_{\psi}(y,x).
\end{eqnarray}


<!-- ~~~ -->

We have thus shown that

\begin{eqnarray}
B_{\psi^{\star}}(\nabla\psi(x),\nabla\psi(y)) &=& B_{\psi}(y,x)
\end{eqnarray}

and, equivalently, $B_{\psi}(\nabla \psi^{\star}(\mu),\nabla\psi^{\star}(\nu))=B_{\psi^{\star}}(\nu,\mu)$.
<!-- ~~~ -->
