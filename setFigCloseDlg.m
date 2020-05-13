function setFigCloseDlg(fig,title,msg,yes,no)
%setFigCloseDlg Adds custom close dialog to provided figure

f=@(a,b) figCloseReq(a,b,title,msg,yes,no);
set(fig,'CloseRequestFcn', f);

end


function figCloseReq(~,~,title,msg,y,n)
   selection = questdlg(title,msg,y,n,n); 
   switch selection 
      case y
         delete(gcf)
      case n
      return 
   end
end

