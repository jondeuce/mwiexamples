# Load the Julia package manager, which is itself a Julia package
using Pkg

# Check if MyelinWaterImaging.jl has already been installed
if !in("MyelinWaterImaging", keys(Pkg.installed()))
    # Install MyelinWaterImaging.jl from the github repository
    Pkg.add(
        PackageSpec(
            url = "https://github.com/jondeuce/MyelinWaterImaging.jl.git"
        )
    )
end

# Load MyelinWaterImaging.jl
using MyelinWaterImaging

# Call the command line interface entrypoint function
main()
