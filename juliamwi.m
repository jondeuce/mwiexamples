function status = juliamwi(varargin)
%JULIAMWI Call out to MyelinWaterImaging.jl

% Create temp julia entrypoint script
jl_script = jl_temp_script;

% Create system command, forwarding varargin to julia
command = ['julia ', jl_script];
for ii = 1:length(varargin)
    command = [command, ' ', varargin{ii}]; %#ok
end

% Call out to julia
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