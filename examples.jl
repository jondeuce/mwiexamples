# Import the Julia package manager, which is itself a package
import Pkg

# Activate the project in the current directory. This uses
# the Project.toml and Manifest.toml files in this directory
# to create a reproducible local Julia project.
Pkg.activate(@__DIR__)

# Instantiate the current project. This downloads and installs
# the packages in the current environment, but only as necessary.
Pkg.instantiate()

# Call the main entrypoint function from MyelinWaterImaging.jl
using MyelinWaterImaging
main()
