function print_png(filename)

ind=find(filename=='/',1,'last');

if(length(ind)==1)
    dirname=filename(1:(ind-1));
    
    if(exist(dirname, 'dir')~=7)
        mkdir(dirname);
    end
end

print('-dpng','-r300',filename)
