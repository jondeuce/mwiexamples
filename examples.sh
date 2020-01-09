#!/bin/bash

# NOTE:
#   This script must be called from within mwiexample/ folder, as
#   the settings files contain relative paths to the example data
#   and output folders.

# Set number of threads for parallel processing
export JULIA_NUM_THREADS=4

# Example #1
#   Process the image `image-175x140x1x56.nii.gz` in the data/images/
#   folder, storing output results to data/output/example1/
echo; echo; echo '-------- EXAMPLE #1 --------'; echo; echo
julia decaes.jl @data/example1/settings.txt

# Example #2
#   Process all images in the data/images/ folder, storing output
#   results to data/output/example2/
echo; echo; echo '-------- EXAMPLE #2 --------'; echo; echo
julia decaes.jl @data/example2/settings.txt
