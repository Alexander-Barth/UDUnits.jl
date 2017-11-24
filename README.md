# UDUnits

[![Build Status](https://travis-ci.org/Alexander-Barth/UDUnits.jl.svg?branch=master)](https://travis-ci.org/Alexander-Barth/UDUnits.jl)
[![Coverage Status](https://coveralls.io/repos/Alexander-Barth/UDUnits.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/Alexander-Barth/UDUnits.jl?branch=master)
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
Pkg.clone("https://github.com/Alexander-Barth/UDUnits.jl")
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

Similarily to a dictionary, the function `haskey` is defined to determine if a unit is a valid:

```julia
haskey(sys,"μm") # returns true
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

## Windows

I did not succeed to install `UDUnits.jl` on Windows using the package manager Conda.
One way to make it work on Windows is to bypass Conda:

* extract `udunits2.dll` and all xml files from https://anaconda.org/conda-forge/udunits2/2.2.23/download/win-64/udunits2-2.2.23-vc9_1.tar.bz2
* expat.dll from https://anaconda.org/conda-forge/expat/2.1.0/download/win-64/expat-2.1.0-vc9_1.tar.bz2
* place all these files in the `deps` folder of `UDUnits` (i.e. the output of `joinpath(Pkg.dir("UDUnits"),"deps")`)

* run

```julia
Pkg.build("UDUnits")
```

* before any call to `using UDUnits` or `import UDUnits`, set the following variable:

```julia
ENV["UDUNITS2_XML_PATH"] = joinpath(Pkg.dir("UDUnits"),"deps","udunits2.xml")
```




## Resources

* [Documentation of the C-library](http://www.unidata.ucar.edu/software/udunits/udunits-2.2.25/doc/udunits/udunits2lib.html#UDUNITS-Library)
