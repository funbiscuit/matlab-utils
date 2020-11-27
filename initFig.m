function varargout=initFig(id)
% id - id of figure

if nargout>1
    error('Two many output arguments!');
end

if ~exist('id','var') || isempty(id)
    f=figure();
else
    f=figure(id);
end
clf
hold on
grid on
set(gca,'FontSize',10);
set(f,'DefaultLineLineWidth',1.5);

if nargout==1
    varargout{1}=f;
end
