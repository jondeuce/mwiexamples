# Load the Julia package manager, which is itself a Julia package
using Pkg

# Check if DECAES.jl has already been installed
if !in("DECAES", keys(Pkg.installed()))
    # Install DECAES.jl from the github repository
    Pkg.add(
        PackageSpec(
            url = "https://github.com/jondeuce/DECAES.jl.git"
        )
    )
end

# Load DECAES.jl
using DECAES

# Call the command line interface entrypoint function
main()
