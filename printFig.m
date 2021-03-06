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
drawnow
% save previous values of figure and axes positions
fig = gcf; ax = findobj(fig.Children, '-depth', 1, 'type', 'axes');
figPos = fig.Position;
axPos = zeros(size(ax, 1), 4);
useOuter = zeros(size(ax, 1), 1);
for k=1:length(ax)
    useOuter(k) = strcmp(ax(k).ActivePositionProperty, 'outerposition');
    if useOuter(k)
        axPos(k, :)=ax(k).OuterPosition;
    else
        axPos(k, :)=ax(k).Position;
        ax(k).Position = axPos(k,:);
    end
end
% sets figure size in that way so it will be printed to size sz in cm
setFigureSize(sz)


print('-dpng',sprintf('-r%d',dpi),filename)

%restore figure ans axes positions
for k=1:length(ax)
    if useOuter(k)
        ax(k).OuterPosition = axPos(k, :);
    else
        ax(k).Position = axPos(k, :);
    end
end
fig.Position = figPos;
drawnow

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
% if sz contains 0, size will not be set

%obtain screen dpi
units=get(0,'units');
set(0,'units','pixels')
Pix_SS = get(0,'screensize');
set(0,'units','inches');
Inch_SS = get(0,'screensize');
Res = Pix_SS./Inch_SS;
set(0,'units',units);

cm2px = Res(end)/2.54;

fig = gcf;
ax = findobj(fig.Children, '-depth', 1, 'type', 'axes');

figPos = fig.Position;
if sz(1)>0 && sz(2)>0
    newSize = [sz(1)*cm2px sz(2)*cm2px];
    fig.Position = [figPos(1) figPos(2)+figPos(4)-newSize(2) newSize];
end

drawnow

% find coordinates of bounding region of axes
outLeft=1;
outRight=0;
outBottom=1;
outTop=0;

for k=1:length(ax)
    pos = ax(k).Position;
    ti = ax(k).TightInset;
    left = pos(1) - ti(1);
    bottom = pos(2) - ti(2);
    width = pos(3) + ti(1) + ti(3);
    height = pos(4) + ti(2) + ti(4);
    outLeft=min(outLeft, left);
    outBottom=min(outBottom, bottom);
    outRight=max(outRight, left + width);
    outTop=max(outTop, bottom + height);
end

offset=[-outLeft, -outBottom];
scale=1./([outRight outTop]+offset);

for k=1:length(ax)
    pos=ax(k).Position;
    posBL=pos(1:2);
    posTR=posBL+pos(3:4);
    posBL=(posBL+offset).*scale;
    posTR=(posTR+offset).*scale;
    ax(k).Position=[posBL posTR-posBL];
end
