using BinDeps
import CondaBinDeps


@BinDeps.setup
libudunits2 = library_dependency("libudunits2", aliases = ["udunits2","udunits"])

CondaBinDeps.Conda.add_channel("conda-forge")
provides(CondaBinDeps.Manager, "udunits2", libudunits2)
provides(AptGet, "libudunits2-dev", libudunits2, os = :Linux)
provides(Yum, "udunits2-devel", libudunits2, os = :Linux)

@BinDeps.install Dict(:libudunits2 => :libudunits2)
