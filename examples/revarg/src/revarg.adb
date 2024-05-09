with Ada.Text_Io; use Ada.Text_Io;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Strings.Unbounded ; use Ada.Strings.Unbounded ;
with Ada.Command_Line; use Ada.Command_Line;
with stacks ;

procedure Revarg is
   package arglist_Pkg is new stacks (Unbounded_String);
   use arglist_Pkg ;

   revargs : arglist_Pkg.Stack := Create ;

   content : Unbounded_String ;
begin
   Outer_Loop : for i in 1..Argument_Count
   loop
      for j in 1..10
      loop
         if Full(revargs)
         then
            Put("Stack is full. Cannot push item "); Put(i); New_Line ;
            exit Outer_Loop ;
         end if;
         Push( revargs, To_Unbounded_String(Argument(i)));
         Put("Pushed "); Put_Line(Argument(i));
      end loop ;
   end loop Outer_Loop ;
   Put_Line("Stack Contents -------" );
   while not Empty(revargs)
   loop
      Pop(revargs,content);
      Put_Line(To_String(content)) ;
   end loop ;

end Revarg;
