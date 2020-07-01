% NOTE:
%   This script must be called from within mwiexample/ folder, as
%   the settings files contain relative paths to the example data
%   and output folders.

%% Example 1 using function syntax
fprintf('\n\n-------- EXAMPLE #1 --------\n\n\n');

decaes(4,         ... % Number of threads
    'data/images/image-194x110x1x56.nii.gz', ...
    '--T2map',    ... % T2 mapping
    '--T2part',   ... % T2 parts
    '--TE', 7e-3, ... % Echo time
    '--nT2', 40,  ... % Number of T2 bins
    '--T2Range', [10e-3, 2.0],  ... % T2 Range
    '--SPWin', [10e-3, 25e-3],  ... % SP window
    '--MPWin', [25e-3, 200e-3], ... % MP window
    '--output', 'output/basic/')    % Output folder

%% Example 2 using command syntax
fprintf('\n\n-------- EXAMPLE #2 --------\n\n\n');

decaes 4 ...
    data/images/image-194x110x8x56.nii.gz ...
    --T2map ...
    --T2part ...
    --TE 7e-3 ...
    --nT2 40...
    --T2Range 10e-3 2.0 ...
    --SPWin 10e-3 25e-3 ...
    --MPWin 25e-3 200e-3 ...
    --mask data/masks/image-194x110x8x56_mask.nii.gz ...
    --output output/masked/

%% Example 3 using command syntax
fprintf('\n\n-------- EXAMPLE #3 --------\n\n\n');

decaes 4 ...
    data/images/image-194x110x1x56.nii.gz ...
    data/images/image-194x110x8x56.nii.gz ...
    --T2map ...
    --T2part ...
    --TE 7e-3 ...
    --nT2 40...
    --T2Range 10e-3 2.0 ...
    --SPWin 10e-3 25e-3 ...
    --MPWin 25e-3 200e-3 ...
    --mask ...
    data/masks/image-194x110x1x56_mask.nii.gz ...
    data/masks/image-194x110x8x56_mask.nii.gz ...
    --output output/multiple/
