@def title = "tests"
@def hascode = false

In these notes, we consider the standard *constrained minimisation problem* in convex optimisation:

This is a *test* blah! blah! new! $\sin(\pi)+1=?$

$$
	\min_{x\in C}\quad f(x)
$$

where $C$ is a *nice* convex set and $f$ a *nice* convex function.
Usual assumptions of *niceness* (that are typically verified in problems of interest) are:

* $C$ is *closed*, has *non-empty interior* and is a subset of $\mathbb R^n$,
* $f$ is in the set $\Gamma_0(X)$ of convex functions on $X$ that are *proper* and *lower semi-continuous*,
* one can compute a gradient or subgradient of $f$ at a given point.

Roughly speaking, these conditions guarantee that there is a solution to the problem and that we can find one applying some simple iterative algorithm.
We shall try to make these assumptions clearer as we get to use them throughout the notes (and, it is therefore not required to look them up on Wikipedia quite just yet).

We will also consider the unconstrained form of the problem, i.e.: when $C=\mathbb R^n$ (and will then just write $\min_x f(x)$).
Constrained problems can always be interpreted as unconstrained problems: indeed, if we define the *indicator* of a convex set $C$ as

$$
	i_C(x) = \begin{cases} 0 & (x\in C) \\\\ +\infty & (x\notin C) \end{cases}
$$

then the constrained problem can be written as

$$
	\min_x f(x)+i_C(x).
$$

This is not entirely pointless as will become apparent when deriving the projected gradient descent.

In these notes, we consider the standard *constrained minimisation problem* in convex optimisation:

$$
	\min_{x\in C}\quad f(x)
$$

where $C$ is a *nice* convex set and $f$ a *nice* convex function.
Usual assumptions of *niceness* (that are typically verified in problems of interest) are:

* $C$ is *closed*, has *non-empty interior* and is a subset of $\mathbb R^n$,
* $f$ is in the set $\Gamma_0(X)$ of convex functions on $X$ that are *proper* and *lower semi-continuous*,
* one can compute a gradient or subgradient of $f$ at a given point.

Roughly speaking, these conditions guarantee that there is a solution to the problem and that we can find one applying some simple iterative algorithm.
We shall try to make these assumptions clearer as we get to use them throughout the notes (and, it is therefore not required to look them up on Wikipedia quite just yet).

We will also consider the unconstrained form of the problem, i.e.: when $C=\mathbb R^n$ (and will then just write $\min_x f(x)$).
Constrained problems can always be interpreted as unconstrained problems: indeed, if we define the *indicator* of a convex set $C$ as

$$
	i_C(x) = \begin{cases} 0 & (x\in C) \\\\ +\infty & (x\notin C) \end{cases}
$$

then the constrained problem can be written as

$$
	\min_x f(x)+i_C(x).
$$

This is not entirely pointless as will become apparent when deriving the projected gradient descent.

"But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness. No one rejects, dislikes, or avoids pleasure itself, because it is pleasure, but because those who do not know how to pursue pleasure rationally encounter consequences that are extremely painful. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. To take a trivial example, which of us ever undertakes laborious physical exercise, except to obtain some advantage from it? But who has any right to find fault with a man who chooses to enjoy a pleasure that has no annoying consequences, or one who avoids a pain that produces no resultant pleasure?"

"At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus. Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae. Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores alias consequatur aut perferendis doloribus asperiores repellat."

"On the other hand, we denounce with righteous indignation and dislike men who are so beguiled and demoralized by the charms of pleasure of the moment, so blinded by desire, that they cannot foresee the pain and trouble that are bound to ensue; and equal blame belongs to those who fail in their duty through weakness of will, which is the same as saying through shrinking from toil and pain. These cases are perfectly simple and easy to distinguish. In a free hour, when our power of choice is untrammelled and when nothing prevents our being able to do what we like best, every pleasure is to be welcomed and every pain avoided. But in certain circumstances and owing to the claims of duty or the obligations of business it will frequently occur that pleasures have to be repudiated and annoyances accepted. The wise man therefore always holds in these matters to this principle of selection: he rejects pleasures to secure other greater pleasures, or else he endures pains to avoid worse pains."
