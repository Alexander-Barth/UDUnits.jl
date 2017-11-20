module UDUnits

# package code goes here
const depfile = joinpath(dirname(@__FILE__), "..", "deps", "deps.jl")
if isfile(depfile)
    include(depfile)
else
    error("libudunits2 not properly installed. Please run Pkg.build(\"UDUnits\")")
end


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
    system = ut_read_xml()
"""
ut_read_xml() = System(ccall((:ut_read_xml,libudunits2),Ptr{Void},(Ptr{Void},),C_NULL))

# default encoding is UTF8
const UT_ENC = 2

parse(system::System,unit::AbstractString) = Unit(ccall((:ut_parse ,libudunits2),Ptr{Void},(Ptr{Void},Ptr{UInt8},Cint),system.ptr,unit,UT_ENC))
areconvertible(unit1::Unit,unit2::Unit) = ccall((:ut_are_convertible ,libudunits2),Cint,(Ptr{Void},Ptr{Void}),unit1.ptr,unit2.ptr) == 1
converter(unit1::Unit,unit2::Unit) = Converter(ccall((:ut_get_converter ,libudunits2),Ptr{Void},(Ptr{Void},Ptr{Void}),unit1.ptr,unit2.ptr))


convert(conv::Converter,v::Float64) = ccall((:cv_convert_double,libudunits2),Float64,(Ptr{Void},Float64),conv.ptr,v)

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


export ut_read_xml, parse, convert, converter, areconvertible, name, symbol

end # module
