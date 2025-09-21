with ada.text_io; use ada.text_io;
--with GNAT.Source_Info ; use GNAT.Source_Info ;

package body p is

   procedure show( e : String := si.Enclosing_Entity ; l : Positive := si.Line) is
   begin
      Put("Line "); Put(l'Image); Put(" ");
      Put_Line(e);
   end show;

end p ;