function writeLog(filename, varargin)
%WRITELOG Writes specified text to both command window and provided file
% if you don't want to write to file, provide empty filename

if(~isempty(filename))
	fid = fopen(filename, 'a+');
    try
        fprintf(fid, varargin{:});
    catch ME
        fprintf(ME.message);
        fprintf('\n');
    end
	fclose(fid);
end

try
    fprintf(varargin{:});
catch ME
    fprintf(ME.message);
    fprintf('\n');
end

end

