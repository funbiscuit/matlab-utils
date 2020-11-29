function varargout=drawTab(labels,varargin)
% possible options:
% Pos       - position of anchor, should be vector with two values (x and y)
% Anchor    - can be C N S W E NW SW NE SW
% MarginIn  - space between cells inside table
% MarginOut - space between cell and table border
% Grid      - can be V - vertical, H - horizontal, A - all, N - none
% outputs handles to all created objects
% to delete table just delete each handle

if nargout>1
    error('Two many output arguments!');
end

parser = inputParser;
addOptional(parser,'Pos',[0 0]);
addOptional(parser, 'Anchor', 'NW');
addOptional(parser, 'MarginIn', [-1 -1]);
addOptional(parser, 'MarginOut', [-1 -1]);
addOptional(parser, 'Grid', 'N');
addOptional(parser, 'BG', [1 1 1]);
addOptional(parser, 'Border', [0 0 0]);
addOptional(parser, 'FontSize', 10);
parse(parser,varargin{:});

defaultMarginCoef=0.1;

pos=parser.Results.Pos;
marginInternal=parser.Results.MarginIn;
marginExternal=parser.Results.MarginOut;
anchor=upper(parser.Results.Anchor);
gridVal=upper(parser.Results.Grid);
bgColor=parser.Results.BG;
bdColor=parser.Results.Border;
fontSize=parser.Results.FontSize;


% check if anchor value is correct
if isempty(find(ismember({'C' 'N' 'S' 'W' 'E' 'NW' 'SW' 'NE' 'SE'},anchor),1))
    error('Bad anchor value: %s',anchor);
end

if(length(gridVal(:))~=1)
    error('Bad grid value: %s', gridVal);
end

if gridVal~='V' && gridVal~='H' && gridVal~='A' && gridVal~='N'
    error('Bad grid value: %s', gridVal);
end


sz=size(labels);
ht=cell(sz);

r=rectangle('edgecolor','none');

% [x y w h], x and y with respect to center of cell
% width and height without margins
cellPars=cell(sz);

% create all text labels in one place and fill height pars
for kr=1:sz(1)
    maxHeight=0;
    for kc=1:sz(2)
        ht{kr,kc}=text(0, 0,labels(kr,kc),'fontsize',fontSize,...
            'verticalalignment','middle','horizontalalignment','center');
        maxHeight=max(maxHeight,ht{kr,kc}.Extent(4));
    end
    for kc=1:sz(2)
        cellPars{kr,kc}=[0 0 0 maxHeight];
    end
end
% fill width pars
for kc=1:sz(2)
    maxWidth=0;
    for kr=1:sz(1)
        maxWidth=max(maxWidth,ht{kr,kc}.Extent(3));
    end
    for kr=1:sz(1)
        cellPars{kr,kc}(3)=maxWidth;
    end
end
if marginInternal(1)<0
    marginInternal(1)=cellPars{1,1}(3)*defaultMarginCoef;
end
if marginInternal(2)<0
    marginInternal(2)=cellPars{1,1}(4)*defaultMarginCoef;
end
if marginExternal(1)<0
    marginExternal(1)=cellPars{1,1}(3)*defaultMarginCoef;
end
if marginExternal(2)<0
    marginExternal(2)=cellPars{1,1}(4)*defaultMarginCoef;
end
% fill positions
curPos=pos;
for kr=1:sz(1)
    curPos(1)=pos(1);
    for kc=1:sz(2)
        cellPars{kr,kc}(1:2)=curPos;
        if kc<sz(2)
            curPos(1)=curPos(1)+(cellPars{kr,kc}(3)+cellPars{kr,kc+1}(3))/2+marginInternal(1);
        end
    end
    if kr<sz(1)
        curPos(2)=curPos(2)-(cellPars{kr,kc}(4)+cellPars{kr+1,kc}(4))/2-marginInternal(2);
    end
end

% calculate rect pos for easier offset calculation
r.Position(1:2)=cellPars{end,1}(1:2)-cellPars{end,1}(3:4)/2-marginExternal;
r.Position(3:4)=cellPars{1,end}(1:2)-cellPars{end,1}(1:2)+...
    cellPars{end,1}(3:4)/2+cellPars{1,end}(3:4)/2+2*marginExternal;

% calculate necessary offset
offset=[0 0];


switch anchor
    case 'NW'
        offset=pos-r.Position(1:2)-[0 r.Position(4)];
    case 'N'
        offset=pos-r.Position(1:2)-[r.Position(3)/2 r.Position(4)];
    case 'NE'
        offset=pos-r.Position(1:2)-[r.Position(3) r.Position(4)];
    case 'W'
        offset=pos-r.Position(1:2)-[0 r.Position(4)/2];
    case 'C'
        offset=pos-r.Position(1:2)-[r.Position(3)/2 r.Position(4)/2];
    case 'E'
        offset=pos-r.Position(1:2)-[r.Position(3) r.Position(4)/2];
    case 'SW'
        offset=pos-r.Position(1:2);
    case 'S'
        offset=pos-r.Position(1:2)-[r.Position(3)/2 0];
    case 'SE'
        offset=pos-r.Position(1:2)-[r.Position(3) 0];
end


% apply offset and put text in correct position
for kr=1:sz(1)
    for kc=1:sz(2)
        cellPars{kr,kc}(1:2)=cellPars{kr,kc}(1:2)+offset;
        ht{kr,kc}.Position(1:2)=cellPars{kr,kc}(1:2);
    end
end

r.Position(1:2)=r.Position(1:2)+offset;
r.FaceColor=bgColor;
r.EdgeColor=bdColor;

edges={};

if gridVal=='H' || gridVal=='A'
    % plot internal boundaries (horizontal)
    for kr=1:sz(1)-1
        x1=r.Position(1);
        x2=r.Position(1)+r.Position(3);
        posY=cellPars{kr,1}(2)-cellPars{kr,1}(4)/2;
        
        edges{end+1}=plot([x1 x2],[1 1]*(posY-marginInternal(2)/2),'linewidth',0.5,...
            'color',bdColor);
    end
end

if gridVal=='V' || gridVal=='A'
    % plot internal boundaries (vertical)
    for kc=1:sz(2)-1
        y1=r.Position(2);
        y2=r.Position(2)+r.Position(4);
        posX=cellPars{1,kc}(1)+cellPars{1,kc}(3)/2;
        
        edges{end+1}=plot([1 1]*(posX+marginInternal(1)/2),[y1 y2],'linewidth',0.5,...
            'color',bdColor);
    end
end

if nargout==1
    allHandles=cell(1+sz(1)*sz(2)+length(edges),1);
    allHandles{1}=r;
    l=2;
    for k=1:sz(1)*sz(2)
        allHandles{l}=ht{k};
        l=l+1;
    end
    for k=1:length(edges)
        allHandles{l}=edges{k};
        l=l+1;
    end
    varargout{1}=allHandles;
end

