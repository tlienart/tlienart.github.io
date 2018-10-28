@def isdemo = true
@def hascode = true
@def title = "Example"

\newcommand{\R}{\mathbb R}                <!-- just like in LaTeX -->
\newcommand{\E}{\mathbb E}
\newcommand{\scal}[1]{\left\langle #1 \right\rangle}

# JuDoc Example

You can define commands in a same way as in LaTeX, and use them in the same
way: $\E[\scal{f, g}] \in \R$.
Math is displayed with [KaTeX](https://katex.org) which is faster than MathJax and generally renders better.
Note below the use of `\label` for hyper-referencing, this is not natively supported by KaTeX but is handled by JuDoc.

$$ \hat f(\xi) = \int_\R \exp(-2i\pi \xi t) \,\mathrm{d}t. \label{fourier} $$

The syntax is basically an extended form of GitHub Flavored Markdown
([GFM](https://guides.github.com/features/mastering-markdown/))
allowing for some **LaTeX** as well as **div blocks**:

@@colbox-yellow
Something inside a div with div name "colbox-yellow"
@@

You can add figures, tables, links and code just as you would in GFM.
For syntax highlighting, [highlight.js](https://highlightjs.org) is used by default.

## Why?

Extending Markdown allows to define LaTeX-style commands for things that may
appear many times in the current page (or in all your pages), for example let's say you want to define an environment for systematically inserting images from a specific folder within a specific div.
You could do this with:

\newcommand{\smimg}[1]{@@img-small ![](/assets/misc/smimg/!#1) @@}

\smimg{marine-iguanas-wikicommons.jpg}

It also allows things like hyper-referencing as alluded to before:

$$ \exp(i\pi) + 1 = 0 \label{a nice equation} $$

can then be referenced as such: \eqref{a nice equation} unrelated to
\eqref{fourier} which is convenient for maths notes.
