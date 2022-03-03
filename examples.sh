#!/bin/bash

# NOTE:
#   This script must be called from within mwiexample/ folder, as
#   the settings files contain relative paths to the example data
#   and output folders.

# Example #1
#   Process the image `data/images/image-194x110x1x56.nii.gz`.
#   Results are stored in data/output/example1/
echo; echo; echo '-------- EXAMPLE #1 --------'; echo; echo
julia --threads=auto decaes.jl -- @data/example1.txt

# Example #2
#   Process the image `data/images/image-194x110x8x56.nii.gz` using the
#   corresponding mask file `data/masks/image-194x110x8x56_mask.nii.gz`.
#   Results are stored in data/output/example2/
echo; echo; echo '-------- EXAMPLE #2 --------'; echo; echo
julia --threads=auto decaes.jl -- @data/example2.txt

# Example #3
#   Process both images in `data/images/` using the corresponding masks in
#   `data/masks/`. Results are stored in data/output/example3/
echo; echo; echo '-------- EXAMPLE #3 --------'; echo; echo
julia --threads=auto decaes.jl -- @data/example3.txt
