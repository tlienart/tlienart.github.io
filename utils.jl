using Dates

const FIRST_YEAR = 2015

function hfun_posts()
    curyear = year(Dates.today())
    io = IOBuffer()
    for year in curyear:-1:FIRST_YEAR
        ys = "$year"
        isdir(joinpath("posts", ys)) || continue
        write(io, "\n\n### $year\n\n")
        write(io, "@@list,mb-5\n")
        for month in 12:-1:1
            ms = "0"^(month < 10) * "$month"
            base = joinpath("posts", ys, ms)
            isdir(base) || continue
            posts = filter!(p -> endswith(p, ".md"), readdir(base))
            days  = zeros(Int, length(posts))
            lines = Vector{String}(undef, length(posts))
            for (i, post) in enumerate(posts)
                ps  = splitext(post)[1]
                url = "/posts/$ys/$ms/$ps/"
                surl = strip(url, '/')
                title = pagevar(surl, :title)
                days[i] = parse(Int, first(ps, 2))
                pubdate = Dates.format(
                    Date(year, month, days[i]), "U d")

                tmp = "* ~~~<span class=\"post-date\">$pubdate</span><a href=\"$url\">$title</a>"
                descr = pagevar(surl, :descr)
                if descr !== nothing
                    tmp *= ": <span class=\"post-descr\">$descr</span>"
                end
                lines[i] = tmp * "~~~\n"
            end
            # sort by day
            foreach(line -> write(io, line), lines[sortperm(days, rev=true)])
        end
        write(io, "@@\n")
    end
    return Franklin.fd2html(String(take!(io)), internal=true)
end

@delay function hfun_list_tags()
    tagpages = globvar("fd_tag_pages")
    if tagpages === nothing
        return ""
    end
    tags = tagpages |> keys |> collect |> sort
    tags_count = [length(tagpages[t]) for t in tags]
    io = IOBuffer()
    for (t, c) in zip(tags, tags_count)
        write(io, """
            <nobr>
              <a href=\"/tag/$t/\" class=\"tag-link\">$(replace(t, "_" => " "))</a>
              <span class="tag-count"> ($c)</span>
            </nobr>
            """)
    end
    return String(take!(io))
end

# doesn't need to be delayed because it's generated at tag generation, after everything else
function hfun_tag_list()
    tag = locvar(:fd_tag)::String
    items = Dict{Date,String}()
    for rpath in globvar("fd_tag_pages")[tag]
        title = pagevar(rpath, "title")
        url = Franklin.get_url(rpath)
        surl = strip(url, '/')

        ys, ms, ps = split(surl, '/')[end-2:end]
        date = Date(parse(Int, ys), parse(Int, ms), parse(Int, first(ps, 2)))
        date_str = Dates.format(date, "U d, Y")

        tmp = "* ~~~<span class=\"post-date tag\">$date_str</span><nobr><a href=\"$url\">$title</a></nobr>"
        descr = pagevar(rpath, :descr)
        if descr !== nothing
            tmp *= ": <span class=\"post-descr\">$descr</span>"
        end
        tmp *= "~~~\n"
        items[date] = tmp
    end
    sorted_dates = sort!(items |> keys |> collect, rev=true)
    io = IOBuffer()
    write(io, "@@posts-container,mx-auto,px-3,py-5,list,mb-5\n")
    for date in sorted_dates
        write(io, items[date])
    end
    write(io, "@@")
    return Franklin.fd2html(String(take!(io)), internal=true)
end

function hfun_current_tag()
    return replace(locvar("fd_tag"), "_" => " ")
end

hfun_svg_linkedin() = """<svg width="30" height="30" viewBox="0 50 512 512"><path fill="currentColor" d="M150.65 100.682c0 27.992-22.508 50.683-50.273 50.683-27.765 0-50.273-22.691-50.273-50.683C50.104 72.691 72.612 50 100.377 50c27.766 0 50.273 22.691 50.273 50.682zm-7.356 86.651H58.277V462h85.017V187.333zm135.901 0h-81.541V462h81.541V317.819c0-38.624 17.779-61.615 51.807-61.615 31.268 0 46.289 22.071 46.289 61.615V462h84.605V288.085c0-73.571-41.689-109.131-99.934-109.131s-82.768 45.369-82.768 45.369v-36.99z"/></svg>"""

hfun_svg_github() = """<svg width="30" height="30" viewBox="0 0 25 25" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9 19c-5 1.5-5-2.5-7-3m14 6v-3.87a3.37 3.37 0 0 0-.94-2.61c3.14-.35 6.44-1.54 6.44-7A5.44 5.44 0 0 0 20 4.77 5.07 5.07 0 0 0 19.91 1S18.73.65 16 2.48a13.38 13.38 0 0 0-7 0C6.27.65 5.09 1 5.09 1A5.07 5.07 0 0 0 5 4.77a5.44 5.44 0 0 0-1.5 3.78c0 5.42 3.3 6.61 6.44 7A3.37 3.37 0 0 0 9 18.13V22"/></svg>"""

hfun_svg_twitter() = """<svg width="30" height="30" viewBox="0 0 335 276" fill="currentColor"><path d="M302 70A195 195 0 0 1 3 245a142 142 0 0 0 97-30 70 70 0 0 1-58-47 70 70 0 0 0 31-2 70 70 0 0 1-57-66 70 70 0 0 0 28 5 70 70 0 0 1-18-90 195 195 0 0 0 141 72 67 67 0 0 1 116-62 117 117 0 0 0 43-17 65 65 0 0 1-31 38 117 117 0 0 0 39-11 65 65 0 0 1-32 35"/></svg>"""

hfun_svg_tag() = """<a href="/tags/" id="tag-icon"><svg width="20" height="20" viewBox="0 0 512 512"><defs><style>.cls-1{fill:#141f38}</style></defs><path class="cls-1" d="M215.8 512a76.1 76.1 0 0 1-54.17-22.44L22.44 350.37a76.59 76.59 0 0 1 0-108.32L242 22.44A76.11 76.11 0 0 1 296.2 0h139.2A76.69 76.69 0 0 1 512 76.6v139.19A76.08 76.08 0 0 1 489.56 270L270 489.56A76.09 76.09 0 0 1 215.8 512zm80.4-486.4a50.69 50.69 0 0 0-36.06 14.94l-219.6 219.6a51 51 0 0 0 0 72.13l139.19 139.19a51 51 0 0 0 72.13 0l219.6-219.61a50.67 50.67 0 0 0 14.94-36.06V76.6a51.06 51.06 0 0 0-51-51zm126.44 102.08A38.32 38.32 0 1 1 461 89.36a38.37 38.37 0 0 1-38.36 38.32zm0-51a12.72 12.72 0 1 0 12.72 12.72 12.73 12.73 0 0 0-12.72-12.76z"/><path class="cls-1" d="M217.56 422.4a44.61 44.61 0 0 1-31.76-13.16l-83-83a45 45 0 0 1 0-63.52L211.49 154a44.91 44.91 0 0 1 63.51 0l83 83a45 45 0 0 1 0 63.52L249.31 409.24a44.59 44.59 0 0 1-31.75 13.16zm-96.7-141.61a19.34 19.34 0 0 0 0 27.32l83 83a19.77 19.77 0 0 0 27.31 0l108.77-108.7a19.34 19.34 0 0 0 0-27.32l-83-83a19.77 19.77 0 0 0-27.31 0l-108.77 108.7z"/><path class="cls-1" d="M294.4 281.6a12.75 12.75 0 0 1-9-3.75l-51.2-51.2a12.8 12.8 0 0 1 18.1-18.1l51.2 51.2a12.8 12.8 0 0 1-9.05 21.85zM256 320a12.75 12.75 0 0 1-9.05-3.75l-51.2-51.2a12.8 12.8 0 0 1 18.1-18.1l51.2 51.2A12.8 12.8 0 0 1 256 320zM217.6 358.4a12.75 12.75 0 0 1-9-3.75l-51.2-51.2a12.8 12.8 0 1 1 18.1-18.1l51.2 51.2a12.8 12.8 0 0 1-9.05 21.85z"/></svg></a>"""

@delay function hfun_page_tags()
    pagetags = globvar("fd_page_tags")
    pagetags === nothing && return ""
    io = IOBuffer()
    tags = pagetags[splitext(locvar("fd_rpath"))[1]] |> collect |> sort
    several = length(tags) > 1
    write(io, """<div class="tags">$(hfun_svg_tag())""")
    for tag in tags[1:end-1]
        t = replace(tag, "_" => " ")
        write(io, """<a href="/tag/$tag/">$t</a>, """)
    end
    tag = tags[end]
    t = replace(tag, "_" => " ")
    write(io, """<a href="/tag/$tag/">$t</a></div>""")
    return String(take!(io))
end
