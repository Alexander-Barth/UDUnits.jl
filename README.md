# UDUnits

[![Build Status](https://travis-ci.org/Alexander-Barth/UDUnits.jl.svg?branch=master)](https://travis-ci.org/Alexander-Barth/UDUnits.jl)

[![Coverage Status](https://coveralls.io/repos/Alexander-Barth/UDUnits.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/Alexander-Barth/UDUnits.jl?branch=master)

<!-- udunits is currently not available for Windows in conda -->

<!--
[![Build Status Windows](https://ci.appveyor.com/api/projects/status/github/Alexander-Barth/UDUnits.jl?branch=master&svg=true)](https://ci.appveyor.com/project/Alexander-Barth/udunits-jl)
-->

[![codecov.io](http://codecov.io/github/Alexander-Barth/UDUnits.jl/coverage.svg?branch=master)](http://codecov.io/github/Alexander-Barth/UDUnits.jl?branch=master)

## Loading the module

Loade the module `UDUnits` and initialize the unit system.

```julia
using UDUnits
sys = System()
```

## Parsing units

The units `m` and `cm` can be parsed using either their symbol or their full name.

```julia
m = Unit(sys,"meter")
cm = Unit(sys,"cm")
```

# Derived units

Units can be derived using the usual mathemical operators. Of course, `m_per_s` could have been also create simply by using `Unit(sys,"m/s")`.


```julia
m = Unit(sys,"m")
km = Unit(sys,"km")
s = Unit(sys,"s")
h = Unit(sys,"h")
m_per_s = m/s
km_per_h = km/h
```

# Converting data

The function `areconvertible` returns `true` if two units are convertible:

```julia
@show areconvertible(m_per_s,km_per_h)
```

Create a converter object and then apply the object to some data.

```julia
conv = Converter(m_per_s,km_per_h)
speed_in_m_per_s = 100.
speed_in_km_per_h = conv(speed_in_m_per_s)
```

For an array as input:

```julia
speed_in_m_per_s = [100.,110.,120.]
speed_in_km_per_h = conv.(speed_in_m_per_s)
```


## Resources

* [Documentation of the C-library](http://www.unidata.ucar.edu/software/udunits/udunits-2.2.25/doc/udunits/udunits2lib.html#UDUNITS-Library)
