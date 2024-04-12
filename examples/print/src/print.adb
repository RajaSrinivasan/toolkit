with Ada.Command_Line; use Ada.Command_Line ;
with Ada.Text_Io; use Ada.Text_Io;

with images ;
procedure Print is
   procedure T1 is
      v : Integer := Integer'Value(Argument(2));
   begin
      Put( images.Image(Argument(3) , v ));
      New_Line;
   end T1 ;
   procedure T2 is
      v : Float := Float'Value(Argument(2));
   begin
      Put( images.Image(Argument(3) , v ));
      New_Line;
   end T2 ;
   procedure T3 is
      v : Long_Float := Long_Float'Value(Argument(2));
   begin
      Put( images.Image(Argument(3) , v ));
      New_Line;
   end T3 ;
begin
   if Argument(1) = "t1"
   then
      T1 ;
   elsif Argument(1) = "t2"
   then
      T2 ;
   elsif Argument(1) = "t3"
   then
      T3 ;
   end if ;
end Print;
