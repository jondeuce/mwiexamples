#!/bin/bash

# NOTE:
#   Must call this script from within mwiexample/ folder, as the
#   settings files contain relative paths to the example data.

# Example #1
#   Process the image `image-175x140x1x56.nii.gz` in the images/
#   folder, storing output results to data/example1-output/
echo; echo; echo '-------- EXAMPLE #1 --------'; echo; echo
export JULIA_NUM_THREADS=4
julia my_script.jl @data/example1/settings.txt

# Example #2
#   Process all images in the images/ folder, storing output
#   results to data/example2-output/
echo; echo; echo '-------- EXAMPLE #2 --------'; echo; echo
export JULIA_NUM_THREADS=4
julia my_script.jl @data/example2/settings.txt
