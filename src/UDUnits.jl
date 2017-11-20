module UDUnits
import Base:+,-,*,/,^,inv,log,log10,√

# package code goes here
const depfile = joinpath(dirname(@__FILE__), "..", "deps", "deps.jl")
if isfile(depfile)
    include(depfile)
else
    error("libudunits2 not properly installed. Please run Pkg.build(\"UDUnits\")")
end


# default encoding is UTF8
const UT_ENC = 2

type System
    ptr :: Ptr{Void}
end

type Unit
    ptr :: Ptr{Void}
end

type Converter
    ptr :: Ptr{Void}
end
    
"""
    system = System()
"""
System() = System(ccall((:ut_read_xml,libudunits2),Ptr{Void},(Ptr{Void},),C_NULL))


Unit(system::System,unit::AbstractString) = Unit(ccall((:ut_parse ,libudunits2),Ptr{Void},(Ptr{Void},Ptr{UInt8},Cint),system.ptr,unit,UT_ENC))
areconvertible(unit1::Unit,unit2::Unit) = ccall((:ut_are_convertible ,libudunits2),Cint,(Ptr{Void},Ptr{Void}),unit1.ptr,unit2.ptr) == 1
converter(unit1::Unit,unit2::Unit) = Converter(ccall((:ut_get_converter ,libudunits2),Ptr{Void},(Ptr{Void},Ptr{Void}),unit1.ptr,unit2.ptr))


convert(conv::Converter,v::Float64) = ccall((:cv_convert_double,libudunits2),Float64,(Ptr{Void},Float64),conv.ptr,v)
(conv::Converter)(v::Number) = convert(conv,v)

"""
    s = symbol(unit::Unit)

Returns the symbol of `unit`
"""

symbol(unit::Unit) = unsafe_string(ccall((:ut_get_symbol,libudunits2),Ptr{UInt8},(Ptr{Void},Cint),unit.ptr,UT_ENC))

"""
    s = name(unit::Unit)

Returns the name of `unit`
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

export System, Unit, converter, areconvertible, name, symbol

end # module
