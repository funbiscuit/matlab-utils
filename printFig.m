function printFig(filename, varargin)
% possible options:
% size - either [w h] vector or string name. One of the following:
%        normal - normal size for one picture 11.5x8 - default
%        wide - fills A4 page horizontally (16.5), height 8
%        col2 - size of picture that allows two pictures in row (8.2x7.8)
%        screen - will be saved "as is" but without blank space
%
% dpi  - dpi to use when saving picture (300 by default)


parser = inputParser;
addOptional(parser,'size','normal',@(x) ~isempty(convertSize(x)));
addOptional(parser,'dpi',300,@(x) isreal(x)&&isscalar(x)&&(x>1));
parse(parser,varargin{:});
sz=convertSize(parser.Results.size);
dpi=round(parser.Results.dpi);

% create directory if needed
ind=find(filename=='/',1,'last');
if(length(ind)==1)
    dirname=filename(1:(ind-1));
    if(exist(dirname, 'dir')~=7)
        mkdir(dirname);
    end
end

% save previous values of figure and axes positions
fig = gcf; ax = gca;
figPos = fig.Position; axPos = ax.Position;
if sz(1)~=0
    % sets figure size in that way so it will be printed to size sz in cm
    setFigureSize(sz)
end

print('-dpng',sprintf('-r%d',dpi),filename)

%restore figure ans axes positions
ax.Position = axPos;
if sz(1)~=0
    fig.Position = figPos;
end

function sz=convertSize(sizeArg)

if isnumeric(sizeArg) && length(sizeArg)==2
    sz=[sizeArg(1) sizeArg(2)];
elseif ischar(sizeArg)
    switch sizeArg
        case 'wide'
            sz = [16.5 8];
        case 'col2'
            sz = [8.2 7.8];
        case 'normal'
            sz = [11.5 8];
        case 'screen'
            sz = [0 0];
        otherwise
            error('Supported values: normal, wide, col2.');
    end
else
    error('Size should be either [w h] or string.');
end

function setFigureSize(sz)
%obtain screen dpi
set(0,'units','pixels')
Pix_SS = get(0,'screensize');
set(0,'units','inches');
Inch_SS = get(0,'screensize');
Res = Pix_SS./Inch_SS;

cm2px = Res(end)/2.54;

fig = gcf;
ax = gca;

figPos = fig.Position;

fig.Position = [figPos(1) figPos(2) sz(1)*cm2px sz(2)*cm2px];
outerpos = ax.OuterPosition;
ti = ax.TightInset;
left = outerpos(1) + ti(1);
bottom = outerpos(2) + ti(2);
ax_width = outerpos(3) - ti(1) - ti(3);
ax_height = outerpos(4) - ti(2) - ti(4);
ax.Position = [left bottom ax_width ax_height];

