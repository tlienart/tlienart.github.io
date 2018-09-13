@def title = "Convex analysis II"

# Convex analysis (part 2)

## The convex conjugate <!-- ✅ 12/9/2018 -->

Let us start with the definition of the subdifferential of a convex function $f$ defined on $C$ at a point $x\in C^\circ$:

\eqa{
    \partial f(x) &=& \{y\in \R^n\,|\, f(z)\,\ge\, f(x)+\langle z-x,y\rangle, \,\forall z\in C\}.
}

We can rearrange terms in the condition as follows:

\eqa{
    \partial f(x) &=& \{y\in\R^n\,|\, \langle z,y\rangle - f(z)\,\le\, \langle x,y\rangle - f(x), \,\forall z\in C\}.
}

However, since the condition must hold for all $z$, it must equivalently hold for any $z$ that maximises the lower bound.
Note that the maximum of that lower bound tightens the inequality exactly (just take $z=x$).
We can thus write the subdifferential as

$$
    \partial f(x) \spe{=} \{y\in \R^n \,|\, \max_{z\in C} \,\, [\langle z,y\rangle -f(z)] \,=\, \langle x,y\rangle -f(x)\}.\label{def subdiff 1}
$$

We can now introduce the *convex conjugate* of a function (also sometimes known as the *Fenchel-Legendre convex conjugate* or a combination of those words).
We write $\eR$ the extended real line: $\eR = \R \cup \{\pm\infty\}$.


@@colbox-yellow
Let $f: C\to \eR$ denote any function. The *convex conjugate* of $f$ is the function $f^\star(y):\R^n\to \eR$ defined as follows:

$$
    f^\star(y) \spe{:=} \sup_{z\in C} \,\,[\langle z,y \rangle - f(z)].
$$
@@

**Note**: it's easy to show that the convex conjugate of a function $f$ is convex even if the function $f$ is not convex.

We can now use the convex conjugate in \eqref{def subdiff 1}:
\eqa{
    \partial f(x) &=& \{ y\in\R^n \,|\, f^{\star}(y) \,=\, \langle x,y\rangle - f(x)\}, \label{def subdiff 2}
}
which is a convenient characterisation we'll use soon to link $(\partial f)^{-1}$ and $(\partial f^\star)$.

### Example

We can consider a simple (and yet quite useful) example for the convex conjugate: if we define $\psi(x):=\|x\|^2/2$, its convex conjugate is then

$$
    \psi^\star(y) \speq \sup_{z\in C}\,\, \langle z,y\rangle - \frac12\langle z,z\rangle.
$$

The problem in the right hand side is easy to solve: the objective function is differentiable and the FOC gives $y-z^\sharp = 0$ so that $\psi^\star(y)= \psi(y)$.

Another nice example is $f(x)=x\log(x)$, it's an easy exercise to show that $f^\star(y)=\exp(y-1)$ and $f^{\star\star}(x) = f(x)$.

### Fenchel-Moreau theorem and Fenchel's inequality <!-- ✅ 12/9/2018 -->

@@colbox-yellow
An important property of the convex conjugate is that for $f\in \Gamma_0(C)$, $f^{\star\star}\equiv f$ on $C$ which is known as the *Fenchel-Moreau* theorem.
@@
It's easy to show that $f\ge f^{\star\star}$ on $C$ but it requires a few extra results to show the converse (see references).

The definition of the convex conjugate also directly implies *Fenchel's inequality*.

@@colbox-yellow
Let $f:C\to \eR$ and $f^\star$ its convex conjugate, then:
\eqa{
    f(x) + f^\star(y) &\ge & \langle x,y\rangle, \quad \forall x\in C,y\in \R^n.
}
@@

## Subdifferential of the convex conjugate <!-- ✅ 13/9/2018 -->

Consider the definition of the subdifferential \eqref{def subdiff 2}, for any $x\in C$ with $y\in \partial(x)$ we have
\eqa{
    (x\in C, y\in\partial f(x)) &\Longleftrightarrow& f^\star(y)=\scal{x, y}-f(x).
}
With exactly the same definition, we have that for $x\in\partial f^\star(y)$
\eqa{
    (x\in\partial f^\star(y)) &\Longleftrightarrow& f^{\star\star}(x)=\scal{x, y}-f^\star(y),\label{general dfstar dfinv}
}
and the last equality can be rearranged to $f^\star(y)=\scal{x,y}-f^{\star\star}(x)$.
In the case where $f\in\Gamma_0(C)$ then $f\equiv f^{\star\star}$ on $C$ by the Fenchel-Moreau theorem which gives the result that follows.

@@colbox-yellow
Let $f\in\Gamma_0(C)$ then the following equivalence holds
\eqa{
    (x\in C, y \in \partial f(x)) &\Longleftrightarrow& x \in \partial f^\star(y) \cap C.
}
Such a pair of point is called a *dual pair* and verifies $f(x)+f^\star(y)=\scal{x,y}$.
@@

Using the inverse of the subdifferential operator, we have that $x\in(\partial f)^{-1}(y)\cap C$ is equivalent to $x\in\partial f^\star(y)\cap C$ which shows a close link between $(\partial f)^{-1}$ and $\partial f^\star$.
This link becomes even more apparent in the unconstrained case.

@@colbox-yellow
Let $f\in\Gamma_0(\R^n)$, then
\eqa{
    (\partial f)^{-1} &\equiv & \partial f^\star.
}
@@

**Note**: recall that, with the first order condition, a minimiser $x^\sharp$ is such that $0\in \partial f(x^\sharp)$ or $(\partial f)^{-1}(0) \ni x^\sharp$.
We can now also write this $x^\sharp \in \partial f^\star(0)$, thereby expressing the minimiser in terms of the convex-conjugate.
Of course it's not clear at this point whether this helps at all to find the minimiser but, as it turns out, it will.

### Example

Let's consider $f(x)=x\log(x)$ on $C = [0, 1]$.
We know that $f^\star(y)=\exp(y-1)$. Both $f$ and $f^\star$ are differentiable so $\partial f(x)=\{\nabla f(x)\}$ with $\nabla f(x)=\log x +1$ on $\R^+$ and $\partial f^\star(y)=\{\nabla f^\star(y)\}$ with $\nabla f^\star(y)=\exp(y-1)$ on $\R$.

Gathering the pieces, if we take $x\in C$ and $y=\nabla f(x)$, we have
\eqa{
    y \,=\,\log x+1 &\Longrightarrow& x \,=\,\exp(y-1) \,=\,\nabla f^\star(y)
}
and conversely if we consider a $y$ such that $\exp(y-1)\in C$ then
\eqa{
    x \,=\,\exp(y-1) &\Longrightarrow& y \,=\,\log x + 1 \,=\,\nabla f(x)
}
So that the equivalence \eqref{general dfstar dfinv} holds as expected.


## Short references

1. **Hiriart-Urruty**, [A note on the Legendre-Fenchel transform of convex composite functions](https://www.math.univ-toulouse.fr/~jbhu/A_note_on_the_LF_transform.pdf): this is a more technical note that you may find interesting if you would like more details on convex conjugacy.
1. **Mete Soner**, [Convex analysis and Fenchel-Moreau theorem](https://www2.math.ethz.ch/education/bachelor/lectures/hs2015/math/mf/lecture7notes): lecture notes covering convex conjugacy in more depth and proving rigorously the Fenchel-Moreau theorem.

*See also the general references mentioned in the [introduction](/pub/csml/cvxopt/intro.html).*
