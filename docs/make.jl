using VOTables
using Documenter

DocMeta.setdocmeta!(VOTables, :DocTestSetup, :(using VOTables); recursive=true)

makedocs(;
    modules=[VOTables],
    authors="Miles Lucas <mdlucas@hawaii.edu> and contributors",
    repo="https://github.com/mileslucas/VOTables.jl/blob/{commit}{path}#{line}",
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
    repo="github.com/mileslucas/VOTables.jl",
    push_preview=true,
    devbranch="main"
)
