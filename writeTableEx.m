function writeTableEx(tab,header,filename)
%writeTableEx write table with configurable format of header

[rowCount, colCount]=size(tab);
headerSize=size(header);
tabWithHeader=cell2table(cell(rowCount+headerSize(1), colCount));

tabWithHeader{1:headerSize(1),:}=header;
tabWithHeader{(headerSize(1)+1):end,1:end}=table2cell(tab(:,:));
writetable(tabWithHeader, filename, 'WriteVariableNames', false);
end