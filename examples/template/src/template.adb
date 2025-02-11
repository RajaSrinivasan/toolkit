with Ada.Text_IO; use Ada.Text_IO;
with Ada.Command_Line ; use Ada.Command_Line;
with Ada.Exceptions; use Ada.Exceptions;

with GNAT.Source_Info ; use GNAT.Source_Info;

procedure Template is
   verbose : constant boolean := true ;
   procedure CSVOutput ( name : String ) is
      ofile : File_Type ; 
   begin
      Create( ofile , Out_File , name & ".csv") ;
      Set_Output( ofile );
   end CSVOutput; 

   procedure T1 is
      me : constant String := Enclosing_Entity ;
   begin
      if verbose
      then
         Put_Line(me);
      end if ;
      CSVOutput (me);
      Set_Output(Standard_Output);
   end T1 ;

   procedure T2 is
      me : constant String := Enclosing_Entity ;
   begin
      if verbose
      then
         Put_Line(me);
      end if ;
   end T2 ;

begin
   if verbose
   then
      Put( Enclosing_Entity ); Put(" ");
      Put( Command_Name ); Put(" ");
      Put( Compilation_Date); Put(" ");
      Put( Compilation_Time); New_Line ;
   end if ;
   if Argument_Count >= 1
   then
      if Argument(1) = "t1"
      then
         T1 ;
      elsif Argument(1) = "t2"
      then
         T2 ;
      else
         raise Program_Error with "unknown test name" ;
      end if ;
   else
      null ;
   end if ;
exception
   when e : others =>
      Put("Exception ");
      Put(Exception_Information(e));
      New_Line;
      Set_Exit_Status( Failure );
end Template;
