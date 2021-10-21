function tab=tableAddColumn(tab, name, data)
% Sample usage:
% % add column with "0" values
% tab=tableAddColumn(tab,'col1',0);
% % add column with 'test' values
% tab=tableAddColumn(tab,'col2',{'test'});
% % add column with specific data for each element
% tab=tableAddColumn(tab,'col3',vecOrCell);
% % add column with multiple values
% tab=tableAddColumn(tab,'col4',[1 2 3 4]);
% tab=tableAddColumn(tab,'col5',{1 2 3 4});

szData=size(data);

% number of elements in single column
sz=height(tab);

if szData(2)<1
    error('data has invalid number of columns');
end

if szData(1) ~= sz
    if isnumeric(data)
        column=zeros(sz,szData(2));
    elseif iscell(data)
        column=cell(sz,szData(2));
    else
        error('Can''t resize data, unsupported type');
    end
else
    column=data;
end
if szData(1) == 1
    for k=1:sz
        column(k,:)=data;
    end
end

tab=addvars(tab,column,'NewVariableNames',{name});

end
