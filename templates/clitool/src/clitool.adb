with Ada.Exceptions ; use Ada.Exceptions;
with Ada.Text_Io; use  Ada.Text_Io;

with GNAT.Source_Info; use GNAT.Source_Info ;

with cli ; use cli ;
procedure Clitool is
begin
   cli.ProcessCommandLine ;    
   if cli.verbosity > 0
   then
      Put( Enclosing_Entity ); Put(" ");
      Put( GNAT.Source_Info.Compilation_Date ); Put(" ");
      Put( GNAT.Source_Info.Compilation_Time ); Put(" ");
      New_Line ;
   end if ;
exception
   when e : others =>
      Put("Exception "); Put(Exception_Message(e)); New_Line;            
end Clitool;
