@def title = "About"
@def date = Dates.today()

# About this website

## Big picture

<!--
    🍺 mention that use to use Jemdoc, was nice because simple + straightforward support for Mathjax but a bit poor on feature and slow to generate website, especially when doing a lot of back and forth to check how things go, it's a bit painful
    🍺 wrote a latex to jemdoc thing, to try to leverage the fact that I was used to writing in LaTeX and compilation was reasonably quick and then have python code that would write and compile the jemdoc once afterwards generating the webpages in a few seconds. This worked fine and I used it quite a bit, the code was not very quick but "worked". It kind of did the job. (Btw Pandoc could be used of course but, in my experience, does not deal well with maths, or maybe I just didn't understand how to make it work with maths or any non simple environments which don't directly have a mirror in HTML or markdown) ⟾ ⟾ maybe here send to the second part on JuDoc.
    🍺 then an idea emerged: could I write something like Jemdoc that would
        1. allow something that looks like Latex to be used on top of markdown
        1. generate webpages quickly like Hugo
        1. write the whole lot in Julia because I quite like Julia
    🍺 this project was of interest to me because I'm interested in parsing though I have no formal training in it (and not much desire to really understand the grammar stuff and the lexing and parsing thing). I kind of wanted to build that stuff myself. Of course here any CS person would laugh and think I'm crazy (and a bit stupid), of course the parser I ended up working is definitely not something that can be compared to any decent modern parser out there but it has one big advantage: I fully understand how it works and I enjoyed thinking about how to build it and make it not too slow. By far the parsing of this "extended markdown" and conversion to html was the bigger part of the work (JuDoc). The rest was just a matter of making sure infrastructure files such as headers etc were in place and could be tracked. While the code I wrote for all this is also probably not something I'd put on my CV (to quote Jemdoc's author), again I enjoyed writing the different parts and trying to make them work efficiently and sensibly though [lots of work remains to be done](URL to judoc contribution).
    🍺 another good side is that I really wanted to have a website that would be quick and efficient and where I could understand all the moving parts. I also wanted to have a code project that I would keep working on in the future. Now I have both, the website works and motivates me to keep updating the SSG when I have trouble with it or think about new features. This may stay that way or it may happen that one day people think that there are a few good ideas in the lot and help me push this to become better code that could actually be used by more people than just me!
    🍺 Maybe a simple schema of what's going on
        🍺 mention own SSG parsing an extended markdown dialect
    🍺 does it work?
        - well yes, I mean you can see the website so, in a sense, it "works"
        - pages re-compile pretty much instantaneously (around 5-6ms on my laptop) and with browser-sync, it's like having latex but with instant compilation (of course it's a very simple subset of latex).
        A full pass on the whole website, once julia is warm, takes around 70ms
        (maybe add some stats here based on average page compilation, max, min)
-->

## JuDoc

<!--
    🍺 why write yet another SSG, what was wrong with the dozens already present?
        🍉 do not re-write the README for Judoc, maybe just redirect and write a short version here. Maybe start with writing a good Readme for JuDoc and then come back here.
        🍺 use Katex over mathjax
        🍺 use as little java script as possible
        🍺 basically make content
    🍺 KaTeX vs Mathjax, but KaTeX is a bit harder to use + eqref are not directly supported etc
    🍺 Julia
-->
