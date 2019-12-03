import Pkg
if !in("MyelinWaterImaging", keys(Pkg.installed()))
    Pkg.add("https://github.com/jondeuce/MyelinWaterImaging.jl.git")
end
using MyelinWaterImaging
main()
