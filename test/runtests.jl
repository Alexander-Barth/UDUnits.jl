import UDUnits
using Base.Test

system = UDUnits.ut_read_xml()

unit_m = UDUnits.parse(system,"m")
unit_cm = UDUnits.parse(system,"cm")

@test UDUnits.areconvertible(unit_m,unit_cm)

conv = UDUnits.converter(unit_cm,unit_m)

@test UDUnits.convert(conv,100.) ≈ 1.


@test UDUnits.name(unit_m) == "meter"
@test UDUnits.symbol(unit_m) == "m"
