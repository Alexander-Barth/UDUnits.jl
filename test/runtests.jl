using UDUnits
using Base.Test

system = ut_read_xml()

unit_m = parse("m")
unit_cm = parse("cm")


@test areconvertible(unit_m,unit_cm)

conv = converter(unit_cm,unit_m)

@test convert(conv,100.) ≈ 1.

