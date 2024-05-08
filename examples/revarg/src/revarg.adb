with Ada.Text_Io; use Ada.Text_Io;
with Ada.Strings.Unbounded ; use Ada.Strings.Unbounded ;
with Ada.Command_Line; use Ada.Command_Line;
with stacks ;

procedure Revarg is
   package arglist_Pkg is new stacks (Unbounded_String,"=");
   use arglist_Pkg ;
   revargs : Stk_Pkg.Vector := Create ;   
   content : Unbounded_String ;
begin
   for i in 1..Argument_Count
   loop
      Push( revargs, To_Unbounded_String(Argument(i)));
      Put("Pushed "); Put_Line(Argument(i));
   end loop ;
   Put_Line("Stack Contents -------" );
   while not Empty(revargs)
   loop
      Pop(revargs,content);
      Put_Line(To_String(content)) ;
   end loop ;

end Revarg;
