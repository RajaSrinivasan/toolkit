pragma Ada_2022 ;
with Ada.Command_Line; use Ada.Command_Line;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Calendar;
with Ada.Calendar.Formatting;

procedure dow is
   separator : constant String := "------------------------------------------------------------";
   procedure show_usage is
   begin
      Put_Line("Day of the week for the specified yyyy-mm-dd");
      Put( "Arguments: year month day ");
      Put_Line( "use . to indicate all");
   end show_usage;

   nowy : Ada.Calendar.Year_Number ;
   nowm : Ada.Calendar.Month_Number ;
   nowd : Ada.Calendar.Day_Number ;

   procedure Setup_Today is
      nowt : constant Ada.Calendar.Time := Ada.Calendar.Clock ;
   begin
      nowy := Ada.Calendar.Formatting.Year( nowt );
      nowm := Ada.Calendar.Formatting.Month( nowt );
      nowd := Ada.Calendar.Formatting.Day( nowt );
   end Setup_Today;

   y : Ada.Calendar.Year_Number := Ada.Calendar.Year_Number'first ;
   m : Ada.Calendar.Month_Number := Ada.Calendar.Month_Number'first ;
   d : Ada.Calendar.Day_Number := Ada.Calendar.Day_Number'first ;

   
   procedure Show_Day is
      t : constant Ada.Calendar.Time := Ada.Calendar.Formatting.Time_Of( y,m,d) ;
   begin

      Put( Ada.Calendar.Formatting.Local_Image(t) );
      Put( " -> ");
      Put( Ada.Calendar.Formatting.Day_Of_Week( t )'Image);
      New_Line;
      Put_Line(separator);
   end Show_Day;

   procedure Show_Summary is
      counts : array ( Ada.Calendar.Formatting.Day_Name'Range ) of Natural 
                  := [ others => 0 ] ;
      date : Ada.Calendar.Time ;
      wday : Ada.Calendar.Formatting.Day_Name ;
   begin
      for year in Ada.Calendar.Year_Number'Range
      loop
         date := Ada.Calendar.Time_Of( year , m , d );
         Put( Ada.Calendar.Formatting.Local_Image(date) );
         Put(" ");
         wday := Ada.Calendar.Formatting.Day_Of_Week( date ); 
         Put( wday'Image );
         New_Line ;
         counts(wday) := @ + 1 ;
      end loop ;
      Put_Line(separator);
      New_Line;
      Put_Line("Summary");
      for wd in counts'Range
      loop
         Put( wd'Image );
         Put( " " );
         Set_Col( 12 );
         Put( counts(wd)'Image);
         New_Line; 
      end loop ;
   end Show_Summary ;

begin
   if Argument_Count < 1
   then
      show_usage ;
      return ;
   end if ;

   Setup_Today ;

   if Argument_Count >= 1
   then
      if Argument(1) = "."
      then
         y := nowy ;
      else
         y := Ada.Calendar.Year_Number'Value( Argument(1) );
      end if ;
      if Argument_Count >= 2
      then
         if Argument(2) = "."
         then
            m := nowm ;
         else
            m := Ada.Calendar.Month_Number'Value( Argument(2) );
         end if ;
         if Argument_Count >= 3
         then
            if Argument(3) = "."
            then
               d := nowd ;
            else
               d := Ada.Calendar.Day_Number'Value( Argument(3) );
            end if ;
         end if ;
      end if ;
   end if ;
   Show_Day ;

   if Argument_Count > 3
   then
      Show_Summary ;
   end if ;

end dow ;