# mwiexamples

This repository contains examples demonstrating usage of the DEcomposition and Component Analysis of Exponential Signals ([DECAES](https://github.com/jondeuce/DECAES.jl.git)) tool,
a *fast* implementation of the [MATLAB toolbox](https://mriresearch.med.ubc.ca/news-projects/myelin-water-fraction/) from the [UBC MRI Research Centre](https://mriresearch.med.ubc.ca/) written in the open-source [Julia programming language](https://julialang.org/).
For an introduction to Julia, see the [Julia documentation](https://docs.julialang.org/en/v1.3/).

DECAES provides methods for computing voxelwise [T2-distributions](https://doi.org/10.1016/0022-2364(89)90011-5) of multi spin-echo MRI images using the extended phase graph algorithm with stimulated echo corrections.
Post-processing of these T2-distributions allows for the computation of measures such as the [myelin water fraction (MWF)](https://doi.org/10.1002/mrm.1910310614) used in myelin water imaging (MWI), or the [luminal water fraction (LWF)](https://doi.org/10.1148/radiol.2017161687) used in luminal water imaging (LWI).

### Benchmarks

Due to performance optimizations enabled by Julia, DECAES is *fast*.
As an illustration, here is a comparison of the T2-distribution computation times between DECAES and the original MATLAB version:

<center>

| Dataset      | Image Size           | MATLAB      | Julia      |
| :---:        | :---:                | :---:       | :---:      |
| 48-echo CPMG | 240 x 240 x 48 x 48  | 1h:29m:35s  | **1m:24s** |
| 56-echo CPMG | 240 x 240 x 113 x 48 | 2h:25m:19s  | **2m:20s** |

</center>

For more benchmarks and for benchmarking details, see [DECAES.jl](https://github.com/jondeuce/DECAES.jl#benchmarks).

## Quickstart

### Command Line Interface

DECAES provides a [command line interface (CLI)](https://jondeuce.github.io/DECAES.jl/dev/cli) for performing exponential analysis of multi spin-echo images.
Input image files must be stored as NIfTI files (extension `.nii` or `.nii.gz`), MATLAB files (extension `.mat`), Philips PAR/REC file pairs (extensions `.par`/`.rec` or `.PAR`/`.REC`), or Philips XML/REC file pairs (extensions `.xml`/`.rec` or `.XML`/`.REC`).
If your data is in DICOM format, the [freely available `dcm2niix` tool](https://www.nitrc.org/plugins/mwiki/index.php/dcm2nii:MainPage) is able to convert both [DICOM](https://www.nitrc.org/plugins/mwiki/index.php/dcm2nii:MainPage#General_Usage) files into NIfTI format.

The interface for processing an image file is as follows:

```bash
$ julia -e 'using DECAES; main()' image.nii <COMMAND LINE ARGS>
```

where `image.nii` is the image file to be processed, and `using DECAES; main()` loads DECAES and the CLI.
Command line arguments are introduced below, and detailed in the [documentation](https://jondeuce.github.io/DECAES.jl/dev/cli).

Alternatively, a Julia script `decaes.jl` is provided by this respository for convenience.
This script will load DECAES (installing it if necessary) and the CLI for you, and can be used as:

```bash
$ julia decaes.jl image.nii <COMMAND LINE ARGS>
```

All outputs are saved as `.mat` files.

### MATLAB Interface

The DECAES CLI can be called from within MATLAB using the function `decaes.m` provided by this repository.
The below example processes `image.nii` using 4 threads; see the `decaes.m` function documentation for details:

```MATLAB
> decaes(4, 'image.nii', <COMMAND LINE ARGS>...) % function syntax
> decaes 4 image.nii <COMMAND LINE ARGS> % or equivalently, command syntax
```

## Installation

### (Optional) cloning this repository

Cloning this repository is not necessary to use DECAES.
However, this repository provides the following items which may prove useful to new users of the package:
* Example MWI data, brain masks, and a corresponding `examples.sh` script illustrating how to process the example data
* The `decaes.jl` convenience script for installing DECAES and calling the DECAES CLI
* The `decaes.m` MATLAB function for installing DECAES and calling DECAES from MATLAB

There are two ways to clone this repository:

1. Clone `mwiexamples` using `git` from the command line by executing the following command in the terminal:

    ```bash
    $ git clone https://github.com/jondeuce/mwiexamples.git
    ```
2. Click the `Clone or download` button in the top right of this page to download a `.zip` file of the repository contents

### Downloading Julia

To use DECAES, Julia version 1.3.0 or higher is required:

1. Visit the [Julia downloads page](https://julialang.org/downloads/) and download Julia v1.3.0 or higher for your operating system (use the most up-to-date stable release of Julia for best performance)
2. After placing the downloaded folder (named e.g. `julia-1.3.0`) in an appropriate location, add the `julia` executable (located in e.g. `julia-1.3.0/bin/julia`) to your system path

Julia 1.3.0 introduced [multithreading capabilities](https://julialang.org/blog/2019/07/multithreading) - used by DECAES - that greatly reduce computation time, hence the version requirement.

### Installing DECAES

There are two ways to install DECAES:

1. Use the example script `decaes.jl` or MATLAB function `decaes.m` provided by this repository; DECAES will automatically be installed (if necessary) when used through these interfaces

2.  Start `julia` from the command line, type `]` to enter the package manager REPL mode (the `julia>` prompt will be replaced by a `pkg>` prompt), and enter the following command:

    ```julia
    pkg> add DECAES
    ```

    Once the package is finished installing, type the backspace key to exit the package manager REPL mode (the `julia>` prompt should reappear).
    Exit Julia using the keyboard shortcut `Ctrl+D`, or by typing `exit()`.

**NOTE**: Julia is a ["just-ahead-of-time" compiled language](https://www.youtube.com/watch?v=7KGZ_9D_DbI), residing in between ahead-of-time (AOT) and just-in-time (JIT) compiled languages.
Because of this, the first time DECAES is installed and run there will be several minutes of installation and compilation delay before processing starts.
Subsequent runs will be much faster; approximately 10 seconds is needed to start Julia and load DECAES before processing.

## Command Line Interface (CLI)

The DECAES CLI aims to give users the ability to compute e.g. myelin water fraction maps from the command line and afterwards continue using the programming language of their choice.
As such, using the CLI does not require any knowledge of Julia, only the installation steps above need to be completed.
Indeed, as mentioned in the [Quickstart](@ref) section, one may call the CLI directly from within MATLAB using the `decaes.m` file provided by this repository.

DECAES takes images stored as NIfTI, MATLAB, PAR/REC, or XML/REC files as input and performs one or both of T2-distribution computation and T2-parts analysis, the latter of which performs post-processing of the T2-distribution to calculate parameters such as the myelin water fraction.
Data must be stored as (x, y, z, echo) for multi-echo input data, or (x, y, z, T2 bin) for T2-distribution input data.
See the [documentation](https://jondeuce.github.io/DECAES.jl/dev/cli) for more API details.

The following examples can be run from within the `mwiexamples` folder.

### Basic usage

The most straightforward usage is to call `julia` on the `decaes.jl` script provided by this repository, passing the input image filename and analysis settings as command line arguments:

```bash
$ export JULIA_NUM_THREADS=4
$ julia decaes.jl data/images/image-194x110x1x56.nii.gz \
  --T2map --T2part --TE 7e-3 \
  --T2Range 10e-3 2.0 --SPWin 10e-3 40e-3 --MPWin 40e-3 200e-3 \
  --output output/basic/
```

The first line sets the environment variable `JULIA_NUM_THREADS` to enable multithreading within Julia (4 threads in this example).
On Windows systems, the keyword `set` should be used instead of `export`; see the [Julia documentation](https://docs.julialang.org/en/v1/manual/parallel-computing/#Setup-1).

The second line calls `julia` on `decaes.jl` as follows:

* The 4D image file `data/images/image-194x110x1x56.nii.gz` is passed as the first argument
* The flags `--T2map` and `--T2part` are passed, indicating that both T2-distribution computation and T2-parts analysis (to compute e.g. the myelin water fraction) should be performed
* The flag `--TE` is passed with argument `7e-3`, setting the echo times to 7 ms, 14 ms, ...
* The flag `--T2Range` is passed with argument `10e-3 2.0` to set the range of T2 values for the T2-distribution; the `--SPWin` and `--MPWin` flags similarly set the short peak and middle peak windows
* The flag `--output` is passed with argument `output/basic/`.
The folder `output/basic/` will be created if it does not already exist, and the T2-distribution and T2-parts results will be stored there as `.mat` files.

See the [arguments](https://jondeuce.github.io/DECAES.jl/dev/cli/#Arguments-1) section of the documentation for more information on command line arguments.

### Passing image masks

Image masks can be passed in for processing.
We can process the image file `data/images/image-194x110x8x56.nii.gz` using the brain mask `data/masks/image-194x110x8x56_mask.nii.gz` as follows:

```bash
$ export JULIA_NUM_THREADS=4
$ julia decaes.jl data/images/image-194x110x8x56.nii.gz \
  --T2map --T2part --TE 7e-3 \
  --T2Range 10e-3 2.0 --SPWin 10e-3 40e-3 --MPWin 40e-3 200e-3 \
  --mask data/masks/image-194x110x8x56_mask.nii.gz \
  --output output/masked/
```

These results will be stored in the folder `output/masked/`.

### Processing multiple files

Multiple files can be passed in for processing.
Here, we process both images from the above examples, this time using brain masks for both images:

```bash
$ export JULIA_NUM_THREADS=4
$ julia decaes.jl \
  data/images/image-194x110x1x56.nii.gz \
  data/images/image-194x110x8x56.nii.gz \
  --T2map --T2part --TE 7e-3 \
  --T2Range 10e-3 2.0 --SPWin 10e-3 40e-3 --MPWin 40e-3 200e-3 \
  --mask \
  data/masks/image-194x110x1x56_mask.nii.gz \
  data/masks/image-194x110x8x56_mask.nii.gz \
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

An example `bash` script `examples.sh` is provided which executes the three example command line invocations of DECAES above.
The only requirement for this script to run is that the `julia` executable is on your system path and that DECAES is installed.
The script can also be modified to replace `julia` with `/path/to/julia` on your system.

Running the following at the terminal will execute the script:

```bash
$ ./examples.sh
```

Results will be stored in the `output/` directory.

## Updating DECAES

DECAES is implemented as a Julia package, hosted at the [DECAES.jl repository](https://github.com/jondeuce/DECAES.jl.git), allowing DECAES to be updated through the Julia package manager.
To update DECAES, start `julia` from the command line, type `]` to enter the package manager REPL mode, and enter the following:

```julia
pkg> update DECAES
```

Or equivalently, enter the following command at the terminal:

```bash
$ julia -E 'import Pkg; Pkg.update("DECAES")'
```

## Documentation

[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://jondeuce.github.io/DECAES.jl/dev)

In-depth documentation for DECAES can be found at the above link with information such as:
* Command line interface API and examples
* API reference detailing how to use DECAES from within Julia
* Other internals and algorithmic details

## Citing this work

[![Z Med Phys](https://cdn.ncbi.nlm.nih.gov/corehtml/query/egifs/https:--linkinghub.elsevier.com-ihub-images-PubMedLink.gif)](https://doi.org/10.1016/j.zemedi.2020.04.001)

If you use DECAES in your research, please cite the following:

```tex
@article{DECAES.jl-2020,
  title = {{{DECAES}} - {{DEcomposition}} and {{Component Analysis}} of {{Exponential Signals}}},
  author = {Doucette, Jonathan and Kames, Christian and Rauscher, Alexander},
  year = {2020},
  month = may,
  issn = {1876-4436},
  doi = {10.1016/j.zemedi.2020.04.001},
  journal = {Zeitschrift Fur Medizinische Physik},
  keywords = {Brain,Luminal Water Imaging,MRI,Myelin Water Imaging,Prostate},
  language = {eng},
  pmid = {32451148}
}
```
