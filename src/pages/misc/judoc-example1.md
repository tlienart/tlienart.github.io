@def title = "Example"
@def isdemo = true

\newcommand{\R}{\mathbb R}
\newcommand{\E}{\mathbb E}
\newcommand{\scal}[1]{\langle #1 \rangle}

You can define commands in a same way as LaTeX.
And use them in the same way: $\E[\scal{f, g}] \in \R$.
Maths display is done with [KaTeX](https://katex.org).

The syntax is basically an extended form of [gfm](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet) allowing for some LaTeX as well as div blocks:

@@box
Something inside a div with div name "box"
@@

You can add figures, tables, links and code just as you would in gfm.

Extending Markdown allows to define macros for things that may appear many times in the current page (or in all your pages), for example let's say you want to define an environment for systematically inserting images from a specific folder within a specific div.

\newcommand{\smimg}[1]{@@smimg ![](/assets/smimg/!#1) @@}

\smimg{myimg.png}

It also allows things like referencing (which is not natively supported by KaTeX for instance):

$$ \exp(i\pi) + 1 = 0 \label{a nice equation} $$

can then be referenced as such: \eqref{a nice equation} which is convenient for maths notes.
