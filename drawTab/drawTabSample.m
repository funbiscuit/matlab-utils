
clear,clc

tableHeader = {'\omega_0 (cm^{-1})','\omega_p (cm^{-1})','\Gamma (cm^{-1})'};
tableData = num2cell(round(rand(5,3)*100));
tableFooter1 = {'d (\mu{m})','\epsilon_\infty','Scale'};
tableFooter2 = {'ThickFit','EinfFit','ScaleFit'};
labels = vertcat(tableHeader,tableData,tableFooter1,tableFooter2);


initFig(1);
xlim([0 10])
ylim([0 8]);

h=drawTab(labels,'pos',[2 7],'anchor','nw','marginin',[0.2 0.2],...
    'bg',[1 0.99 0.95],'border',[0.5 0.2 0],'grid','h','fontsize',11);
%% delete table
for k=1:length(h)
    delete(h{k})
end
