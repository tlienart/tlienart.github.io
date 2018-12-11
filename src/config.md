<!-- Add here the global variables -->
@def author = "T. Lienart"

<!-- any non default judoc var must be pre-defined here with the right type -->
@def isdemo = false

<!-- Add here your commands that you'd like to use throughout  -->
\newcommand{\eqa}[1]{\begin{eqnarray}#1\end{eqnarray}}
\newcommand{\eqal}[1]{\begin{align}#1\end{align}}

\newcommand{\esp}{\quad\!\!}
\newcommand{\spe}[1]{\esp#1\esp}
\newcommand{\speq}{\spe{=}}

\newcommand{\E}{\mathbb E}
\newcommand{\R}{\mathbb R}
\newcommand{\eR}{\overline{\mathbb R}}

\newcommand{\scal}[1]{\left\langle#1\right\rangle}

<!-- optimisation specific -->
\newcommand{\xopt}{x^\dagger}
\newcommand{\deltaopt}{\delta^\dagger}

<!-- matrix theory specific -->
\newcommand{\inv}{^{-1}}

<!-- in-text replacements -->
\newcommand{\cvx}[1]{/pub/csml/cvxopt/!#1}
\newcommand{\mth}[1]{/pub/csml/mtheory/!#1}
\newcommand{\uns}[1]{/pub/csml/unsorted/!#1}

<!-- Text decoration -->
\newcommand{\ul}[1]{~~~<span id=underline>!#1</span>~~~}
