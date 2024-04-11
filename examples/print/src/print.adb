with Ada.Command_Line; use Ada.Command_Line ;
with Ada.Text_Io; use Ada.Text_Io;

with images ;
procedure Print is
   procedure T1 is
      v : Integer := Integer'Value(Argument(2));
   begin
      Put( images.Image(Argument(1) , v ));
      New_Line;
   end T1 ;
begin
   T1;
end Print;
