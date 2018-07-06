module UDUnits
import Base:+, -, *, / , ^, inv, log, log10, √, show, convert

# package code goes here
const depfile = joinpath(dirname(@__FILE__), "..", "deps", "deps.jl")
if isfile(depfile)
    include(depfile)
else
    error("libudunits2 not properly installed. Please run Pkg.build(\"UDUnits\")")
end

if VERSION >= v"0.7.0-beta.0"
    using Libdl
else
    using Compat
end



const UT_encoding_t = Cint
const UT_UTF8 = 2
const UT_NAMES = 4
const UT_DEFINITION = 8

const buffer_size = 100

# default encoding is UTF8
const UT_ENC = UT_UTF8

# Unit System

mutable struct System
    ptr :: Ptr{Nothing}
end

convert(::Type{Ptr{Nothing}}, sys::System) = sys.ptr
_free_system(system::System) = ccall((:ut_free_system,libudunits2),Ptr{Nothing},(Ptr{Nothing},),system)

"""
    system = System()

Load the default SI unit system. `system` behaves similar to a dictionary as it
supports indexing and the function `haskey` (to determine if a unit is a valid):

```julia
using UDUnits
sys = System()
m = sys["meter"]
haskey(sys,"μm") # returns true
```

"""
function System()
    sys = System(ccall((:ut_read_xml,libudunits2),Ptr{Nothing},(Ptr{Nothing},),C_NULL))
    if VERSION >= v"0.7.0-beta.0"
        finalizer(_free_system,sys)
    else
        finalizer(sys,_free_system)
    end
    return sys
end

# Unit

mutable struct Unit
    ptr :: Ptr{Nothing}
end


convert(t::Type{Ptr{Nothing}}, unit::Unit) = unit.ptr

_free_unit(unit::Unit) = ccall((:ut_free,libudunits2),Ptr{Nothing},(Ptr{Nothing},),unit)
_ut_parse(system::System,unit::AbstractString) =
    ccall((:ut_parse ,libudunits2),
          Ptr{Nothing},(Ptr{Nothing},Ptr{UInt8},UT_encoding_t),system,unit,UT_ENC)

function Unit(system::System,unit::AbstractString)
    ptr = _ut_parse(system,unit)
    if ptr == C_NULL
        error("UDUnits cannot parse $(unit)")
    end
    unit = Unit(ptr)
    if VERSION >= v"0.7.0-beta.0"
        finalizer(_free_unit,unit)
    else
        finalizer(unit,_free_unit)
    end
    return unit
end

"""
    s = format(unit::Unit; names = false, definition = false)

Format the unit `unit` as a string. If names is true, then definition uses
the unit names (e.g. meter) instead of symbols (e.g. m). If definition is
true, then the unit should be expressed in terms of basic units (m²·kg·s⁻³
instead of W).

"""
function format(unit::Unit; names = false, definition = false)
    buffer = Vector{UInt8}(undef,buffer_size)
    opts = UT_ENC

    if names
        opts |= UT_NAMES
    end

    if definition
        opts |= UT_DEFINITION
    end

    len = ccall((:ut_format,libudunits2),Cint,(Ptr{Nothing},Ptr{UInt8},Csize_t,Cint),unit,buffer,length(buffer),opts)
    if len == -1
        return "unknown"
    else
        return unsafe_string(pointer(buffer))
    end
end

Base.string(unit::Unit) = format(unit)

function Base.show(io::IO,unit::Unit)
    print(io,"<Unit: ")
    printstyled(io, format(unit); color = :blue)
    print(io,">\n")
end

Base.haskey(system::System,unit::AbstractString) = _ut_parse(system,unit) != C_NULL
Base.getindex(system::System,unit::AbstractString) = Unit(system,unit)

"""
    s = symbol(unit::Unit)

Returns the symbol of `unit`.
"""
symbol(unit::Unit) =
    unsafe_string(ccall((:ut_get_symbol,libudunits2),Ptr{UInt8},(Ptr{Nothing},UT_encoding_t),unit,UT_ENC))

"""
    s = name(unit::Unit)

Returns the name of `unit`.
"""
name(unit::Unit) =
    unsafe_string(ccall((:ut_get_name,libudunits2),Ptr{UInt8},(Ptr{Nothing},UT_encoding_t),unit,UT_ENC))


+(unit::Unit,offset::Number) = Unit(ccall((:ut_offset,libudunits2),Ptr{Nothing},(Ptr{Nothing},Float64),unit,offset))
-(unit::Unit,offset::Number) = unit+(-offset)
*(factor::Number,unit::Unit) = Unit(ccall((:ut_scale,libudunits2),Ptr{Nothing},(Float64,Ptr{Nothing}),factor,unit))
*(unit1::Unit,unit2::Unit) = Unit(ccall((:ut_multiply,libudunits2),Ptr{Nothing},(Ptr{Nothing},Ptr{Nothing}),unit1,unit2))
inv(unit::Unit) = Unit(ccall((:ut_invert,libudunits2),Ptr{Nothing},(Ptr{Nothing},),unit))
/(unit1::Unit,unit2::Unit) = Unit(ccall((:ut_divide,libudunits2),Ptr{Nothing},(Ptr{Nothing},Ptr{Nothing}),unit1,unit2))
/(factor::Number,unit::Unit) = factor * inv(unit)

root(unit::Unit,power::Integer) = Unit(ccall((:ut_root,libudunits2),Ptr{Nothing},(Ptr{Nothing},Cint),unit,power))

^(unit::Unit,power::Integer) = Unit(ccall((:ut_raise,libudunits2),Ptr{Nothing},(Ptr{Nothing},Cint),unit,power))
^(unit::Unit,power::Rational{<:Integer}) = root(unit^numerator(power),denominator(power))

√(unit::Unit) = root(unit,2)

log(base::Number,unit::Unit) = Unit(ccall((:ut_log,libudunits2),Ptr{Nothing},(Float64,Ptr{Nothing}),base,unit))
log(unit::Unit) = log(e,unit)
log10(unit::Unit) = log(10,unit)


# Converter

mutable struct Converter
    ptr :: Ptr{Nothing}
end

convert(t::Type{Ptr{Nothing}}, conv::Converter) = conv.ptr
_free_converter(converter::Converter) = ccall((:cv_free,libudunits2),Ptr{Nothing},(Ptr{Nothing},),converter)


"""
    converter = Converter(from_unit::Unit,to_unit::Unit)

Creates a converter function of numeric values in the `from_unit` to equivalent
values in the `to_unit`.

```julia
using UDUnits
sys = System()
conv = Converter(sys["m/s"],sys["km/h"])
speed_in_m_per_s = 100.
speed_in_km_per_h = conv(speed_in_m_per_s)
```
"""
function Converter(from_unit::Unit,to_unit::Unit)
    if !areconvertible(from_unit,to_unit)
        error("UDUnits cannot convert from $(from_unit) to $(to_unit)")
    end

    ptr = ccall((:ut_get_converter ,libudunits2),
                Ptr{Nothing},(Ptr{Nothing},Ptr{Nothing}),from_unit,to_unit)

    # ptr should not be null since the units are convertible
    @assert ptr != C_NULL

    converter = Converter(ptr)

    if VERSION >= v"0.7.0-beta.0"
        finalizer(_free_converter,converter)
    else
        finalizer(converter,_free_converter)
    end
    return converter
end

"""
    bool = areconvertible(from_unit::Unit,to_unit::Unit)

Return true if `from_unit` and `to_unit` are convertible, otherwise false.
"""
areconvertible(unit1::Unit,unit2::Unit) = ccall((:ut_are_convertible ,libudunits2),Cint,(Ptr{Nothing},Ptr{Nothing}),unit1,unit2) == 1


convert(conv::Converter,v::Float64) = ccall((:cv_convert_double,libudunits2),Float64,(Ptr{Nothing},Float64),conv,v)
(conv::Converter)(v::Number) = convert(conv,v)

"""
    s = expression(conv::Converter; variable = "x")
Return a string representation of the converter `conv` using the
variable `variable`.
"""
function expression(conv::Converter; variable = "x")
    buffer = Vector{UInt8}(undef,buffer_size)
    len = ccall((:cv_get_expression,libudunits2),Cint,(Ptr{Nothing},Ptr{UInt8},Csize_t,Ptr{UInt8}),conv,buffer,length(buffer),variable)

    @assert len != -1

    return unsafe_string(pointer(buffer))
end

function Base.show(io::IO,conv::Converter)
    print(io,"<Converter: ")
    printstyled(io, expression(conv); color = :blue)
    print(io,">\n")
end

export System, Unit, Converter, areconvertible, name, symbol, expression, format

end # module
