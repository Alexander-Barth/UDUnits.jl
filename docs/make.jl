using Documenter
using UDUnits

makedocs(
    format = Documenter.HTML(),
    modules = [UDUnits],
    sitename = "UDUnits",
    pages = [
        "index.md"]
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.

deploydocs(
    repo = "github.com/Alexander-Barth/UDUnits.jl.git"
)
