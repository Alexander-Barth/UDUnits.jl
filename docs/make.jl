using Documenter
using UDUnits

makedocs(
    format = :html,
    modules = [UDUnits],
    sitename = "UDUnits",
    pages = [
        "index.md"]
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.

deploydocs(
    repo = "github.com/Alexander-Barth/UDUnits.jl.git",
    target = "build",
    julia  = "0.6",
    deps = nothing,
    make = nothing,
)
