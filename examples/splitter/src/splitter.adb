with Ada.Integer_Text_Io; use Ada.Integer_Text_Io;
with Ada.Text_Io; use Ada.Text_Io;
with Ada.Command_Line; use Ada.Command_Line;

with fields; use fields ;

procedure Splitter is
   vals : IntFieldsPkg.Vector ;
   str : String := Argument(1) ;
begin
   if Argument_Count < 2
   then
      vals := fields.Split(str) ;
   else
      vals := fields.Split( str , fmt => Argument(2) );
   end if ;
   for i in IntFieldsPkg.First_Index(vals)..IntFieldsPkg.Last_Index(vals)
   loop
      Put(Integer(i)); Put(" : ");
      Put(IntFieldsPkg.Element(vals,i));
      New_Line;
   end loop ;
end Splitter;
