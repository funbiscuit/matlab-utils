%% Loads text file with name `filename` that was exported by comsol and
%  divides it into `num` arrays
function [x, y]=parse_comsol_text(filename, num)

data = load(filename);
sz=size(data);
len=sz(1)/num;
if(len~=round(len))
    error('Data has %d points that can''t be divided in %d groups',sz(1),num);
end

x=cell(num,1);
y=cell(num,1);

for k=1:num
    x{k}=data(1:len,1);
    y{k}=data(1:len,2:end);
    data(1:len,:)=[];
end
