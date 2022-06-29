# UDUnits


[![Build Status](https://github.com/Alexander-Barth/UDUnits.jl/workflows/CI/badge.svg)](https://github.com/Alexander-Barth/UDUnits.jl/actions)
[![codecov.io](http://codecov.io/github/Alexander-Barth/UDUnits.jl/coverage.svg?branch=master)](http://codecov.io/github/Alexander-Barth/UDUnits.jl?branch=master)

<!-- udunits is currently not available for Windows in conda -->

<!--
[![Build Status Windows](https://ci.appveyor.com/api/projects/status/github/Alexander-Barth/UDUnits.jl?branch=master&svg=true)](https://ci.appveyor.com/project/Alexander-Barth/udunits-jl)
-->

[![documentation stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://alexander-barth.github.io/UDUnits.jl/stable/)
[![documentation latest](https://img.shields.io/badge/docs-latest-blue.svg)](https://alexander-barth.github.io/UDUnits.jl/latest/)


## Installation

Inside the Julia shell, you can download and install the package by issuing:

```julia
using Pkg
Pkg.add("UDUnits")
```

### Latest development version

If you want to try the latest development version, you can do this with the following commands:

```julia
using Pkg
Pkg.add(PackageSpec(url="https://github.com/Alexander-Barth/UDUnits.jl", rev="master"))
Pkg.build("UDUnits")
```

## Loading the module

The first step is to load the module `UDUnits` and to initialize the unit system `sys` which correspond to the SI unit system.

```julia
using UDUnits
sys = System()
```

## Units

The unit objects can be created for `m` and `cm` using either their symbol or their full name by indexing the `sys` object as if `sys` is a dictionary.

```julia
m = sys["meter"]
cm = sys["cm"]
```

Similarily to a dictionary, the function `haskey` is defined to determine if a unit is valid:

```julia
haskey(sys,"μm") # returns true since UDUnits knows about micrometers
```

# Derived units

Units can be derived using the usual mathemical operators. Of course, `m_per_s` could have been also create simply by using `sys["m/s"]`.


```julia
m = sys["m"]
km = sys["km"]
s = sys["s"]
h = sys["h"]
m_per_s = m/s
km_per_h = km/h
```

# Converting data

The function `areconvertible` returns `true` if two units are convertible:

```julia
@show areconvertible(m_per_s,km_per_h)
```

To convert units, create a converter object and then apply the object to some data.

```julia
conv = Converter(m_per_s,km_per_h)
speed_in_m_per_s = 100.
speed_in_km_per_h = conv(speed_in_m_per_s)
```

The dot syntax can be used for an array as input:

```julia
speed_in_m_per_s = [100.,110.,120.]
speed_in_km_per_h = conv.(speed_in_m_per_s)
```

## Alternatives

* [Unitful.jl](https://github.com/PainterQubits/Unitful.jl)

## Resources

* [Documentation of the C-library](http://www.unidata.ucar.edu/software/udunits/udunits-2.2.25/doc/udunits/udunits2lib.html#UDUNITS-Library)
