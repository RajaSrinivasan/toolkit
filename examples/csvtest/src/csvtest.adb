with Ada.Command_Line; use Ada.Command_Line;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_Io; use Ada.Integer_Text_Io;
with Ada.Float_Text_Io; use Ada.Float_Text_Io;
with Ada.Calendar ;

with GNAT.Source_Info; use GNAT.Source_Info;
with GNAT.Calendar.Time_Io; use GNAT.Calendar.Time_Io;

with csv ; 

procedure Csvtest is
   verbose : boolean := true ;
   pgm : String := gnat.Source_Info.enclosing_entity ;

   procedure T1 is
      f : csv.File_Type ;
      myname : constant String := gnat.Source_Info.enclosing_entity ;
      ts : Ada.Calendar.Time ;
      datafile : constant String := Argument(2) ;
   begin
      if verbose
      then
         Put_Line(myname);
         Put("Datafile "); Put_Line(datafile);
      end if ;
      f := csv.Open( datafile , ";" , false );
      Put("No of fields ="); Put(csv.No_Columns(f)); New_Line;
      while not csv.End_Of_File(f)
      loop
         --ts := gnat.calendar.Time_Io.Value( csv.Field(f,4) , ISO_DATE ) ;
         Put_Line( csv.Field(f,4) );
         csv.Get_Line(f);
      end loop ;
      csv.Close(f);
   end T1 ;

   procedure T2 is
      f : csv.File_Type ;
      myname : constant String := gnat.Source_Info.enclosing_entity ;
      datafile : constant String := Argument(2);
   begin
      if verbose
      then
         Put_Line(myname);
         Put("Datafile "); Put_Line(datafile);
      end if ;
      f := csv.Open( datafile , "," , true );
      Put("No of fields ="); Put(csv.No_Columns(f)); New_Line;
      for i in 1..csv.No_Columns(f)
      loop
         Put_Line(csv.Field_Name(f,i));
      end loop ;
      csv.Get_Line(f);
      for i in 1..csv.No_Columns(f)
      loop
         Put(csv.Field_Name(f,i)); Put(" units "); Put_Line(csv.Field(f,i));
      end loop ;
      declare
         ts : Float ;
         ecg : Float ;
         bp : Float ;
      begin
         while not csv.End_Of_File(f)
         loop
            csv.Get_Line(f);
            ecg := Float'Value( csv.Field(f,2));
            bp := Float'Value( csv.Field(f,3) );
            Put(ecg, aft => 4 , exp => 0 ); Set_Col(10); Put(bp, aft => 4 , exp => 0); New_Line;
         end loop ;
      end ;

   end T2 ;

begin
   csv.Debug := verbose ;
   Put_Line(pgm);
   if Argument(1) = "T1"
   then
      T1 ;
   elsif Argument(1) = "T2"
   then
      T2;
   else 
      null;
   end if;

end Csvtest;
