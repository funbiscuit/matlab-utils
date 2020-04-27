function f=init_figure(id, size)
% id - id of figure
% size: 0 - small, 1 - big, 2 - very big

f=figure(id);
clf
hold on
grid on
set(gca,'fontsize',10);
set(0,'defaultlinelinewidth',1.5);
if size==0
    set(gcf,'PaperPosition',[1 1 8.2 5.7])
elseif size==1
    set(gcf,'PaperPosition',[1 1 11.5 8])
elseif size==2
    set(gcf,'PaperPosition',[1 1 14 9.8])
end
