with Ada.Text_IO;      use Ada.Text_IO;
with Ada.Command_Line; use Ada.Command_Line;
with GNAT.Source_Info; use GNAT.Source_Info;

--codemd: begin segment=Environment caption=Predefined Language Libraries
with Ada.Calendar;            use Ada.Calendar;
with Ada.Calendar.Formatting;
with Ada.Calendar.Arithmetic; use Ada.Calendar.Arithmetic;
--codemd: end

procedure Bday is

   verbose : Boolean         := True;
   myname  : constant String := GNAT.Source_Info.Enclosing_Entity;

   dobeg        : constant String   := "1986-04-01";  -- "10:01:01" ;
   timebasis    : constant String   := " 06:00:01";
   now          : Ada.Calendar.Time := Ada.Calendar.Clock;
   days_in_year : constant          := 365;

   -- codemd: begin segment=Calc caption=Calculate Birthday
   procedure Show_Birthday (dob : Ada.Calendar.Time; age : Positive) is
      reqbday : Ada.Calendar.Time;
   begin
      reqbday := Time_Of (Year (dob) + age, Month (dob), Day (dob));

      Put ("Birthday at Age ");
      Put (Positive'Image (age));
      Set_Col (24);
      Put (Formatting.Image (reqbday));
      Set_Col (44);
      Put (Formatting.Day_Of_Week (reqbday)'Image);
      New_Line;
   end Show_Birthday;
   -- codemd: end

   procedure P1 (dob : String) is
      myname   : constant String := GNAT.Source_Info.Enclosing_Entity;
      dob_time : Ada.Calendar.Time;
   begin
      if verbose then
         Put_Line (myname);
      end if;
      dob_time := Ada.Calendar.Formatting.Value (dob);
      Put ("Date of Birth");
      Set_Col (24);
      Put (Ada.Calendar.Formatting.Image (dob_time));
      New_Line;
      Put ("Day of the Week");
      Set_Col (24);
      Put (Ada.Calendar.Formatting.Day_Of_Week (dob_time)'Image);
      New_Line;
      declare
         d : Ada.Calendar.Arithmetic.Day_Count := now - dob_time;
      begin
         Put ("Age (days) ");
         Set_Col (24);
         Put (Integer'Image (Integer (d)));
         New_Line;
         Put ("   (years) ");
         Set_Col (24);
         Put (Integer'Image (Integer (d) / days_in_year));
         New_Line;
      end;
      for age in 0 .. 5 loop
         Show_Birthday (dob_time, 50 + age * 10);
      end loop;
   end P1;
begin
   if Argument_Count < 1 then
      P1 (dobeg & timebasis);
   elsif Argument_Count = 1 then
      P1 (Argument (1) & timebasis);
   end if;
end Bday;
