push!(LOAD_PATH, "../src/")
using BacteriaBasedModels

using Documenter

makedocs(
    sitename = "BacteriaBasedModels.jl",
    modules = [BacteriaBasedModels],
    pages = [
        "Home" => "index.md",
        "Tutorial" => "tutorial.md"
        "Validation" => "checks.md"
    ]
)

deploydocs(;
    repo = "github.com/mastrof/BacteriaBasedModels"
)