function status = decaes(nthreads, varargin)
%DECAES (DE)composition and (C)omponent (A)nalysis of (E)xponential (S)ignals
% Call out to the DECAES command line tool. The Julia executable `julia`
% must be on your system path.
% 
% INPUTS:
%   nthreads:   Number of Julia threads to run analysis on; may be a string
%               or an integer
%   varargin:   Flag-value arguments which will be forwarded to
%               DECAES.jl; all arguments must be strings,
%               numeric values, or arrays of numeric values. For arrays,
%               each element is forwarded as an individual argument
% 
% OUTPUTS:
%   status:     (optional) System call status; see SYSTEM for details
% 
% EXAMPLES:
%   Run DECAES with 4 threads on 'image.nii.gz', setting the echo time,
%   T2 Range, and number of T2 bins:
%       decaes 4 image.nii.gz --T2map --T2part --TE 10e-3 --T2Range 10e-3 2.0 --nT2 60
% 
%   Run DECAES as above, passing numeric values:
%       decaes(4, 'image.nii.gz', '--T2map', '--T2part', '--TE', 10e-3, '--T2Range', [10e-3, 2.0], '--nT2', 60)
% 
%   Run DECAES with 4 threads using the settings file 'settings.txt':
%       decaes 4 @settings.txt

    if nargin < 2
        error('Must specify input image or settings file')
    end
    if nargin < 1
        error('Must specify number of threads');
    end

    try
        % Create temp julia entrypoint script
        jl_script = jl_temp_script;

        % Create system command, forwarding varargin to julia
        command = ['julia ', jl_script];
        for ii = 1:numel(varargin)
            arg = varargin{ii};
            if ischar(arg)
                command = [command, ' ', arg]; %#ok
            elseif isnumeric(arg)
                for jj = 1:numel(arg)
                    command = [command, ' ', num2str(arg(jj))]; %#ok
                end
            else
                error('Optional arguments must be char or numeric values/arrays');
            end
        end

        % Call out to julia
        setenv('JULIA_NUM_THREADS', check_nthreads(nthreads));
        [st, ~] = system(command, '-echo');

    catch e
        % Delete temporary script
        if exist(jl_script, 'file') == 2
            delete(jl_script);
        end
        rethrow(e)
    end

    % Return status, if requested
    if nargout > 0
        status = st;
    end

end

function jl_script = jl_temp_script

    % Create temporary helper Julia script
    jl_script = [tempname, '.jl'];
    fid = fopen(jl_script, 'w');
    fprintf(fid, 'using DECAES\n');
    fprintf(fid, 'main()\n');
    fclose(fid);

end

function nthreads = check_nthreads(nthreads)

    if ischar(nthreads)
        % Ensure a string nthreads represents a scalar positive integer
        nthreads_double = str2double(nthreads);
        if nthreads_double <= 0 || nthreads_double ~= round(nthreads_double)
            error('Number of threads must be a positive integer; got %s', nthreads);
        end
    elseif isnumeric(nthreads) && isscalar(nthreads)
        % Ensure scalar positive integer is passed
        if nthreads > 0 && nthreads == round(nthreads)
            nthreads = sprintf('%d', round(nthreads));
        else
            error('Number of threads must be a positive integer; got %s', num2str(nthreads));
        end
    else
        error('Number of threads must be a positive integer char or numeric value')
    end

end
