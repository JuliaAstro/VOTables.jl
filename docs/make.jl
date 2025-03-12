using VOTables
using Documenter
using Documenter.Remotes: GitHub

DocMeta.setdocmeta!(VOTables, :DocTestSetup, :(using VOTables); recursive=true)

makedocs(;
    modules=[VOTables],
    authors="Miles Lucas <mdlucas@hawaii.edu> and contributors",
    repo=GitHub("JuliaAstro/VOTables.jl"),
    sitename="VOTables.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(
    repo="github.com/JuliaAstro/VOTables.jl",
    push_preview=true,
    devbranch="main"
)
