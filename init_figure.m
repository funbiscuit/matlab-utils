function f=init_figure(id)
% id - id of figure

if ~exist('id','var') || isempty(id)
    f=figure();
else
    f=figure(id);
end
clf
hold on
grid on
set(gca,'FontSize',10);
set(0,'DefaultLineLineWidth',1.5);
