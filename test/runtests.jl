import UDUnits
using Base.Test

system = UDUnits.System()

unit_m = UDUnits.Unit(system,"m")
unit_km = UDUnits.Unit(system,"km")
unit_cm = UDUnits.Unit(system,"cm")
unit_s = UDUnits.Unit(system,"s")
unit_h = UDUnits.Unit(system,"h")
unit_W = UDUnits.Unit(system,"W")
unit_kg = UDUnits.Unit(system,"kg")

@test UDUnits.areconvertible(unit_m,unit_cm)

conv = UDUnits.Converter(unit_cm,unit_m)
@test UDUnits.convert(conv,100.) ≈ 1.

unit_m3 = unit_m + 3
conv = UDUnits.Converter(unit_m,unit_m3)
@test UDUnits.convert(conv,100.) ≈ 97.

unit_mm3 = unit_m - 3.
conv = UDUnits.Converter(unit_m,unit_mm3)
@test UDUnits.convert(conv,100.) ≈ 103.


unit_m_per_s = unit_m/unit_s
unit_km_per_h = unit_km/unit_h
unit_Hz = 1./unit_s

@test UDUnits.areconvertible(unit_m_per_s,unit_km_per_h)
conv = UDUnits.Converter(unit_m_per_s,unit_km_per_h)

@test UDUnits.convert(conv,100.) ≈ 360.
@test conv(100.) ≈ 360.

unit_W2 = unit_kg * unit_m^2/(unit_s^3)
conv = UDUnits.Converter(unit_W2,unit_W)
@test UDUnits.convert(conv,100.) ≈ 100.



@test UDUnits.areconvertible(√(unit_m * unit_m),unit_km)

unit_logW = log10(unit_W)
@test UDUnits.areconvertible(unit_W,unit_logW)

unit_logeW = log(unit_W)
@test UDUnits.areconvertible(unit_W,unit_logeW)

unit_s2 = (unit_s * unit_s) ^(1//2)

@test UDUnits.areconvertible(unit_s2,unit_s)


@test UDUnits.name(unit_m) == "meter"
@test UDUnits.symbol(unit_m) == "m"
