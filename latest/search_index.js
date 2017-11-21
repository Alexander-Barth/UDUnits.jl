var documenterSearchIndex = {"docs": [

{
    "location": "index.html#",
    "page": "UDUnits.jl",
    "title": "UDUnits.jl",
    "category": "page",
    "text": ""
},

{
    "location": "index.html#UDUnits.System",
    "page": "UDUnits.jl",
    "title": "UDUnits.System",
    "category": "Type",
    "text": "system = System()\n\nLoad the default SI unit system. system behaves similar to a dictionary as it supports indexing and the function haskey (to determine if a unit is a valid):\n\nusing UDUnits\nsys = System()\nm = sys[\"meter\"]\nhaskey(sys,\"μm\") # returns true\n\n\n\n"
},

{
    "location": "index.html#UDUnits.symbol",
    "page": "UDUnits.jl",
    "title": "UDUnits.symbol",
    "category": "Function",
    "text": "s = symbol(unit::Unit)\n\nReturns the symbol of unit.\n\n\n\n"
},

{
    "location": "index.html#UDUnits.name",
    "page": "UDUnits.jl",
    "title": "UDUnits.name",
    "category": "Function",
    "text": "s = name(unit::Unit)\n\nReturns the name of unit.\n\n\n\n"
},

{
    "location": "index.html#UDUnits.Converter-Tuple{UDUnits.Unit,UDUnits.Unit}",
    "page": "UDUnits.jl",
    "title": "UDUnits.Converter",
    "category": "Method",
    "text": "converter = Converter(from_unit::Unit,to_unit::Unit)\n\nCreates a converter function of numeric values in the from_unit to equivalent values in the to_unit.\n\nusing UDUnits\nsys = System()\nconv = Converter(sys[\"m/s\"],sys[\"km/h\"])\nspeed_in_m_per_s = 100.\nspeed_in_km_per_h = conv(speed_in_m_per_s)\n\n\n\n"
},

{
    "location": "index.html#UDUnits.areconvertible-Tuple{UDUnits.Unit,UDUnits.Unit}",
    "page": "UDUnits.jl",
    "title": "UDUnits.areconvertible",
    "category": "Method",
    "text": "bool = areconvertible(from_unit::Unit,to_unit::Unit)\n\nReturn true if from_unit and to_unit are convertible, otherwise false.\n\n\n\n"
},

{
    "location": "index.html#UDUnits.jl-1",
    "page": "UDUnits.jl",
    "title": "UDUnits.jl",
    "category": "section",
    "text": "Documentation for UDUnits.jlSystem\nsymbol\nname\nConverter(from_unit::Unit,to_unit::Unit)\nareconvertible(from_unit::Unit,to_unit::Unit)"
},

]}
