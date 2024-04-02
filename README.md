# mwiexamples

<p align="left"> <img width="500px" src="https://github.com/jondeuce/DECAES.jl/blob/master/docs/src/assets/logo.gif"> </p>

This repository contains examples demonstrating usage of the DEcomposition and Component Analysis of Exponential Signals ([DECAES](https://bit.ly/DECAES)) tool,
a *fast* implementation of the [MATLAB toolbox](https://mriresearch.med.ubc.ca/news-projects/myelin-water-fraction/) from the [UBC MRI Research Centre](https://mriresearch.med.ubc.ca/) written in the open-source [Julia programming language](https://julialang.org/).
The source code for DECAES can be found at the [DECAES.jl package repository](https://github.com/jondeuce/DECAES.jl).
For an introduction to Julia, see the [Julia documentation](https://docs.julialang.org/en/v1/).

DECAES provides methods for performing *fast* multiexponential analysis tailored to magnetic resonance imaging (MRI) applications.
Voxelwise [T2-distributions](https://doi.org/10.1016/0022-2364(89)90011-5) of multi spin-echo MRI images are computed by projecting measured MR signals onto basis signals using regularized nonnegative least-squares (NNLS); basis signals are computed using the extended phase graph (EPG) algorithm with additional stimulated echo correction.
Post-processing these T2-distributions allows for computating measures such as the [myelin water fraction (MWF)](https://doi.org/10.1002/mrm.1910310614) used in myelin water imaging (MWI) and the [luminal water fraction (LWF)](https://doi.org/10.1148/radiol.2017161687) used in luminal water imaging (LWI).

## Documentation

<!-- [![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://jondeuce.github.io/DECAES.jl/stable) -->
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://jondeuce.github.io/DECAES.jl/dev)
[![Source](https://img.shields.io/badge/source-github-blue)](https://github.com/jondeuce/DECAES.jl)
<a href="https://doi.org/10.1016/j.zemedi.2020.04.001"> <img src="https://cdn.ncbi.nlm.nih.gov/corehtml/query/egifs/https:--linkinghub.elsevier.com-ihub-images-PubMedLink.gif" height="20"> </a>
<!-- [![Z Med Phys](https://cdn.ncbi.nlm.nih.gov/corehtml/query/egifs/https:--linkinghub.elsevier.com-ihub-images-PubMedLink.gif)](https://doi.org/10.1016/j.zemedi.2020.04.001) -->

<!-- [![Build Status](https://github.com/jondeuce/DECAES.jl/actions/workflows/CI.yml/badge.svg?branch=master)](https://github.com/jondeuce/DECAES.jl/actions/workflows/CI.yml?query=branch%3Amaster) -->
<!-- [![codecov.io](https://codecov.io/github/jondeuce/DECAES.jl/branch/master/graph/badge.svg)](https://codecov.io/github/jondeuce/DECAES.jl/branch/master) -->

Refer to the [DECAES documentation](https://jondeuce.github.io/DECAES.jl/dev) for in-depth descriptions of the command line interface, a Julia API reference for using DECAES from within Julia, and DECAES internals and algorithmic details.

If you use DECAES in your research, please [cite our work](https://doi.org/10.1016/j.zemedi.2020.04.001):

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

## Quickstart

Example usage of the DECAES [command line interface (CLI)](https://jondeuce.github.io/DECAES.jl/dev/cli) to process two example multi spin-echo images provided in the `data/` folder of this repository.
See the [tutorial](https://github.com/jondeuce/mwiexamples/tree/master#tutorial) below for detailed descriptions of the CLI arguments.

```bash
$ julia --project=@decaes -e 'import Pkg; Pkg.add("DECAES"); Pkg.build("DECAES")' # build DECAES CLI

$ decaes \ # run CLI launcher script stored in ~/.julia/bin
> data/images/image-194x110x1x56.nii.gz \ # multi spin-echo images to process
> data/images/image-194x110x8x56.nii.gz \
> --mask \
> data/masks/image-194x110x1x56_mask.nii.gz \ # brain masks corresponding to input images
> data/masks/image-194x110x8x56_mask.nii.gz \
> --output output/quickstart/ \ # output directory
> --T2map \ # compute T2 distribution and derived quantities, e.g. geometric mean T2
> --T2part \ # compute T2-parts from T2 distribution, e.g. myelin water fraction
> --TE 7e-3 \ # uniform echo spacing (seconds)
> --nT2 40 \ # number of T2 components
> --T2Range 7e-3 2.0 \ # range of logarithmically-spaced T2 components (seconds)
> --SPWin 7e-3 25e-3 \ # small peak window/short T2 range
> --MPWin 25e-3 200e-3 \ # middle peak window/long T2 range
> --Reg lcurve # regularization method (L-curve recommended)
```

## Installation

### (Optional) cloning this repository

Cloning this repository is not necessary to use DECAES.
However, this repository provides the following items which may prove useful to new users of the package:

* Example MWI data, brain masks, and a corresponding `examples.sh` script illustrating how to process the example data
* The `decaes.m` MATLAB function for installing DECAES and calling DECAES from MATLAB

Clone this repository using `git clone https://github.com/jondeuce/mwiexamples.git` from the command line, or by clicking [`Code -> Download ZIP`](https://github.com/jondeuce/mwiexamples/archive/refs/heads/master.zip) in the top right of this page.

### Downloading Julia

To use DECAES, Julia version 1.9 or higher is required. We recommend always installing the *latest version* of Julia via the [`juliaup`](https://github.com/JuliaLang/juliaup) official cross-platform Julia installer. Please refer to the [Julia downloads page](https://julialang.org/downloads/) for installation instructions.

### Installing DECAES (Command Line Interface)

Using Julia v1.9 or later you can install DECAES as follows:

```bash
$ julia --project=@decaes -e 'import Pkg; Pkg.add("DECAES"); Pkg.build("DECAES")'
```

This will add DECAES.jl to a named Julia project environment separate from your global environment, and build the `decaes` executable at `~/.julia/bin` for running DECAES from the command line.

Simiarly, DECAES can be updated to the latest version via

```bash
$ julia --project=@decaes -e 'import Pkg; Pkg.update("DECAES"); Pkg.build("DECAES")'
```

### Installing DECAES (MATLAB)

[Download the MATLAB function `decaes.m`](https://github.com/jondeuce/mwiexamples/blob/master/decaes.m) provided by this repository.
DECAES will be installed the first time `decaes.m` is invoked, e.g. by running `decaes --help` in the MATLAB console. A Julia project folder `.decaes` is created in the same directory as `decaes.m`.

The DECAES version used by `decaes.m` can be updated by running `decaes --update` in the MATLAB console, or by deleting the `.decaes` folder which will trigger re-installation the next time `decaes.m` is called.

## Tutorial

DECAES contains many parameters for performing T2 distribution analysis.
For most parameters, we [defer to the documentation](https://jondeuce.github.io/DECAES.jl/dev/cli/#Arguments).

Here we describe the most important parameters, which we have chosen to make required arguments.
These parameters should be set carefully according to the scan parameters used when acquiring the image, and most importantly, should be set consistently when comparing results.

**Required arguments:**

* **`MatrixSize`**: image matrix size (inferred from input image when using CLI)
* **`nTE`**: number of echoes (inferred from input image when using CLI)
* **`TE`**: echo time (units: seconds). Must correspond to scanning protocol
* **`nT2`**: number of T2 bins. Typically, `nT2 = 40` will be a good default, but note that increasing `nT2` or otherwise decreasing the spacing between T2 values (such as by decreasing the width of `T2Range`) requires more regularization
* **`T2Range`**: range of logarithmically-spaced T2 values (units: seconds). The lower bound should be on the order of `TE`, as T2 components much smaller than `TE` are not well captured by the MSE signal. Similarly, the upper bound of the `T2Range` typically should not be much higher than a small multiple of the last sampled echo time `nTE * TE`, as arbitrarily high T2 values cannot be recovered
* **`SPWin` and `MPWin`:** small and middle peak windows `SPWin` and `MPWin` (units: seconds)
    * For myelin water imaging, the myelin vs. intra/extra-cellular water cutoff should be chosen based on the T2 distribution. For example, plotting the mean T2 distribution over white matter voxels should reveal two distinct peaks from which a cutoff value can be chosen. Typical values may be `SPWin = [TE, 25e-3]` and `MPWin = [25e-3, 200e-3]`, where `SPWin` controls the myelin water window and `MPWin` controls the I/E water window
    * For luminal water imaging (LWI), `MPWin` controls the luminal water window. Typical values may be `SPWin = [TE, 200e-3]` and `MPWin = [200e-3, T2Range(2)]`, where `T2Range(2)` is the upper bound of `T2Range`
* **`Reg`**: regularization method. DECAES provides three methods to automatically determine the regularization parameter `mu` for the [Tikhonov regularization term](https://jondeuce.github.io/DECAES.jl/dev/#Introduction):
    * `"lcurve"`: choose `mu` by locating the point of [maximum curvature](https://arxiv.org/abs/1608.04571) on the [L-curve](https://epubs.siam.org/doi/10.1137/1034115). This method is parameter-free; see the [documentation](https://jondeuce.github.io/DECAES.jl/dev/ref/#DECAES.lsqnonneg_lcurve)
    * `"gcv"`: choose `mu` using the [generalized cross-validation](https://amstat.tandfonline.com/doi/abs/10.1080/00401706.1979.10489751) (GCV) method. This method is parameter-free; see the [documentation](https://jondeuce.github.io/DECAES.jl/dev/ref/#DECAES.lsqnonneg_gcv)
    * `"chi2"`: choose `mu` implicitly by specifying a (typically small) amount by which the squared-norm of the regularized residual vector should increase relative to the unregularized residual vector. This method requires an additional parameter `Chi2Factor`, typically equal to `1.01` or `1.02`; see the [documentation](https://jondeuce.github.io/DECAES.jl/dev/ref/#DECAES.lsqnonneg_chi2)

### Command Line Interface

There are two equivalent ways to use the [command line interface (CLI)](https://jondeuce.github.io/DECAES.jl/dev/cli), assuming DECAES is already installed:

**1. (Recommended) `decaes` launcher:** Use the executable `~/.julia/bin/decaes` which comes with DECAES:

```bash
$ decaes <COMMAND LINE ARGS>
```

> [!NOTE]
> Add `~/.julia/bin` to your `PATH` to avoid writing the full path `~/.julia/bin/decaes`.

**2. Julia `-e` flag:** Call the DECAES CLI from Julia directly using the `-e` (for "evaluate") flag:

```bash
$ julia --project=@decaes --threads=auto -e 'using DECAES; main()' -- <COMMAND LINE ARGS>
```

The `decaes` launcher is in fact just a thin wrapper script around a command like this one.

> [!NOTE]
> The flag `--threads=auto` enables parallel processing, which is critical for maximizing DECAES performance.

Hereafter, we will use the `decaes` launcher.
The full list of command line arguments is detailed in the [documentation](https://jondeuce.github.io/DECAES.jl/dev/cli), and can also be listed by running `decaes --help`.

The CLI takes image files as inputs and performs one or both of T2-distribution computation and T2-parts analysis, the latter of which performs post-processing of the T2-distribution to calculate parameters such as the MWF or LWF.
Data must be stored as `(x, y, z, echotime)` for multi-echo input data, or `(x, y, z, amplitude)` for T2-distribution input data.
The input image must be one of the following file types:

1. [NIfTI file](https://nifti.nimh.nih.gov/) with extension `.nii`, or [gzip](https://www.gzip.org/) compressed NIfTI file with extension `.nii.gz`
2. [MATLAB file](https://www.mathworks.com/help/matlab/import_export/mat-file-versions.html) with extension `.mat`
3. Philips [PAR/REC](https://www.nitrc.org/plugins/mwiki/index.php/dcm2nii:MainPage#Philips_PAR.2FREC_Images) file pair with extensions `.par` and `.rec` (or `.PAR` and `.REC`)
4. Philips XML/REC file pair with extensions `.xml` and `.rec` (or `.XML` and `.REC`)

All output files are saved as `.mat` files in format `v7.3`; see the [documentation](https://jondeuce.github.io/DECAES.jl/dev/cli/#Outputs-1) for more information.

> [!NOTE]
> If your data is in DICOM format, the [freely available `dcm2niix` tool](https://www.nitrc.org/plugins/mwiki/index.php/dcm2nii:MainPage) is able to convert [DICOM](https://www.nitrc.org/plugins/mwiki/index.php/dcm2nii:MainPage#General_Usage) files into NIfTI format.

The DECAES CLI aims to give users the ability to compute e.g. myelin water fraction maps from the command line and afterwards continue using the programming language of their choice.
As such, using the CLI does not require any knowledge of Julia, only the installation steps above need to be completed.
Indeed, one may call the CLI directly from within MATLAB using the `decaes.m` file provided by this repository.

The examples to follow should be run from within the `mwiexamples` folder.

### Basic usage

Process a single input image, setting only the required parameters:

```bash
$ decaes data/images/image-194x110x1x56.nii.gz \
> --T2map --T2part --TE 7e-3 --nT2 40 \
> --T2Range 7e-3 2.0 --SPWin 7e-3 25e-3 --MPWin 25e-3 200e-3 --Reg lcurve \
> --output output/basic/
```

* The 4D image file `data/images/image-194x110x1x56.nii.gz` is passed as the first argument
* The flags `--T2map` and `--T2part` are passed, indicating that both T2-distribution computation and T2-parts analysis (to compute e.g. the myelin water fraction) will be performed
* The flag `--TE` is passed with argument `7e-3`, setting the echo times to 7 ms, 14 ms, ...
* The flag `--nT2` is passed with argument `40`, setting the number of T2 components to 40
* The flag `--T2Range` is passed with argument `7e-3 2.0` to set the range of T2 values for the T2-distribution; the `--SPWin` and `--MPWin` flags similarly set the short peak and middle peak windows
* The flag `--Reg` is passed with argument `lcurve`, specifying that the L-curve regularization method will be used
* The flag `--output` is passed with argument `output/basic/`.
The folder `output/basic/` will be created if it does not already exist, and the T2-distribution and T2-parts results will be stored there as `.mat` files.

See the [arguments](https://jondeuce.github.io/DECAES.jl/dev/cli/#Arguments-1) section of the documentation for more information on command line arguments.

### Passing image masks

Image masks can be passed, causing voxels outside the mask to be ignored.
Masked voxels in output maps will be filled with `NaN` values.
We can process the image file `data/images/image-194x110x8x56.nii.gz` using the brain mask `data/masks/image-194x110x8x56_mask.nii.gz` as follows:

```bash
$ decaes data/images/image-194x110x8x56.nii.gz \
> --T2map --T2part --TE 7e-3 --nT2 40 \
> --T2Range 7e-3 2.0 --SPWin 7e-3 25e-3 --MPWin 25e-3 200e-3 --Reg gcv \
> --mask data/masks/image-194x110x8x56_mask.nii.gz \
> --output output/masked/
```

These results will be stored in the folder `output/masked/`.

### Processing multiple files

Multiple files can be passed in for processing.
Here, we process both images from the above examples, this time using brain masks for both images:

```bash
$ decaes \
> data/images/image-194x110x1x56.nii.gz \
> data/images/image-194x110x8x56.nii.gz \
> --T2map --T2part --TE 7e-3 --nT2 40 \
> --T2Range 7e-3 2.0 --SPWin 7e-3 25e-3 --MPWin 25e-3 200e-3 --Reg chi2 --Chi2Factor 1.02 \
> --mask \
> data/masks/image-194x110x1x56_mask.nii.gz \
> data/masks/image-194x110x8x56_mask.nii.gz \
> --output output/multiple/
```

### Passing parameters from a settings file

Flags and parameters can be passed in from settings files by prepending the `@` character to the path of the settings file.
Using the settings files in the `data/` folder, we can re-run the above examples as follows:

```bash
$ decaes @data/example1.txt
$ decaes @data/example2.txt
$ decaes @data/example3.txt
```

These results will be stored in the folders `output/example1/`, `output/example2/`, and `output/example3/`, as specified by the settings files.

The use of settings files is *highly* recommended for reproducibility and self-documentation, as a copy of the input settings file will be automatically saved in the output folder.
For more information on creating settings files, see the [documentation](https://jondeuce.github.io/DECAES.jl/dev/cli/#Settings-files-1).

### Default settings files

Often, one has a standard set of parameters that is used for T2 distribution analysis, but may be interested in varying a small number of parameters one-by-one to see their effect on the T2 distribution/derived metrics.
For example, one may wish to compare regularization methods or change the number of T2 components.

This can be easily done by passing in extra parameters to override default settings stored in a settings file:

```bash
$ decaes @data/example1.txt --Reg gcv --nT2 60
```

## MATLAB Interface

The DECAES CLI can be called from within MATLAB using the function [`decaes.m`](https://github.com/jondeuce/mwiexamples/blob/master/decaes.m) provided by this repository.
The below example processes `image.nii` using multiple threads using `decaes.m`:

```MATLAB
>> decaes('image.nii', <COMMAND LINE ARGS>...) % function syntax
>> decaes image.nii <COMMAND LINE ARGS> % or equivalently, command syntax
```

> [!NOTE]
> The examples in this README using the CLI should directly translate to MATLAB: simply replace trailing `\` characters with `...` for the multiline commands.

## Resources

### Example scripts

The scripts `examples.sh` and `examples.m` provided by this repository demonstrate the three example invocations of DECAES above.
These scripts require only that [`julia` is installed](https://github.com/jondeuce/mwiexamples#downloading-julia) and that [DECAES is installed](https://github.com/jondeuce/mwiexamples/tree/master#installation).

Running `./examples.sh` in the terminal or `examples` in MATLAB will execute the respective scripts.
Results will be stored in a directory `./output/`.

### DECAES Tutorial 2022

[![DECAES.jl Software Tutorial: Myelin and Luminal Water Imaging in under 1 Minute](https://imgur.com/Ulh6jA0.png)](https://www.youtube.com/watch?v=xCKWWNywOTw)

### JuliaCon 2021

[![JuliaCon 2021 - Matlab to Julia: Hours to Minutes for MRI Image Analysis](https://imgur.com/zJpRdtx.png)](https://www.youtube.com/watch?v=6OxsK2R5VkA)

## Benchmarks

Due to performance optimizations enabled by Julia, DECAES is *fast*.
As an illustration, here is a comparison between DECAES and [UBC MWF MATLAB toolbox](https://github.com/ubcmri/ubcmwf) T2-distribution computation times for two multi spin-echo (MSE) datasets:

<center>

| Dataset     | Matrix Size     | CPU                | Cores | Threads | MATLAB     | **DECAES** |
| :---:       | :---:           | :---:              | :---: | :---:   | :---:      | :---:      |
| 48-echo MSE | 240 x 240 x 48  | Intel i5 4200U     | 2     | 4       | 4h:35m:18s | **6m:42s** |
| 56-echo MSE | 240 x 240 x 113 | Intel i7-3770K     | 4     | 8       | --         | **5m:39s** |
| 48-echo MSE | 240 x 240 x 48  | Intel i7-3770K     | 4     | 8       | --         | **3m:07s** |
| 56-echo MSE | 240 x 240 x 113 | Intel Xeon E5-2640 | 12    | 24      | 1h:25m:01s | **2m:20s** |
| 48-echo MSE | 240 x 240 x 48  | Intel Xeon E5-2640 | 12    | 24      | 59m:40s    | **1m:24s** |
| 56-echo MSE | 240 x 240 x 113 | AMD Ryzen 9 3950X  | 16    | 32      | 22m:33s    | **34s**    |
| 48-echo MSE | 240 x 240 x 48  | AMD Ryzen 9 3950X  | 16    | 32      | 17m:56s    | **21s**    |

</center>

Benchmarking notes:

* MATLAB scripts used were from the `MWI_NNLS_toolbox_0319` subfolder of the [ubcmwf github repository](https://github.com/ubcmri/ubcmwf)
* Both MATLAB and DECAES made use of precomputed brain masks to skip voxels outside of the brain
* Image loading time and MATLAB/Julia startup time are not included

General Julia notes:

* Julia is a ["just-ahead-of-time" compiled language](https://www.youtube.com/watch?v=7KGZ_9D_DbI), residing in between ahead-of-time (AOT) and just-in-time (JIT) compiled languages
* Because of this, the first time DECAES is installed and run there may be several minutes of installation and compilation delay before processing starts
* Subsequent runs are much faster, typically requiring only a few seconds to start Julia and load DECAES before processing begins
* For applications like DECAES, much of the "just-ahead-of-time" compilation can be cached during installation, making Julia apps competitive with fast compiled languages like C/C++ and Fortran
