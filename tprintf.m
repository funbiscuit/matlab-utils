function tprintf(varargin)
%TPRINTF prints formatted output with timestamp

str=sprintf(varargin{:});

formatOut = 'dd.mm.yy HH:MM:SS';

fprintf('[%s] %s\n',datestr(now,formatOut), str);

end
