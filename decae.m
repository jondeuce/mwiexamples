function status = decae(nthreads, varargin)
%DECAE Call out to MyelinWaterImaging.jl from MATLAB.
% INPUTS:
%   nthreads:   Number of Julia threads to run analysis on; may be a string
%               or an integer
%   varargin:   Flag-value arguments which will be forwarded to
%               MyelinWaterImaging.jl; all arguments must be strings
% 
% OUTPUTS:
%   status:     (optional) System call status; see SYSTEM for details
% 
% EXAMPLES:
%   Run DECAE with 4 threads on image.nii.gz, settings the echo time and
%   the number of T2 bins:
%       decae 4 image.nii.gz --T2map --T2part --TE 0.01 --nT2 60
% 
%   Run DECAE with 4 threads using the settings file settings.txt:
%       decae 4 @settings.txt

if nargin < 1
    error('Must specify number of threads');
end

if ~all(cellfun(@ischar, varargin))
    error('Optional arguments must be all strings');
end

% Convert nthreads to string for use below
nthreads = check_nthreads(nthreads);

% Create temp julia entrypoint script
jl_script = jl_temp_script;

% Create system command, forwarding varargin to julia
command = ['julia ', jl_script];
for ii = 1:length(varargin)
    command = [command, ' ', varargin{ii}]; %#ok
end

% Call out to julia
setenv('JULIA_NUM_THREADS', nthreads);
[st, ~] = system(command, '-echo');

% Delete temporary script
if exist(jl_script, 'file') == 2
    delete(jl_script);
end

% Return status, if requested
if nargout > 0
    status = st;
end

end

function jl_script = jl_temp_script

jl_script = [tempname, '.jl'];
fid = fopen(jl_script, 'w');
fprintf(fid, 'using MyelinWaterImaging\n');
fprintf(fid, 'main()\n');
fclose(fid);

end

function nthreads = check_nthreads(nthreads)

errmsg = 'Number of threads must be a scalar numeric value';

if ischar(nthreads)
    % Ensure a string nthreads represents a scalar positive integer
    nthreads_double = str2double(nthreads);
    if nthreads_double <= 0 || nthreads_double ~= round(nthreads_double)
        error(errmsg);
    end
else
    % Ensure scalar positive integer is passed
    if isnumeric(nthreads) && nthreads > 0 && isscalar(nthreads)
        nthreads = sprintf('%d', round(nthreads));
    else
        error(errmsg);
    end
end

end