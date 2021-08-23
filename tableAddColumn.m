function tab=tableAddColumn(tab, name, data)
% Sample usage:
% % add column with "0" values
% tab=tableAddColumn(tab,'col1',0);
% % add column with 'test' values
% tab=tableAddColumn(tab,'col2',{'test'});
% % add column with specific data for each element
% tab=tableAddColumn(tab,'col3',vecOrCell);

szData=size(data);
szTab=size(tab);

% number of elements in single column
sz=szTab(1);

% if this is a row vector, just transpose it
if szData(1)==1 && szData(2)>1
    data=data.';
    szData=size(data);
end

if szData(2)~=1 && szData(2)~=0
    error('data has invalid number of columns');
end

column=[];
if szData(2) ~= 1 || szData(1) ~= sz
    if isnumeric(data)
        column=zeros(sz,1);
        column(:)=NaN;
    elseif iscell(data)
        column=cell(sz,1);
    else
        error('Can''t resize data, unsupported type');
    end
else
    column=data;
end
if szData(1) == 1 && szData(2) == 1
   column(:)=data(1);
end

tab=addvars(tab,column,'NewVariableNames',{name});

end
