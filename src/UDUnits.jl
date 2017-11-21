module UDUnits
import Base:+, -, *, / , ^, inv, log, log10, √

# package code goes here
const depfile = joinpath(dirname(@__FILE__), "..", "deps", "deps.jl")
if isfile(depfile)
    include(depfile)
else
    error("libudunits2 not properly installed. Please run Pkg.build(\"UDUnits\")")
end


# default encoding is UTF8
const UT_ENC = 2


# Unit System

type System
    ptr :: Ptr{Void}
end


_free_system(system::System) = ccall((:ut_free_system,libudunits2),Ptr{Void},(Ptr{Void},),system.ptr)

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
    sys = System(ccall((:ut_read_xml,libudunits2),Ptr{Void},(Ptr{Void},),C_NULL))
    finalizer(sys,_free_system)
    return sys
end

# Unit

type Unit
    ptr :: Ptr{Void}
end

_free_unit(unit::Unit) = ccall((:ut_free,libudunits2),Ptr{Void},(Ptr{Void},),unit.ptr)
_ut_parse(system::System,unit::AbstractString) = ccall((:ut_parse ,libudunits2),Ptr{Void},(Ptr{Void},Ptr{UInt8},Cint),system.ptr,unit,UT_ENC)

function Unit(system::System,unit::AbstractString)
    ptr = _ut_parse(system,unit)
    if ptr == C_NULL
        error("UDUnits cannot parse $(unit)")
    end
    unit = Unit(ptr)
    finalizer(unit,_free_unit)
    return unit
end

Base.haskey(system::System,unit::AbstractString) = _ut_parse(system,unit) != C_NULL
Base.getindex(system::System,unit::AbstractString) = Unit(system,unit)

"""
    s = symbol(unit::Unit)

Returns the symbol of `unit`.
"""

symbol(unit::Unit) = unsafe_string(ccall((:ut_get_symbol,libudunits2),Ptr{UInt8},(Ptr{Void},Cint),unit.ptr,UT_ENC))

"""
    s = name(unit::Unit)

Returns the name of `unit`.
"""

name(unit::Unit) = unsafe_string(ccall((:ut_get_name,libudunits2),Ptr{UInt8},(Ptr{Void},Cint),unit.ptr,UT_ENC))


+(unit::Unit,offset::Number) = Unit(ccall((:ut_offset,libudunits2),Ptr{Void},(Ptr{Void},Float64),unit.ptr,offset))
-(unit::Unit,offset::Number) = unit+(-offset)
*(factor::Number,unit::Unit) = Unit(ccall((:ut_scale,libudunits2),Ptr{Void},(Float64,Ptr{Void}),factor,unit.ptr))
*(unit1::Unit,unit2::Unit) = Unit(ccall((:ut_multiply,libudunits2),Ptr{Void},(Ptr{Void},Ptr{Void}),unit1.ptr,unit2.ptr))
inv(unit::Unit) = Unit(ccall((:ut_invert,libudunits2),Ptr{Void},(Ptr{Void},),unit.ptr))
/(unit1::Unit,unit2::Unit) = Unit(ccall((:ut_divide,libudunits2),Ptr{Void},(Ptr{Void},Ptr{Void}),unit1.ptr,unit2.ptr))
/(factor::Number,unit::Unit) = factor * inv(unit)

root(unit::Unit,power::Integer) = Unit(ccall((:ut_root,libudunits2),Ptr{Void},(Ptr{Void},Cint),unit.ptr,power))

^(unit::Unit,power::Integer) = Unit(ccall((:ut_raise,libudunits2),Ptr{Void},(Ptr{Void},Cint),unit.ptr,power))
^(unit::Unit,power::Rational{<:Integer}) = root(unit^numerator(power),denominator(power))

√(unit::Unit) = root(unit,2)

log(base::Number,unit::Unit) = Unit(ccall((:ut_log,libudunits2),Ptr{Void},(Float64,Ptr{Void}),base,unit.ptr))
log(unit::Unit) = log(e,unit)
log10(unit::Unit) = log(10,unit)


# Converter

type Converter
    ptr :: Ptr{Void}
end

_free_converter(converter::Converter) = ccall((:cv_free,libudunits2),Ptr{Void},(Ptr{Void},),converter.ptr)



"""
    converter = Converter(from_unit::Unit,to_unit::Unit)

Creates converter function of numeric values in the from unit to equivalent
values in the to unit.

```julia
conv = Converter(m_per_s,km_per_h)
speed_in_m_per_s = 100.
speed_in_km_per_h = conv(speed_in_m_per_s)
```
"""

function Converter(from_unit::Unit,to_unit::Unit)
    if !areconvertible(from_unit,to_unit)
        error("UDUnits cannot convert from $(from_unit) to $(to_unit)")
    end

    ptr = ccall((:ut_get_converter ,libudunits2),
                Ptr{Void},(Ptr{Void},Ptr{Void}),from_unit.ptr,to_unit.ptr)

    if ptr == C_NULL
        error("UDUnits cannot convert from $(from_unit) to $(to_unit)")
    end

    converter = Converter(ptr)

    finalizer(converter,_free_converter)
    return converter
end

"""
    bool = areconvertible(from_unit::Unit,to_unit::Unit)

Return true if `from_unit` and `to_unit` are convertible, otherwise false.
"""

areconvertible(unit1::Unit,unit2::Unit) = ccall((:ut_are_convertible ,libudunits2),Cint,(Ptr{Void},Ptr{Void}),unit1.ptr,unit2.ptr) == 1


convert(conv::Converter,v::Float64) = ccall((:cv_convert_double,libudunits2),Float64,(Ptr{Void},Float64),conv.ptr,v)
(conv::Converter)(v::Number) = convert(conv,v)

export System, Unit, Converter, areconvertible, name, symbol

end # module
