# mwiexamples

Repository containing example usage for the package [MyelinWaterImaging.jl](https://github.com/jondeuce/MyelinWaterImaging.jl.git), an implementation of the Myelin Water Imaging (MWI) nonnegative least squares (NNLS) [toolbox](https://mriresearch.med.ubc.ca/news-projects/myelin-water-fraction/) written in the open-source [Julia programming language](https://julialang.org/).
Julia is a free, easy to install, and *fast* open-source programming language.
For an introduction to Julia, see the [Julia documentation](https://docs.julialang.org/en/v1.3/).

This repository provides a simple example script `my_script.jl` for using the command line interface provided by MyelinWaterImaging.jl (see below):

```bash
$ julia my_script.jl <COMMAND LINE ARGS>
```

For an illustration of why one may be interested in using MyelinWaterImaging.jl and/or Julia, here is a comparison of the T2-distribution computation times between Julia and MATLAB:

* 48 echo CPMG sequence, matrix size 240 x 240 x 48, using default parameters:
    * MATLAB: 2h:53m:13s
    * Julia: **4m:25s**
* 56 echo CPMG sequence, matrix size 240 x 240 x 113, using default parameters:
    * MATLAB: 9h:35m:17s
    * Julia: **14m:36s**

For more benchmarks, and for benchmarking details, see [MyelinWaterImaging.jl](https://github.com/jondeuce/MyelinWaterImaging.jl#benchmarks).

## Installation

### Cloning this repository

1. Clone `mwiexamples` using `git` from the command line by executing the following command in the terminal:

    ```bash
    $ git clone https://github.com/jondeuce/mwiexamples.git
    ```
2. Click the `Clone or download` button in the top right of this page to download a `.zip` file of the repository contents

### Installing Julia

To run these examples, Julia version 1.3.0 or higher is required:

1. Visit the [Julia downloads page](https://julialang.org/downloads/) and download Julia v1.3.0 or higher for your operating system.
2. After placing the downloaded folder (named e.g. `julia-1.3.0`) in an appropriate location, add the `julia` executable (located in e.g. `julia-1.3.0/bin/julia`) to your path

### Installing MyelinWaterImaging.jl

There are two ways to install MyelinWaterImaging.jl:

1.  Start `julia` from the command line, type `]` to enter the package manager REPL mode (the `julia>` prompt will be replaced by a `pkg>` prompt) and enter the following command:

    ```julia
    pkg> add https://github.com/jondeuce/MyelinWaterImaging.jl.git
    ```

    Once the package is finished installing, type the backspace key to exit the package manager REPL mode (the `julia>` prompt should reappear).
    Exit Julia using the keyboard shortcut `Ctrl+D`, or `⌘-D` on OSX, or by typing `exit()`.

2. Create a script which will automatically install MyelinWaterImaging.jl when used with the command line interface (see below).

## Command Line Interface (CLI)

This toolbox provides a command line interface (CLI) for processing from the terminal.
The CLI takes as input `.nii`, `.nii.gz`, or `.mat` files - or folders containing such files - and performs one or both of T2-distribution computation and T2-parts analysis, the latter of which performs post-processing of the T2-distribution to calculate parameters such as the myelin water fraction (MWF).
See the [documentation](https://jondeuce.github.io/MyelinWaterImaging.jl/dev/cli) for API details.

In order to call the command line interface one must first create a Julia script which loads MyelinWaterImaging.jl and calls the entrypoint function `main()`.
For example, the script `my_script.jl` provided by this repository contains a more heavily commented version of the following:

```julia
using Pkg # load the Julia package manager
if !in("MyelinWaterImaging", keys(Pkg.installed())) # check if installed
    Pkg.add(PackageSpec(url="https://github.com/jondeuce/MyelinWaterImaging.jl.git"))
end
using MyelinWaterImaging # load the package
main() # call command line interface
```

This script will automatically check if MyelinWaterImaging.jl needs to be installed.
If you have already installed MyelinWaterImaging.jl using the first installation option, the first four lines can be omitted.

### Basic usage

The most straightforward usage is to call `julia` on a script such as `my_script.jl` above, passing in the input image and command line flags directly:

```bash
$ export JULIA_NUM_THREADS=4
$ julia my_script.jl data/images/image-175x140x1x56.nii.gz --T2map --T2part --TE 0.007 --output output/basic/
```

The first line sets the environment variable `JULIA_NUM_THREADS` to enable multithreading within Julia.
The second line calls `julia` on `my_script.jl` as follows:

* The image file `data/images/image-175x140x1x56.nii.gz` is passed as the first argument
* The flags `--T2map` and `--T2part` are passed, indicating that both T2-distribution computation and T2-parts analysis (to compute e.g. the myelin water fraction) should be performed
* The flag `--TE` is passed with argument `0.007`, setting the echo time to 7ms
* The flag `--output` is passed with a folder `output/basic/`; T2-distribution and T2-parts results will be stored here

See the [arguments](https://jondeuce.github.io/MyelinWaterImaging.jl/dev/cli/#Arguments-1) section of the documentation for more information on command line arguments.

### Batch processing of input files

Multiple input files can be passed in for processing.
We can process all images in `data/images` as follows:

```bash
$ export JULIA_NUM_THREADS=4
$ julia my_script.jl data/images/ --T2map --T2part --TE 0.007 --output output/batchprocess/
```

These results will be stored in the folder `output/batchprocess/`.

### Passing parameters from a settings file

Flags and parameters can be passed in from settings file by prepending the `@` character to the path of the settings file.
Using the settings file in the `data/` folder, we can re-run the above example as follows:

```bash
$ export JULIA_NUM_THREADS=4
$ julia my_script.jl @data/example1/settings.txt
```

These results will be stored in the folder `output/example1/`, as detailed in the settings file `data/example1/settings.txt`.

### Example script

An example `bash` script `examples.sh` is provided by this repository which executes two example command line invocations, similar to those above.
The only requirement for this script to run is that the `julia` executable is on your path.
Run

```bash
$ ./examples.sh
```

at the terminal to execute the script.
Results will be stored in the `output/` directory.

## Documentation

[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://jondeuce.github.io/MyelinWaterImaging.jl/dev)

Documentation for the package MyelinWaterImaging.jl can be found at the above link with information such as:
* command line interface API and examples
* API reference detailing how to use MyelinWaterImaging.jl from within Julia
* other internals and algorithmic details
