
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Float_Text_Io; use Ada.Float_Text_Io;
with Ada.Command_Line ; use Ada.Command_Line;
with Ada.Exceptions; use Ada.Exceptions;
with Ada.Numerics ; use Ada.Numerics;
with Ada.Numerics.Elementary_Functions ; use Ada.Numerics.Elementary_Functions;

with GNAT.Source_Info ; use GNAT.Source_Info;

with numlib ;
with numlib.integration ;
with numlib.differentiation ;

with funcs ;

procedure Diffint is
   verbose : constant boolean := true ;

   procedure CSVOutput ( name : String ) is
      ofile : File_Type ; 
   begin
      Create( ofile , Out_File , name & ".csv") ;
      Set_Output( ofile );
   end CSVOutput; 

   procedure T1 is
      me : constant String := Enclosing_Entity ;
      numSteps : constant := 128 ;
      x : numlib.RealType := 0.0 ;
      xdelta : constant numlib.RealType := 2.0 * Pi / numlib.RealType(NumSteps) ;
      y : numlib.RealType := 0.0 ;

   begin
      if verbose
      then
         Put_Line(me);
      end if ;
      CSVOutput (me);
      for n in 1..numSteps
      loop
         Put( x ); Put(" ; ");
         Put( funcs.Val(funcs.tf , x )); Put(" ; ");
         y := y + numlib.integration.Simpsons( funcs.tf'access , x , x + xdelta) ; 
         Put(y) ; Put(" ; ");
         New_Line ;
         x := x + xdelta ;
      end loop ;
      Set_Output(Standard_Output);
   end T1 ;

   procedure T2 is
      me : constant String := Enclosing_Entity ;
      numSteps : constant := 128 ;
      x : numlib.RealType := 0.0 ;
      xdelta : constant numlib.RealType := 2.0 * Pi / numlib.RealType(NumSteps) ;
      y : numlib.RealType := 0.0 ;

   begin
      if verbose
      then
         Put_Line(me);
      end if ;
      CSVOutput (me);
      for n in 1..numSteps
      loop
         Put( x ); Put(" ; ");
         Put( funcs.Val(funcs.tf , x )); Put(" ; ");
         y := numlib.differentiation.Derivative( funcs.tf'access , x , x + xdelta) ; 
         Put(y) ; Put(" ; ");
         New_Line ;
         x := x + xdelta ;
      end loop ;
      Set_Output(Standard_Output);
   end T2 ;

  procedure T3 is
      me : constant String := Enclosing_Entity ;
      numSteps : constant := 128 ;
      x : numlib.RealType := - Pi ;
      xdelta : constant numlib.RealType := 2.0 * Pi / numlib.RealType(NumSteps) ;
      y : numlib.RealType := 0.0 ;
   begin
      if verbose
      then
         Put_Line(me);
      end if ;
      CSVOutput (me);
      for n in 1..numSteps
      loop
         Put( x ); Put(" ; ");
         Put( funcs.Val(funcs.tpf , x )); Put(" ; ");
         y := numlib.differentiation.Derivative( funcs.tpf'access , x , x + xdelta) ; 
         Put(y) ; Put(" ; ");
         New_Line ;
         x := x + xdelta ;
      end loop ;
      Set_Output(Standard_Output);
   end T3 ;

   procedure T4 is
      me : constant String := Enclosing_Entity ;
      numSteps : constant := 128 ;
      x : numlib.RealType := -Pi ;
      xdelta : constant numlib.RealType := 2.0 * Pi / numlib.RealType(NumSteps) ;
      y : numlib.RealType := 0.0 ;
   begin
      if verbose
      then
         Put_Line(me);
      end if ;
      CSVOutput (me);
      -- codemd: begin segment=Appl caption=Application
      for n in 1..numSteps
      loop
         Put( x ); Put(" ; ");
         Put( funcs.Val(funcs.tpf , x )); Put(" ; ");
         y := y + numlib.integration.Newton_Coates_5(funcs.tpf'access , x , x + xdelta) ; 
         Put(y) ; Put(" ; ");
         New_Line ;
         x := x + xdelta ;
      end loop ;
      -- codemd: end
      Set_Output(Standard_Output);
   end T4 ;

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
      elsif Argument(1) = "t3"
      then
         T3 ;
      elsif Argument(1) = "t4"
      then
         T4 ;
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
end Diffint ;

