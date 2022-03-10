# VOTables.jl

[![Build Status](https://github.com/JuliaAstro/VOTables.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/JuliaAstro/VOTables.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/JuliaAstro/VOTables.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/JuliaAstro/VOTables.jl)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://JuliaAstro.github.io/VOTables.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://JuliaAstro.github.io/VOTables.jl/dev)

A [Tables.jl](https://github.com/JuliaData/Tables.jl)-based implementation of the VOTable standard. This allows simply accessing VOTables with Tables.jl sinks, like `DataFrame` from DataFrames.jl.

**WARNING:**
This package is fairly unpolished, and I (mileslucas) don't have a ton of time for developing it. Please use at your own caution, and I would be very eager for contributions. The end goal is to have a good suite of tools for accessing SIMBAD and Vizier, which requires a reliable VOTable parser.

## Installation

## Usage

```julia
julia> using VOTables, DataFrames, URIs, HTTP

julia> script = """
output console=off script=off
votable {
    MAIN_ID
    RA(s)
    DEC(s)
    PLX(V)
    FLUX(V)
    FLUX(G)
    FLUX(H)
}
votable open
set radius 5m
query around HD 32297
votable close
""" |> URIs.escapeuri;

julia> res = HTTP.get("https://simbad.u-strasbg.fr/simbad/sim-script", query="script=$script");

julia> doc = VOTable(String(res.body))
VOTable(1)

julia> tbl = DataFrame(doc[1])
5×8 DataFrame
 Row │ MAIN_ID                     RA_s                 DEC_s                PLX_VALUE_V   FLUX_V      FLUX_G       ⋯
     │ String                      String               String               Float64?      Float32?    Float32?     ⋯
─────┼───────────────────────────────────────────────────────────────────────────────────────────────────────────────
   1 │ HD  32297                   05 02 27.4358754192  +07 27 39.678553260        7.7081        8.14        8.0983 ⋯
   2 │ TYC  110-397-1              05 02 28.2895378704  +07 26 44.794496220        6.1047       10.38       10.1454
   3 │ HD  32304                   05 02 31.4773514184  +07 25 26.492595600        5.8252        6.87        6.6137
   4 │ TYC  110-639-1              05 02 28.2086922576  +07 24 30.008622924        1.4184       10.7        10.6589
   5 │ CAIRNS J050239.37+072623.8  05 02 39.37          +07 26 23.8          missing       missing     missing      ⋯
                                                                                                    3 columns omitted

julia> names(doc[1])
8-element Vector{String}:
 "MAIN_ID"
 "RA_s"
 "DEC_s"
 "PLX_VALUE_V"
 "FLUX_V"
 "FLUX_G"
 "FLUX_H"
 "SCRIPT_NUMBER_ID"

julia> VOTables.units(doc[1])
8-element Vector{Union{Missing, String}}:
 missing
 "\"h:m:s\""
 "\"d:m:s\""
 "mas"
 "mag"
 "mag"
 "mag"
 missing
```
