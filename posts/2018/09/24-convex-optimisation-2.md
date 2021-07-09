+++
title = "Convex analysis &ndash; pt. II"
descr = """
    The convex conjugate, Fenchel's inequality, and the Fenchel-Moreau theorem.
    """
tags = ["optimisation"]
+++

{{redirect /pub/csml/cvxopt/ca2.html}}

<!--
NOTE:
last major review: 19/9/2018 ✅

-->

# Convex analysis (part II)

{{page_tags}}

\toc

## The convex conjugate <!-- ✅ 12/9/2018 -->

Let us start with the definition of the subdifferential of a convex function $f$ at a point $x\in C \subseteq \R^n$:

\eqa{
    \partial f(x) &=& \{y\in \R^n\,|\, f(z)\,\ge\, f(x)+\langle z-x,y\rangle, \,\forall z\in C\},
}
We can rearrange terms in the condition as follows:
\eqa{
    \partial f(x) &=& \{y\in\R^n\,|\, \langle z,y\rangle - f(z)\,\le\, \langle x,y\rangle - f(x), \,\forall z\in C\}.
}
However, since the condition must hold for all $z$, it must equivalently hold for any $z$ that maximises the lower bound.
Note that the maximum of that lower bound tightens the inequality exactly (take $z=x$).
We can thus write the subdifferential as

$$
    \partial f(x) \spe{=} \{y\in \R^n \,|\, \max_{z\in C} \,\, [\langle z,y\rangle -f(z)] \,=\, \langle x,y\rangle -f(x)\}.\label{def subdiff 1}
$$

We can now introduce the *convex conjugate* of a function (also sometimes known as the *Fenchel-Legendre convex conjugate* or a combination of those words).\\
In the sequel, we write $\eR$ the extended real line: $\eR = \R \cup \{\pm\infty\}$.


@@colbox-blue
Let $f: C\to \eR$, a function, the *convex conjugate* of $f$ is the function $f^\star(y):\R^n\to \eR$ with:

$$
    f^\star(y) \spe{:=} \sup_{z\in C} \,\,[\langle z,y \rangle - f(z)].
$$
@@

**Note**: it's easy to show that the convex conjugate of a function $f$ is always convex (even if the function $f$ is not convex).

We can now use the convex conjugate in \eqref{def subdiff 1}:
\eqa{
    \partial f(x) &=& \{ y\in\R^n \,|\, f^{\star}(y) \,=\, \langle x,y\rangle - f(x)\}, \label{def subdiff 2}
}
which is a convenient characterisation that will often be used.

**Example**: we can consider a simple (and yet quite useful) example for the convex conjugate: if we define $\psi(x):=\|x\|^2/2$, its convex conjugate is then

$$
    \psi^\star(y) \speq \sup_{z}\,\, \langle z,y\rangle - \frac12\langle z,z\rangle.
$$

The problem in the right hand side is easy to solve: the objective function is differentiable and the FOC gives $y-z^\sharp = 0$ so that $\psi^\star(y)= \psi(y)$.

Another nice example is $f(x)=x\log(x)$, it's an easy exercise to show that $f^\star(y)=\exp(y-1)$ and $f^{\star\star}(x) = f(x)$.

###  Fenchel's inequality and the Fenchel-Moreau theorem <!-- 🚫 17/9/2018 -->

@@colbox-blue
(**FMT**) Let $f:C\to \eR$ and $f^\star$ its convex conjugate, then:
\eqa{
    f(x) + f^\star(y) &\ge & \langle x,y\rangle, \quad \forall x\in C,y\in \R^n.
}
This is known as *Fenchel's inequality*.
@@

This inequality is directly implied by the definition of the convex conjugate.

@@colbox-blue
Let $f\in \Gamma_0(C)$ then $f^{\star\star}\equiv f$ on $C$. This is known as the *Fenchel-Moreau theorem* (FMT).
@@

Proving the theorem in full generality requires a bit of care (see references).
It is however relatively straightforward to show that the result holds on $C^\circ$ (the interior of $C$) without requiring extra results.
We will go about it in two parts:

1. show that $f(z)\ge f^{\star\star}(z)$ for all $z\in C$,
2. show that $f(z)\le f^{\star\star}(z)$ for all $z\in C^\circ$.

#### FMT (pt.1)

By definition of the convex conjugate,
$$
    f^{\star\star}(z) \speq \sup_{y\in\R^n} \scal{z,y}-f^\star(y) \label{def fstarstar}
$$
but since $-f^\star(y)=\inf_{x\in C} [f(x)-\scal{x,y}]$, we have that for any $y$ and $z$,
\eqa{
    \scal{z,y} - f^\star(y) &\le& \scal{z-x,y} + f(x), \quad\forall x\in C.
}
In particular, for any $z\in C$, we can take $x=z$ so that $f^{\star\star}(z) \le f(z)$ on $C$.

#### FMT (pt.2)

Starting again from \eqref{def fstarstar}, we can write
\eqa{
    f^{\star\star}(z) &\ge& \scal{z,y} - f^\star(y), \quad \forall y \in\R^n.
}
If we now consider $x\in C^\circ$, we know that $\partial f(x)$ is non-empty and so can pick $y\in \partial f(x)$.
But for such a $y$ using the characterisation of the subdifferential \eqref{def subdiff 2} we can write
\eqa{
    f^\star(y) &=& \scal{x, y} - f(x)
}
so that $f^{\star\star}(z) \ge \scal{z-x, y} + f(x)$.
For $z\in C^\circ$ we can pick $x=z$ and get $f^{\star\star}(z)\ge f(z)$.

## Subdifferential of the convex conjugate <!-- ✅ 19/9/2018 -->

Consider the definition of the subdifferential \eqref{def subdiff 2}, for any $x\in C$ with $y\in \partial(x)$ we have
\eqa{
    (x\in C, y\in\partial f(x)) &\Longleftrightarrow& f^\star(y)=\scal{x, y}-f(x).
}
With exactly the same definition, we have for $x\in\partial f^\star(y)$
\eqa{
    x\in\partial f^\star(y) &\Longleftrightarrow& f^{\star\star}(x)=\scal{x, y}-f^\star(y),
}
and the last equality can be rearranged to $f^\star(y)=\scal{x,y}-f^{\star\star}(x)$.
In the case where $f\in\Gamma_0(C)$ then $f\equiv f^{\star\star}$ on $C$ by the Fenchel-Moreau theorem which gives the following result.

@@colbox-blue
(**dual pair**) Let $f\in\Gamma_0(C)$ then the following equivalence holds
\eqa{
    (x\in C, y \in \partial f(x)) &\Longleftrightarrow& x \in \partial f^\star(y) \cap C. \label{equiv 1}
}
Such a pair of points is called a *dual pair* and verifies $f(x)+f^\star(y)=\scal{x,y}$.
@@

Using the inverse of the subdifferential operator on the left hand side of \eqref{equiv 1}, we have that $x\in(\partial f)^{-1}(y)\cap C$ is equivalent to $x\in\partial f^\star(y)\cap C$ which exposes a close link between $(\partial f)^{-1}$ and $\partial f^\star$.
This link becomes even more apparent in the unconstrained case.

@@colbox-blue
Let $f\in\Gamma_0(\R^n)$, then
\eqa{
    (\partial f)^{-1} &\equiv & \partial f^\star.
}
@@

**Note**: recall that, with the first order condition, a minimiser $\xopt$ is such that $0\in \partial f(\xopt)$ or $(\partial f)^{-1}(0) \ni \xopt$.
We can now also write this $\xopt \in \partial f^\star(0)$, thereby expressing the minimiser in terms of the convex-conjugate.
Of course it's not clear at this point whether this helps at all to find the minimiser but, as it turns out, it will.

**Example**: let's consider $f(x)=x\log(x)$ on $C = [0, 1]$.
We know that $f^\star(y)=\exp(y-1)$. Both $f$ and $f^\star$ are differentiable so $\partial f(x)=\{\nabla f(x)\}$ with $\nabla f(x)=\log x +1$ on $C$ and $\partial f^\star(y)=\{\nabla f^\star(y)\}$ with $\nabla f^\star(y)=\exp(y-1)$ on $\R$.

Gathering the pieces, if we take $x\in C$ and $y=\nabla f(x)$, we have
\eqa{
    y \,=\,\log x+1 &\Longrightarrow& x \,=\,\exp(y-1) \,=\,\nabla f^\star(y)
}
and conversely if we consider a $y$ such that $\exp(y-1)\in C$ then
\eqa{
    x \,=\,\exp(y-1) &\Longrightarrow& y \,=\,\log x + 1 \,=\,\nabla f(x)
}
So that the equivalence \eqref{equiv 1} holds as expected.


## Additional references

**Note**: in this page (and also further) we usually consider $C^\circ$ instead of  $C$ to make the presentation simpler since we know that on $C^\circ$, subgradients exist and are bounded.
Of course this is done at the expense of generality and some care is needed to generalise properly but the extra details did not seem particularly relevant at the level of this presentation.
The references listed below show (and prove) the results in their full glory.

1. **Hiriart-Urruty**, [A note on the Legendre-Fenchel transform of convex composite functions](https://www.math.univ-toulouse.fr/~jbhu/A_note_on_the_LF_transform.pdf), 2006. -- This is a more technical note that you may find interesting if you would like more details on convex conjugacy.
1. **Mete Soner**, [Convex analysis and Fenchel-Moreau theorem](https://www2.math.ethz.ch/education/bachelor/lectures/hs2015/math/mf/lecture7notes), 2015. -- Lecture notes covering convex conjugacy in more depth and proving rigorously the Fenchel-Moreau theorem.

*See also the general references mentioned in the [introduction](/posts/2018/09/13-convex-optimisation-intro/).*
