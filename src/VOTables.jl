module VOTables

export VOTable

using EzXML
using EzXML: Document, Node
using Tables

struct VOTable{X<:Document,R,T}
    doc::X
    resources::R
    tables::T
end

function VOTable(source::AbstractString)
    # if string is path, assume we want to load from file
    if isfile(source)
        VOTable(parsexml(read(source)))
    else
        VOTable(parsexml(source))
    end
end

function VOTable(xml::Document)
    # validate input is VOTable
    if nodename(root(xml)) != "VOTABLE"
        throw(ArgumentError("input XML does not appear to be a VOTable"))
    end
    ns = ["x" => namespace(root(xml))]
    resources = findall("x:RESOURCE", root(xml), ns)
    tables = map(VOTableData, findall("x:RESOURCE/x:TABLE", root(xml), ns))

    return VOTable(xml, resources, tables)
end

function Base.show(io::IO, vo::VOTable)
    n = length(vo.tables)
    print(io, "VOTable($n)")
end

Base.getindex(vo::VOTable, i) = VOTableData(vo.tables[i].node)

struct VOTableData{N,F,S,T,D}
    node::N
    fields::F
    names::S
    types::T
    data::D
end

struct VOTableDatum{T,S,D}
    name::S
    type::T
    datum::D
end

Tables.columnnames(row::AbstractVector{<:VOTableDatum}) = map(d -> Symbol(d.name), row)
function Tables.getcolumn(row::AbstractVector{<:VOTableDatum}, nm::Symbol)
    i = findfirst(==(nm), Tables.columnnames(row))
    return Tables.getcolumn(row, i)
end
Tables.getcolumn(row::AbstractVector{<:VOTableDatum}, i::Int) = row[i].datum

function VOTableData(node::Node)
    ns = ["x" => namespace(node)]
    fields = findall("x:FIELD", node, ns)
    names = map(f -> f["name"], fields)
    types = map(fields) do field
        atts = map(f -> nodename(f), attributes(field))
        datatype = field["datatype"]
        if "arraysize" ∈ atts
            if datatype == "char"
                return String
            else
                return Array{TYPE_MAP[datatype]}
            end
        end
        return TYPE_MAP[datatype]
    end
    data_nodes = findfirst("x:DATA/x:TABLEDATA", node, ns)
    rows = map(eachelement(data_nodes)) do row
        map(names, types, eachelement(row)) do name, T, td
            VOTableDatum(name, T, rowdata(T, nodecontent(td)))
        end
    end
    return VOTableData(node, fields, names, types, rows)
end

rowdata(::Type{<:AbstractArray{T}}, row) where {T} = safeparse.(eltype(T), split(row))
rowdata(::Type{T}, row) where {T} = safeparse(T, row)

function safeparse(T, val)
    out = tryparse(T, val)
    isnothing(out) ? missing : out
end

safeparse(::Type{String}, val) = isempty(val) ? missing : val

TYPE_MAP = Dict(
    "boolean" => Bool,
    "unsignedByte" => UInt8,
    "short" => Int16,
    "int" => Int32,
    "long" => Int64,
    "float" => Float32,
    "double" => Float64,
    "floatComplex" => ComplexF32,
    "doubleComplex" => ComplexF64,
    # "bit" => ,
    "char" => UInt8,
    "unicodeChar" => Char
)

Tables.schema(table::VOTableData) = Tables.Schema(table.names, table.types)

# function table(::Type{TableType})

# Tables.jl interface
Tables.istable(::Type{<:VOTableData}) = true
Tables.rowaccess(::Type{<:VOTableData}) = true
Tables.rows(table::VOTableData) = getfield(table, :data)

end # module