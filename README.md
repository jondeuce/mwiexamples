# mwiexamples

<p align="left">
<img width="500px" src="https://github.com/jondeuce/DECAES.jl/blob/c2956262063841c8c2dc27f4e0ee20593ef32697/docs/src/assets/logo.gif">
</p>

This repository contains examples demonstrating usage of the DEcomposition and Component Analysis of Exponential Signals ([DECAES](https://bit.ly/DECAES)) tool,
a *fast* implementation of the [MATLAB toolbox](https://mriresearch.med.ubc.ca/news-projects/myelin-water-fraction/) from the [UBC MRI Research Centre](https://mriresearch.med.ubc.ca/) written in the open-source [Julia programming language](https://julialang.org/).
The source code for DECAES can be found at the [DECAES.jl package repository](https://github.com/jondeuce/DECAES.jl).
For an introduction to Julia, see the [Julia documentation](https://docs.julialang.org/en/v1/).

DECAES provides methods for computing voxelwise [T2-distributions](https://doi.org/10.1016/0022-2364(89)90011-5) of multi spin-echo MRI images using the extended phase graph algorithm with stimulated echo corrections.
Post-processing of these T2-distributions allows for the computation of measures such as the [myelin water fraction (MWF)](https://doi.org/10.1002/mrm.1910310614) used in myelin water imaging (MWI), or the [luminal water fraction (LWF)](https://doi.org/10.1148/radiol.2017161687) used in luminal water imaging (LWI).

### Documentation

[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://jondeuce.github.io/DECAES.jl/dev)

In-depth documentation for DECAES can be found at the above link with information such as:
* Command line interface API details
* Julia API reference for using DECAES from within Julia
* DECAES internals and algorithmic details

If you use DECAES in your research, please cite the following:

[![Z Med Phys](https://cdn.ncbi.nlm.nih.gov/corehtml/query/egifs/https:--linkinghub.elsevier.com-ihub-images-PubMedLink.gif)](https://doi.org/10.1016/j.zemedi.2020.04.001)

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

### Benchmarks

Due to performance optimizations enabled by Julia, DECAES is *fast*.
As an illustration, here is a comparison of the T2-distribution computation times between DECAES and the original MATLAB version:

<center>

| Dataset      | Image Size           | MATLAB      | Julia      |
| :---:        | :---:                | :---:       | :---:      |
| 48-echo CPMG | 240 x 240 x 48 x 48  | 1h:29m:35s  | **1m:24s** |
| 56-echo CPMG | 240 x 240 x 113 x 56 | 2h:25m:19s  | **2m:20s** |

</center>

For more benchmarks and for benchmarking details, see [DECAES.jl](https://github.com/jondeuce/DECAES.jl#benchmarks).

## Quickstart

### Command Line Interface

DECAES provides a [command line interface (CLI)](https://jondeuce.github.io/DECAES.jl/dev/cli) for performing exponential analysis of multi spin-echo images.
Input image files must be stored as NIfTI files (extension `.nii` or `.nii.gz`), MATLAB files (extension `.mat`), Philips PAR/REC file pairs (extensions `.par`/`.rec` or `.PAR`/`.REC`), or Philips XML/REC file pairs (extensions `.xml`/`.rec` or `.XML`/`.REC`).
If your data is in DICOM format, the [freely available `dcm2niix` tool](https://www.nitrc.org/plugins/mwiki/index.php/dcm2nii:MainPage) is able to convert both [DICOM](https://www.nitrc.org/plugins/mwiki/index.php/dcm2nii:MainPage#General_Usage) files into NIfTI format.

The interface for processing an image file is as follows:

```bash
$ julia --threads 4 -e 'using DECAES; main()' -- image.nii <COMMAND LINE ARGS>
```

Multithreaded parallel processing is enabled by setting the `julia` command line flag `--threads`, where `--threads N` enables parallel processing with `N` threads.
The file `image.nii` is the image to be processed, and the Julia code `using DECAES; main()` loads DECAES and the CLI entrypoint function.
Command line arguments are [introduced below](#command-line-interface), and detailed in the [documentation](https://jondeuce.github.io/DECAES.jl/dev/cli).

Alternatively, a Julia script `decaes.jl` is provided by this respository for convenience.
This script will load DECAES (installing it if necessary) and the CLI for you, and can be used as:

```bash
$ julia --threads 4 decaes.jl -- image.nii <COMMAND LINE ARGS>
```

All outputs are saved as `.mat` files; see the [documentation](https://jondeuce.github.io/DECAES.jl/dev/cli/#Outputs-1) for more information.

### MATLAB Interface

The DECAES CLI can be called from within MATLAB using the function `decaes.m` provided by this repository.
The below example processes `image.nii` using 4 threads; see the `decaes.m` function documentation for details:

```MATLAB
>> decaes('--threads', 4, 'image.nii', <COMMAND LINE ARGS>...) % function syntax
>> decaes --threads 4 image.nii <COMMAND LINE ARGS> % or equivalently, command syntax
```

**NOTE**: The examples in this README using the CLI are easily translated to MATLAB: simply replace command line statements such as `julia --threads 4 decaes.jl ...` with the equivalent MATLAB command `decaes --threads 4 ...`

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
2. Click the `Code -> Download ZIP` in the top right of this page to download a `.zip` file of the repository contents

### Downloading Julia

To use DECAES, Julia version 1.6.0 or higher is required:

1. Visit the [Julia downloads page](https://julialang.org/downloads/) and download Julia v1.6.0 or higher for your operating system (use the most up-to-date stable release of Julia for best performance)
2. After placing the downloaded folder (named e.g. `julia-1.6.0`) in an appropriate location, add the `julia` executable (located in e.g. `julia-1.6.0/bin/julia`) to your system path

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
Because of this, the first time DECAES is installed and run there may be several minutes of installation and compilation delay before processing starts.
Subsequent runs will be much faster; typically, 5-10 seconds are needed to start Julia and load DECAES before processing begins.

### Updating DECAES

DECAES is implemented as a Julia package, hosted at the [DECAES.jl repository](https://github.com/jondeuce/DECAES.jl.git), allowing DECAES to be updated through the Julia package manager.
To update DECAES, start `julia` from the command line, type `]` to enter the package manager REPL mode, and enter the following:

```julia
pkg> update DECAES
```

Or equivalently, enter the following command at the terminal:

```bash
$ julia -e 'import Pkg; Pkg.update("DECAES")'
```

## Command Line Interface (CLI)

The DECAES CLI aims to give users the ability to compute e.g. myelin water fraction maps from the command line and afterwards continue using the programming language of their choice.
As such, using the CLI does not require any knowledge of Julia, only the installation steps above need to be completed.
Indeed, as mentioned in the [Quickstart](@ref) section, one may call the CLI directly from within MATLAB using the `decaes.m` file provided by this repository.

DECAES takes images stored as NIfTI, MATLAB, PAR/REC, or XML/REC files as input and performs one or both of T2-distribution computation and T2-parts analysis, the latter of which performs post-processing of the T2-distribution to calculate parameters such as the myelin water fraction.
Data must be stored as (x, y, z, echo) for multi-echo input data, or (x, y, z, T2 bin) for T2-distribution input data.
See the [documentation](https://jondeuce.github.io/DECAES.jl/dev/cli) for more API details.

The examples to follow should be run from within the `mwiexamples` folder.

### Required parameters

Several parameters are required to perform myelin or luminal water imaging.
We have chosen to make the most important parameters required arguments.
They should be carefully chosen, and most importantly, used consistently when comparing results.

* The matrix size and number of echoes `MatrixSize` and `nTE`; these are inferred from the size of the input image
* The echo time `TE` (units: seconds). Must correspond to scanning protocol
* The number of T2 bins `nT2`. Typically, `nT2 = 40` will be a good default, but note that increasing `nT2` or otherwise decreasing the spacing between T2 values (such as by decreasing the width of `T2Range`) may require more regularization
* The range of T2 values `T2Range` (units: seconds). The lower bound should be on the order of `TE`, as T2 components much smaller than `TE` are not well captured by the CPMG signal. Similarly, the upper bound of the `T2Range` typically should not be much higher than a small multiple of the last sampled echo time `nTE * TE`, as arbitrarily high T2 values cannot be recovered
* The small and middle peak windows `SPWin` and `MPWin` (units: seconds):
    * For myelin water imaging, the myelin vs. intra/extra-cellular water cutoff should be chosen based on the T2 distribution. For example, plotting the mean T2 distribution over white matter voxels should reveal two distinct peaks from which a cutoff value can be chosen. Typical values may be `SPWin = [TE, 25e-3]` and `MPWin = [25e-3, 200e-3]`, where `SPWin` controls the myelin water window
    * Similar methods should be used for luminal water imaging. In LWI, `MPWin` controls the luminal water window. Typical values may be `SPWin = [TE, 200e-3]` and `MPWin = [200e-3, T2Range(2)]`, where `T2Range(2)` is the upper bound of `T2Range`
* The regularization method `Reg`. DECAES provides three methods to automatically determine the regularization constant `mu` used in the [Tikhonov regularization term](https://jondeuce.github.io/DECAES.jl/dev/#Introduction):
    * `"lcurve"`: choose `mu` by locating the point of [maximum curvature](https://arxiv.org/abs/1608.04571) on the [L-curve](https://epubs.siam.org/doi/10.1137/1034115); this method is parameter-free
    * `"gcv"`: choose `mu` using the [generalized cross-validation](https://amstat.tandfonline.com/doi/abs/10.1080/00401706.1979.10489751) (GCV) method; this method is parameter-free
    * `"chi2"`: choose `mu` such that the regularized solution increases the chi-squared goodness of fit by a specified ratio relative to the unregularized solution. This method requires an additional parameter `Chi2Factor`, typically equal to `1.01` or `1.02`, controlling the relative increase in chi-squared. See the [documentation](https://jondeuce.github.io/DECAES.jl/dev/ref/#DECAES.lsqnonneg_chi2)

### Basic usage

The most straightforward usage is to call `julia` on the `decaes.jl` script provided by this repository, passing the input image filename and analysis settings as command line arguments:

```bash
$ julia --threads 4 decaes.jl -- data/images/image-194x110x1x56.nii.gz \
  --T2map --T2part --TE 7e-3 --nT2 40 \
  --T2Range 10e-3 2.0 --SPWin 10e-3 25e-3 --MPWin 25e-3 200e-3 --Reg lcurve \
  --output output/basic/
```

* The 4D image file `data/images/image-194x110x1x56.nii.gz` is passed as the first argument
* The flags `--T2map` and `--T2part` are passed, indicating that both T2-distribution computation and T2-parts analysis (to compute e.g. the myelin water fraction) will be performed
* The flag `--TE` is passed with argument `7e-3`, setting the echo times to 7 ms, 14 ms, ...
* The flag `--nT2` is passed with argument `40`, setting the number of T2 components to 40
* The flag `--T2Range` is passed with argument `10e-3 2.0` to set the range of T2 values for the T2-distribution; the `--SPWin` and `--MPWin` flags similarly set the short peak and middle peak windows
* The flag `--Reg` is passed with argument `lcurve`, specifying that the L-curve regularization method will be used
* The flag `--output` is passed with argument `output/basic/`.
The folder `output/basic/` will be created if it does not already exist, and the T2-distribution and T2-parts results will be stored there as `.mat` files.

See the [arguments](https://jondeuce.github.io/DECAES.jl/dev/cli/#Arguments-1) section of the documentation for more information on command line arguments.

### Passing image masks

Image masks can be passed in for processing.
We can process the image file `data/images/image-194x110x8x56.nii.gz` using the brain mask `data/masks/image-194x110x8x56_mask.nii.gz` as follows:

```bash
$ julia --threads 4 decaes.jl -- data/images/image-194x110x8x56.nii.gz \
  --T2map --T2part --TE 7e-3 --nT2 40 \
  --T2Range 10e-3 2.0 --SPWin 10e-3 25e-3 --MPWin 25e-3 200e-3 --Reg gcv \
  --mask data/masks/image-194x110x8x56_mask.nii.gz \
  --output output/masked/
```

These results will be stored in the folder `output/masked/`.

### Processing multiple files

Multiple files can be passed in for processing.
Here, we process both images from the above examples, this time using brain masks for both images:

```bash
$ julia --threads 4 decaes.jl -- \
  data/images/image-194x110x1x56.nii.gz \
  data/images/image-194x110x8x56.nii.gz \
  --T2map --T2part --TE 7e-3 --nT2 40 \
  --T2Range 10e-3 2.0 --SPWin 10e-3 25e-3 --MPWin 25e-3 200e-3 --Reg chi2 --Chi2Factor 1.02 \
  --mask \
  data/masks/image-194x110x1x56_mask.nii.gz \
  data/masks/image-194x110x8x56_mask.nii.gz \
  --output output/multiple/
```

### Passing parameters from a settings file

Flags and parameters can be passed in from settings file by prepending the `@` character to the path of the settings file.
Using the settings files in the `data/` folder, we can re-run the above examples as follows:

```bash
$ julia --threads 4 decaes.jl -- @data/example1.txt
$ julia --threads 4 decaes.jl -- @data/example2.txt
$ julia --threads 4 decaes.jl -- @data/example3.txt
```

These results will be stored in the folders `output/example1/`, `output/example2/`, and `output/example3/`, as specified by the settings files.

The use of settings files is highly recommended for reproducibility and self-documentation, as a copy of the input settings file will be automatically saved in the output folder.
For more information on creating settings files, see the [documentation](https://jondeuce.github.io/DECAES.jl/dev/cli/#Settings-files-1).

### Example scripts

The scripts `examples.sh` and `examples.m` provided by this repository demonstrate the three example invocations of DECAES above.
The only requirement for these scripts to run is that the `julia` executable is on your system path and that DECAES is installed.
The scripts can also be easily modified to replace `julia` with `/path/to/julia` on your system, if necessary.

Running `./examples.sh` in the terminal or `examples` in MATLAB will execute the respective scripts.
Results will be stored in a directory `output/`.
