# mwiexamples

This repository contains examples demonstrating usage of the DEcomposition and Component Analysis of Exponential Signals (DECAES) tool [DECAES.jl](https://github.com/jondeuce/DECAES.jl.git),
a *fast* implementation of the [MATLAB toolbox](https://mriresearch.med.ubc.ca/news-projects/myelin-water-fraction/) from the [UBC MRI Research Centre](https://mriresearch.med.ubc.ca/) written in the open-source [Julia programming language](https://julialang.org/).
For an introduction to Julia, see the [Julia documentation](https://docs.julialang.org/en/v1.3/).

DECAES.jl provides methods for computing voxelwise [T2-distributions](https://doi.org/10.1016/0022-2364(89)90011-5) of multi spin-echo MRI images using the extended phase graph algorithm with stimulated echo corrections.
Post-processing of these T2-distributions allows for the computation of measures such as the [myelin water fraction (MWF)](https://doi.org/10.1002/mrm.1910310614) used in myelin water imaging (MWI), or the [luminal water fraction (LWF)](https://doi.org/10.1148/radiol.2017161687) used in luminal water imaging (LWI).

## Quickstart

DECAES.jl provides a [command line interface (CLI)](https://jondeuce.github.io/DECAES.jl/dev/cli) for performing exponential analysis of multi spin-echo images stored as `.mat`, `.nii`, or `.nii.gz` files.

For example, to process the file `image.nii` (command line arguments detailed below):

```bash
$ julia -e 'using DECAES; main()' image.nii <COMMAND LINE ARGS>
```

where `using DECAES; main()` loads DECAES.jl and the CLI.
These commands can also be placed in a script for convenience.
For example, using the Julia script `decaes.jl` from this respository:

```bash
$ julia decaes.jl image.nii <COMMAND LINE ARGS>
```

All outputs are saved as `.mat` files.

### MATLAB Interface

The DECAES.jl CLI can be called from within MATLAB using the function `decaes.m` provided by this repository.
The below example processes `image.nii` using 4 threads; see the `decaes.m` function documentation for details:

```MATLAB
> decaes(4, 'image.nii', <COMMAND LINE ARGS>...) % function syntax
> decaes 4 image.nii <COMMAND LINE ARGS> % or equivalently, command syntax
```

### Benchmarks

Due to performance optimizations enabled by Julia, DECAES.jl is *fast*.
As an illustration, here is a comparison of the T2-distribution computation times between DECAES.jl and the original MATLAB version:

<center>

| Dataset      | Image Size           | MATLAB      | Julia      |
| :---:        | :---:                | :---:       | :---:      |
| 48-echo CPMG | 240 x 240 x 48 x 48  | 1h:29m:35s  | **1m:50s** |
| 56-echo CPMG | 240 x 240 x 113 x 48 | 2h:25m:19s  | **3m:19s** |

</center>

For more benchmarks and for benchmarking details, see [DECAES.jl](https://github.com/jondeuce/DECAES.jl#benchmarks).

## Installation

### (Optional) cloning this repository

Cloning this repository is not necessary to use DECAES.jl.
However, this repository provides the following items which may prove useful to new users of the package:
* Example MWI data, brain masks, and a corresponding `examples.sh` script illustrating how to process the example data
* The `decaes.jl` convenience script for calling the DECAES.jl CLI
* The `decaes.m` MATLAB function for calling DECAES.jl from MATLAB

There are two ways to clone this repository:

1. Clone `mwiexamples` using `git` from the command line by executing the following command in the terminal:

    ```bash
    $ git clone https://github.com/jondeuce/mwiexamples.git
    ```
2. Click the `Clone or download` button in the top right of this page to download a `.zip` file of the repository contents

### Downloading Julia

To use DECAES.jl, Julia version 1.3.0 or higher is required:

1. Visit the [Julia downloads page](https://julialang.org/downloads/) and download Julia v1.3.0 or higher for your operating system.
2. After placing the downloaded folder (named e.g. `julia-1.3.0`) in an appropriate location, add the `julia` executable (located in e.g. `julia-1.3.0/bin/julia`) to your system path

Julia 1.3.0 introduced [multithreading capabilities](https://julialang.org/blog/2019/07/multithreading) - used by DECAES.jl - that greatly reduce computation time, hence the version requirement.

### Installing DECAES.jl

There are two ways to install DECAES.jl:

1.  Start `julia` from the command line, type `]` to enter the package manager REPL mode (the `julia>` prompt will be replaced by a `pkg>` prompt), and enter the following command:

    ```julia
    pkg> add https://github.com/jondeuce/DECAES.jl.git
    ```

    Once the package is finished installing, type the backspace key to exit the package manager REPL mode (the `julia>` prompt should reappear).
    Exit Julia using the keyboard shortcut `Ctrl+D`, or by typing `exit()`.

2. Use the example script `decaes.jl` provided by this repository which will automatically install DECAES.jl (if necessary) when used with the command line interface (see below).

## Command Line Interface (CLI)

This toolbox provides a command line interface (CLI) for performing multi-exponential analysis from the terminal.
The CLI aims to give users the ability to compute e.g. myelin water fraction maps from the command line and afterwards continue using the programming language of their choice.
As such, using the CLI does not require any knowledge of Julia, only the installation steps above need to be completed.
In fact, as mentioned in the [Quickstart](@ref) section, one may call the CLI directly from within MATLAB using the `decaes.m` file provided by this repository.

The CLI takes as input `.nii`, `.nii.gz`, or `.mat` files and performs one or both of T2-distribution computation and T2-parts analysis, the latter of which performs post-processing of the T2-distribution to calculate parameters such as the myelin water fraction.
Data must be stored as (x, y, z, echo) for multi-echo input data, or (x, y, z, T2 bin) for T2-distribution input data.
See the [documentation](https://jondeuce.github.io/DECAES.jl/dev/cli) for more API details.

In order to call the command line interface one may first wish to create a Julia script which loads DECAES.jl and calls the entrypoint function `main()`.
For example, the script `decaes.jl` provided by this repository contains a more heavily commented version of the following (plus some omitted lines which install DECAES.jl if necessary):

```julia
using DECAES # load the package
main() # call command line interface
```

## Examples

The following examples can be run from within the `mwiexamples` folder.

### Basic usage

The most straightforward usage is to call `julia` on a script such as `decaes.jl`, described above, and pass in the input image filename and command line flags directly:

```bash
$ export JULIA_NUM_THREADS=4
$ julia decaes.jl data/images/image-175x140x1x56.nii.gz \
  --T2map --T2part --TE 0.007 \
  --output output/basic/
```

The first line sets the environment variable `JULIA_NUM_THREADS` to enable multithreading within Julia (4 threads in this example).
On Windows systems, the keyword `set` should be used instead of `export`; see the [Julia documentation](https://docs.julialang.org/en/v1/manual/parallel-computing/#Setup-1).

The second line calls `julia` on `decaes.jl` as follows:

* The 4D image file `data/images/image-175x140x1x56.nii.gz` is passed as the first argument
* The flags `--T2map` and `--T2part` are passed, indicating that both T2-distribution computation and T2-parts analysis (to compute e.g. the myelin water fraction) should be performed
* The flag `--TE` is passed with argument `0.007`, setting the echo times to 7 ms, 14 ms, ...
* The flag `--output` is passed with argument `output/basic/`.
The folder `output/basic/` will be created if it does not already exist, and the T2-distribution and T2-parts results will be stored there.

See the [arguments](https://jondeuce.github.io/DECAES.jl/dev/cli/#Arguments-1) section of the documentation for more information on command line arguments.

### Passing image masks

Image masks can be passed in for processing.
We can process the image file `data/images/image-175x140x8x56.nii.gz` using the brain mask `data/masks/image-175x140x8x56_mask.nii.gz` as follows:

```bash
$ export JULIA_NUM_THREADS=4
$ julia decaes.jl data/images/image-175x140x8x56.nii.gz \
  --T2map --T2part --TE 0.007 \
  --mask data/masks/image-175x140x8x56_mask.nii.gz \
  --output output/masked/
```

These results will be stored in the folder `output/masked/`.

### Processing multiple files

Multiple files can be passed in for processing.
Here, we process both images from the above examples, this time using brain masks for both images:

```bash
$ export JULIA_NUM_THREADS=4
$ julia decaes.jl data/images/image-175x140x1x56.nii.gz \
  data/images/image-175x140x8x56.nii.gz \
  --T2map --T2part --TE 0.007 \
  --mask data/masks/image-175x140x1x56_mask.nii.gz \
  data/masks/image-175x140x8x56_mask.nii.gz \
  --output output/multiple/
```

### Passing parameters from a settings file

Flags and parameters can be passed in from settings file by prepending the `@` character to the path of the settings file.
Using the settings files in the `data/` folder, we can re-run the above examples as follows:

```bash
$ export JULIA_NUM_THREADS=4
$ julia decaes.jl @data/example1.txt
$ julia decaes.jl @data/example2.txt
$ julia decaes.jl @data/example3.txt
```

These results will be stored in the folders `output/example1/`, `output/example2/`, and `output/example3/`, as specified by the settings files.

The use of settings files is highly recommended for reproducibility and self-documentation, as a copy of the input settings file will be automatically saved in the output folder.
For more information on creating settings files, see the [documentation](https://jondeuce.github.io/DECAES.jl/dev/cli/#Settings-files-1).

### Example script

An example `bash` script `examples.sh` is provided which executes the three example command line invocations of DECAES.jl above.
The only requirement for this script to run is that the `julia` executable is on your system path and that DECAES.jl is installed.
The script can also be modified to replace `julia` with `/path/to/julia` on your system.

Running the following at the terminal will execute the script:

```bash
$ ./examples.sh
```

Results will be stored in the `output/` directory.

## Documentation

[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://jondeuce.github.io/DECAES.jl/dev)

In-depth documentation for DECAES.jl can be found at the above link with information such as:
* Command line interface API and examples
* API reference detailing how to use DECAES.jl from within Julia
* Other internals and algorithmic details
