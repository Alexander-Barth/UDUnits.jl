import UDUnits
using Test

@testset "UDUnits" begin
    system = UDUnits.System()

    unit_m = UDUnits.Unit(system,"m")
    unit_km = UDUnits.Unit(system,"km")
    unit_cm = UDUnits.Unit(system,"cm")
    unit_s = UDUnits.Unit(system,"s")
    unit_h = UDUnits.Unit(system,"h")
    unit_W = UDUnits.Unit(system,"W")
    unit_kg = UDUnits.Unit(system,"kg")
    unit_kg = system["kg"]
    unit_μm = system["μm"]

    @test haskey(system,"kg")
    @test haskey(system,"μm")


    @test_throws ErrorException UDUnits.Unit(system,"badname")


    @test UDUnits.areconvertible(unit_m,unit_cm)
    @test_throws ErrorException UDUnits.Converter(unit_m,unit_kg)

    buf = IOBuffer()
    show(buf,unit_km)
    @test startswith(String(take!(buf)),"<Unit:")


    # converter
    conv = UDUnits.Converter(unit_cm,unit_m)
    @test UDUnits.convert(conv,100.) ≈ 1.
    @test UDUnits.expression(conv) == "0.01*x"

    buf = IOBuffer()
    show(buf,conv)
    @test startswith(String(take!(buf)),"<Converter:")


    unit_m3 = unit_m + 3
    conv = UDUnits.Converter(unit_m,unit_m3)
    @test UDUnits.convert(conv,100.) ≈ 97.

    unit_mm3 = unit_m - 3.
    conv = UDUnits.Converter(unit_m,unit_mm3)
    @test UDUnits.convert(conv,100.) ≈ 103.


    unit_m_per_s = unit_m/unit_s
    unit_km_per_h = unit_km/unit_h
    unit_Hz = 1/unit_s

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

    # Format strings
    unit_J_per_s = UDUnits.Unit(system,"J/s")

    @test UDUnits.format(unit_J_per_s) == "W"
    @test UDUnits.string(unit_J_per_s) == "W"

    @test UDUnits.format(unit_J_per_s; names = true) == "watt"
    @test UDUnits.format(unit_J_per_s; definition = true) == "m²·kg·s⁻³"
    @test UDUnits.format(unit_J_per_s; definition = true, names = true) ==
        "meter²·kilogram·second⁻³"



    # test clean-up
    unit_m = 0
    system = 0
    conv = 0
    GC.gc()
end
