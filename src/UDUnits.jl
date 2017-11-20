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
ut_read_xml() = ccall((:ut_read_xml,libudunits2),Ptr{Void},(Ptr{Void},),C_NULL)


parse(system,unit) = ccall((:ut_parse ,libudunits2),Ptr{Void},(Ptr{Void},Ptr{UInt8},Cint),system,unit,0)
areconvertible(unit1,unit2) = ccall((:ut_are_convertible ,libudunits2),Cint,(Ptr{Void},Ptr{Void}),unit1,unit2) == 1
converter(unit1,unit2) = ccall((:ut_get_converter ,libudunits2),Ptr{Void},(Ptr{Void},Ptr{Void}),unit1,unit2)
convert(conv,v::Float64) = ccall((:cv_convert_double,libudunits2),Float64,(Ptr{Void},Float64),conv,v)

export ut_read_xml, parse, convert, converter, areconvertible

end # module
