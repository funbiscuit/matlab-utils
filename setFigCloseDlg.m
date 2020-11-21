function setFigCloseDlg(fig,title,msg,yes,no)
%setFigCloseDlg Adds custom close dialog to provided figure
%todo this dialog will not be removed if figure is saved
% so after loading it from .fig file, it will appear again

f=@(a,b) figCloseReq(a,b,title,msg,yes,no);
set(fig,'CloseRequestFcn', f);

end


function figCloseReq(p1,p2,title,msg,y,n)
   selection = questdlg(msg,title,y,n,n);
   switch selection 
      case y
         delete(gcf)
      case n
      return 
   end
end

