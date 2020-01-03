# mwiexamples

This repository contains examples demonstrating usage of the package [MyelinWaterImaging.jl](https://github.com/jondeuce/MyelinWaterImaging.jl.git), an implementation of the Myelin Water Imaging (MWI) nonnegative least squares (NNLS) [toolbox](https://mriresearch.med.ubc.ca/news-projects/myelin-water-fraction/) written in the open-source [Julia programming language](https://julialang.org/).
Julia is a free, easy to install, and *fast* open-source programming language.
For an introduction to Julia, see the [Julia documentation](https://docs.julialang.org/en/v1.3/).

## Quickstart

MyelinWaterImaging.jl provides a [command line interface (CLI)](https://jondeuce.github.io/MyelinWaterImaging.jl/dev/cli) for performing exponential analysis of multi spin-echo images stored as `.mat`, `.nii`, or `.nii.gz` files.

For example, to process the file `image.nii` (command line arguments detailed below):

```bash
$ julia -e 'using MyelinWaterImaging; main()' image.nii <COMMAND LINE ARGS>
```

where `using MyelinWaterImaging; main()` loads MyelinWaterImaging.jl and the CLI.
These commands can also be placed in a script for convenience.
Using the Julia script `decstr.jl` from this respository:

```bash
$ julia decstr.jl image.nii <COMMAND LINE ARGS>
```

### MATLAB Interface

The MyelinWaterImaging.jl CLI can be called from within MATLAB using the MATLAB function `decstr.m` provided by this repository.
The below example processes `image.nii` using 4 threads; see the `decstr.m` documentation for details:

```bash
> decstr 4 image.nii <COMMAND LINE ARGS>
```

### Benchmarks

Thanks to Julia, MyelinWaterImaging.jl is *fast*.
As an illustration, here is a comparison of the T2-distribution computation times between Julia and the prior MATLAB version:

<center>

| Dataset      | Image Size           | MATLAB      | Julia      |
| :---:        | :---:                | :---:       | :---:      |
| 48-echo CPMG | 240 x 240 x 48 x 48  | 1h:29m:35s  | **1m:50s** |
| 56-echo CPMG | 240 x 240 x 113 x 48 | 2h:25m:19s  | **3m:19s** |

</center>

For more benchmarks, and for benchmarking details, see [MyelinWaterImaging.jl](https://github.com/jondeuce/MyelinWaterImaging.jl#benchmarks).

## Installation

### (Optional) cloning this repository

Cloning this repository is not necessary to use MyelinWaterImaging.jl.
This repository provides example MWI data, the convenience script `decstr.jl` for calling the MyelinWaterImaging.jl CLI, and the `decstr.m` MATLAB file for calling MyelinWaterImaging.jl from MATLAB.

There are two ways to clone this repository:

1. Clone `mwiexamples` using `git` from the command line by executing the following command in the terminal:

    ```bash
    $ git clone https://github.com/jondeuce/mwiexamples.git
    ```
2. Click the `Clone or download` button in the top right of this page to download a `.zip` file of the repository contents

### Downloading Julia

To use MyelinWaterImaging.jl, Julia version 1.3.0 or higher is required:

1. Visit the [Julia downloads page](https://julialang.org/downloads/) and download Julia v1.3.0 or higher for your operating system.
2. After placing the downloaded folder (named e.g. `julia-1.3.0`) in an appropriate location, add the `julia` executable (located in e.g. `julia-1.3.0/bin/julia`) to your path

Julia 1.3.0 introduced [multithreading capabilities](https://julialang.org/blog/2019/07/multithreading) - used by MyelinWaterImaging.jl - that greatly reduce computation time, hence the version requirement.

### Installing MyelinWaterImaging.jl

There are two ways to install MyelinWaterImaging.jl:

1.  Start `julia` from the command line, type `]` to enter the package manager REPL mode (the `julia>` prompt will be replaced by a `pkg>` prompt) and enter the following command:

    ```julia
    pkg> add https://github.com/jondeuce/MyelinWaterImaging.jl.git
    ```

    Once the package is finished installing, type the backspace key to exit the package manager REPL mode (the `julia>` prompt should reappear).
    Exit Julia using the keyboard shortcut `Ctrl+D`, or by typing `exit()`.

2. Use the example script `decstr.jl` provided by this repository which will automatically install MyelinWaterImaging.jl, if necessary, when used with the command line interface (see below).

## Command Line Interface (CLI)

This toolbox provides a command line interface (CLI) for performing multi-exponential analysis from the terminal.
Using the CLI does not require any knowledge of Julia, only the installation steps above need to be completed.
Indeed, as mentioned in the [Quickstart](@ref) section, one may call the CLI directly from within MATLAB using the `decstr.m` file provided by this repository.
The CLI aims to give users the ability to compute e.g. myelin water fraction maps from the command line (or using `decstr.m`) and afterwards continue using the programming language of their choice.

The CLI takes as input `.nii`, `.nii.gz`, or `.mat` files (or folders containing such files) and performs one or both of T2-distribution computation and T2-parts analysis, the latter of which performs post-processing of the T2-distribution to calculate parameters such as the myelin water fraction.
Data must be stored as (x, y, z, echo) for multi-echo input data, or (x, y, z, T2 bin) for T2-distribution input data.
See the [documentation](https://jondeuce.github.io/MyelinWaterImaging.jl/dev/cli) for more API details.

In order to call the command line interface one may first wish to create a Julia script which loads MyelinWaterImaging.jl and calls the entrypoint function `main()`.
For example, the script `decstr.jl` provided by this repository contains a more heavily commented version of the following (plus some omitted lines which install MyelinWaterImaging.jl if necessary):

```julia
using MyelinWaterImaging # load the package
main() # call command line interface
```

## Examples

The following examples can be run from within the `mwiexamples` folder.

### Basic usage

The most straightforward usage is to call `julia` on a script such as `decstr.jl` above, passing in the input image and command line flags directly:

```bash
$ export JULIA_NUM_THREADS=4
$ julia decstr.jl data/images/image-175x140x1x56.nii.gz --T2map --T2part --TE 0.007 --output output/basic/
```

The first line sets the environment variable `JULIA_NUM_THREADS` to enable multithreading within Julia (4 threads in this example).
On Windows systems, the keyword `set` should be used instead of `export`; see the [Julia documentation](https://docs.julialang.org/en/v1/manual/parallel-computing/#Setup-1).

The second line calls `julia` on `decstr.jl` as follows:

* The 4D image file `data/images/image-175x140x1x56.nii.gz` is passed as the first argument
* The flags `--T2map` and `--T2part` are passed, indicating that both T2-distribution computation and T2-parts analysis (to compute e.g. the myelin water fraction) should be performed
* The flag `--TE` is passed with argument `0.007`, setting the echo times to 7 ms, 14 ms, ...
* The flag `--output` is passed with argument `output/basic/`.
The folder `output/basic` will be created and the T2-distribution and T2-parts results will be stored there.

See the [arguments](https://jondeuce.github.io/MyelinWaterImaging.jl/dev/cli/#Arguments-1) section of the documentation for more information on command line arguments.

### Batch processing of input files

Multiple input files can be passed in for processing.
We can process all images in `data/images` as follows:

```bash
$ export JULIA_NUM_THREADS=4
$ julia decstr.jl data/images/ --T2map --T2part --TE 0.007 --output output/batchprocess/
```

These results will be stored in the folder `output/batchprocess/`.

### Passing parameters from a settings file

Flags and parameters can be passed in from settings file by prepending the `@` character to the path of the settings file.
Using the settings file in the `data/example1/` folder, we can re-run the above example as follows:

```bash
$ export JULIA_NUM_THREADS=4
$ julia decstr.jl @data/example1/settings.txt
```

These results will be stored in the folder `output/example1/`, as specified by the settings file `data/example1/settings.txt`.

For more information on creating settings files, see the [documentation](https://jondeuce.github.io/MyelinWaterImaging.jl/dev/cli/#Settings-files-1).

### Example script

An example `bash` script `examples.sh` is provided which executes two example command line invocations.
The only requirement for this script to run is that the `julia` executable is on your path.
Running

```bash
$ ./examples.sh
```

at the terminal will execute the script.
Results will be stored in the `output/` directory.

## Documentation

[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://jondeuce.github.io/MyelinWaterImaging.jl/dev)

In-depth documentation for MyelinWaterImaging.jl can be found at the above link with information such as:
* command line interface API and examples
* API reference detailing how to use MyelinWaterImaging.jl from within Julia
* other internals and algorithmic details
