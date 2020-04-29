function print_png(filename, size)
% possible sizes:
% norm - normal size for one picture 11.5x8 - default
% wide - fills A4 page horizontally, height 8
% col2 - size of picture that allows two pictures in row (8x8)
% ?x? - direct size specification. For example 12x5 or 8.5X4.7

sizeProvided = true;
if ~exist('size','var') || isempty(size)
    size='norm';
    sizeProvided = false;
end

ind=find(filename=='/',1,'last');

if(length(ind)==1)
    dirname=filename(1:(ind-1));
    
    if(exist(dirname, 'dir')~=7)
        mkdir(dirname);
    end
end

% size by default
newSize = [11.5 8];
sizeCalculated = false;
switch size
    case 'wide'
        newSize = [16.5 8];
        sizeCalculated = true;
    case 'col2'
        newSize = [8.2 7.8];
        sizeCalculated = true;
end

% calc size if it was provided manually
ind = find(size=='x',1);
if isempty(ind)
    ind = find(size=='X',1);
end
if isempty(ind)
    ind = find(size=='õ',1);%cyrillic
end
if isempty(ind)
    ind = find(size=='Õ',1);%cyrillic
end
if ~isempty(ind) && ind>1 && ind<length(size)
    w = str2double(size(1:ind-1));
    h = str2double(size(ind+1:end));
    if ~isnan(w) && ~isnan(h)
        newSize = [w h];
        sizeCalculated = true;
    end
end

if sizeProvided && ~sizeCalculated
    fprintf('Bad size provided ''%s'', using default size (%0.1fx%0.1f).\n', size, newSize);
end


%obtain screen dpi
set(0,'units','pixels')
Pix_SS = get(0,'screensize');
set(0,'units','inches');
Inch_SS = get(0,'screensize');
Res = Pix_SS./Inch_SS;

cm2px = Res(end)/2.54;

fig = gcf;
ax = gca;
PrevFigPos = fig.Position;
PrevPos = ax.Position;

fig.Position = [PrevFigPos(1) PrevFigPos(2) ...
    newSize(1)*cm2px newSize(2)*cm2px];
outerpos = ax.OuterPosition;
ti = ax.TightInset;
left = outerpos(1) + ti(1);
bottom = outerpos(2) + ti(2);
ax_width = outerpos(3) - ti(1) - ti(3);
ax_height = outerpos(4) - ti(2) - ti(4);
ax.Position = [left bottom ax_width ax_height];

print('-dpng','-r300',filename)

%restore figure size
ax.Position = PrevPos;
fig.Position = PrevFigPos;
