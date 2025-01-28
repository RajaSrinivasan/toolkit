with Ada.Text_Io; use Ada.Text_Io;
with Ada.Command_Line; use Ada.Command_Line;
with Ada.Strings.Unbounded ; use Ada.Strings.Unbounded ;
with Ada.Characters.Handling ; use Ada.Characters.Handling;

procedure Varname is
   function generate( fn : String ) return String is
      result : Unbounded_String := Null_Unbounded_String ;
   begin
      for c in fn'Range
      loop 
         if c = fn'First
         then
            if Is_Letter(fn(c))
            then
               Append( result , To_Upper(fn(c)));
            else
               Append( result , "V" );
            end if ;
         else
            if Is_Alphanumeric( fn(c) )
            then
               Append( result , To_Upper(fn(c))) ;
            else
               Append( result , "_" ) ;
            end if ;
         end if ;
      end loop ;
      return To_String(result);
   end generate;
begin
   for arg in 1..Argument_Count
   loop
      Put(Argument(arg));
      Put(" => ");
      Put(Generate(Argument(arg)));
      New_Line ;
   end loop ;
end Varname;
