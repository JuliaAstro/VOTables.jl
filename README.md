# VOTables.jl

[![Build Status](https://github.com/JuliaAstro/VOTables.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/JuliaAstro/VOTables.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/JuliaAstro/VOTables.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/JuliaAstro/VOTables.jl)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://JuliaAstro.github.io/VOTables.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://JuliaAstro.github.io/VOTables.jl/dev)



## Installation

## Usage

```julia
julia> using VOTables, DataFrames, URIs, HTTP

julia> script = """
output console=off script=off
votable v1 {
    MAIN_ID
    COO(A D)
    PLX(V)
    FLUXLIST(V;G;I;H)
}
set radius 30m
votable open v1
HD32297
votable close
""" |> URIs.escapeuri;

julia> res = HTTP.get("https://simbad.u-strasbg.fr/simbad/sim-script", query="script=$script");

julia> doc = VOTable(String(res.body))
VOTable(1)

julia> tbl = DataFrame(doc[1])
1×8 DataFrame
 Row │ MAIN_ID    RA_A_D               DEC_A_D              COO_ERR_MAJA_A_D  COO_ERR_MINA_A_D  COO_ERR_ANGLE_A_D   ⋯
     │ String     String               String               Float32           Float32           Int16               ⋯
─────┼───────────────────────────────────────────────────────────────────────────────────────────────────────────────
   1 │ HD  32297  05 02 27.4358754192  05 02 27.4358754192            0.0267            0.0169                 90   ⋯
                                                                                                    2 columns omitted
julia> names(doc[1])
8-element Vector{String}:
 "MAIN_ID"
 "RA_A_D"
 "DEC_A_D"
 "COO_ERR_MAJA_A_D"
 "COO_ERR_MINA_A_D"
 "COO_ERR_ANGLE_A_D"
 "PLX_VALUE_V"
 "SCRIPT_NUMBER_ID"

julia> VOTables.units(doc[1])
8-element Vector{Union{Missing, String}}:
 missing
 "\"h:m:s\""
 "\"h:m:s\""
 "mas"
 "mas"
 "deg"
 "mas"
 missing
```
