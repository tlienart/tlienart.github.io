@def isdemo = true
@def hascode = true
@def title = "Example"

\newcommand{\R}{\mathbb R}
\newcommand{\E}{\mathbb E}
\newcommand{\scal}[1]{\langle #1 \rangle}

# JuDoc Example

You can define commands in a same way as in LaTeX, and use them in the same
way: $\E[\scal{f, g}] \in \R$.
Math is displayed with [KaTeX](https://katex.org) which is much faster than MathJax.

$$ \hat f(\xi) = \int_\R \exp(-2i\pi \xi t) \,\mathrm{d}t. \label{fourier} $$

The syntax is basically an extended form of GitHub Flavored Markdown ([GFM](https://guides.github.com/features/mastering-markdown/))
allowing for some **LaTeX** as well as **div blocks**:

@@colbox-yellow
Something inside a div with div name "colbox-yellow"
@@

You can add figures, tables, links and code just as you would in GFM.
For syntax highlighting, [highlight.js](https://highlightjs.org) is used by default:

```julia
struct Point{T <: Real}
    x::T
    y::T
end
length(p::Point) = sqrt(p.x^2 + p.y^2)
```

## Why?

Extending Markdown allows to define LaTeX-style commands for things that may
appear many times in the current page (or in all your pages), for example let's
say you want to define an environment for systematically inserting images from
a specific folder within a specific div.
You could do this with:

\newcommand{\smimg}[1]{@@img-small ![](/assets/misc/smimg/!#1) @@}

\smimg{marine-iguanas-wikicommons.jpg}

It also allows things like referencing (which is not natively supported by
KaTeX for instance):

$$ \exp(i\pi) + 1 = 0 \label{a nice equation} $$

can then be referenced as such: \eqref{a nice equation} unrelated to \eqref{fourier} which is convenient for
maths notes.
