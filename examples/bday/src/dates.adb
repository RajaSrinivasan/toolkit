with Ada.Text_IO;      use Ada.Text_IO;
with Ada.Command_Line; use Ada.Command_Line;
with GNAT.Source_Info; use GNAT.Source_Info;

with Ada.Calendar;            use Ada.Calendar;
with Ada.Calendar.Formatting;
with Ada.Calendar.Arithmetic; use Ada.Calendar.Arithmetic;

procedure dates is

   verbose : constant Boolean := True;
   myname  : constant String  := Enclosing_Entity;

   day1 : constant String := "1986-04-01";
   day2 : constant String := "1989-09-17";

   timebasis    : constant String            := " 06:00:01";
   now          : constant Ada.Calendar.Time := Ada.Calendar.Clock;
   days_in_year : constant                   := 365;

   procedure Show_Day (person : String; d : Ada.Calendar.Time) is
      agetoday : constant Arithmetic.Day_Count := now - d;
   begin
      Put ("Person ");
      Put_Line (person);
      Put (ASCII.HT & "Birthday");
      Set_Col (24);
      Put (Ada.Calendar.Formatting.Image (d));
      New_Line;
      Put (ASCII.HT & "Day of the Week");
      Set_Col (24);
      Put (Ada.Calendar.Formatting.Day_Of_Week (d)'Image);
      New_Line;
      Put (ASCII.HT & "Age today");
      Set_Col (24);
      Put (agetoday'Image);
      Put_Line (" days");
      Set_Col (24);
      Put (Day_Count'Image (agetoday / days_in_year));
      Put_Line (" years");
   end Show_Day;
   -- codemd: end

   procedure Show_Age (person : String; b, d : Ada.Calendar.Time) is
      age : constant Arithmetic.Day_Count := d - b;
   begin
      Put ("Person ");
      Put_Line (person);
      Put (" will be ");
      Set_Col (24);
      Put (Day_Count'Image (age / days_in_year));
      Put_Line (" years old");
   end Show_Age;

   -- codemd: begin segment=AddYears caption=Add years to person
   function Age (dob : Time; years : Integer) return Time is
      agedTime : Time := dob;
   begin
      agedTime :=
        Time_Of (Year_Number (Year (dob) + years), Month (dob), Day (dob));
      return agedTime;
   end Age;
   -- codemd: end

   -- codemd: begin segment=Compare caption=Age comparison
   procedure AgeDiff (operson : String; od : Time; yperson : String; yd : Time)
   is
      agediff   : Day_Count;
      yearsdiff : Integer;
      dblage    : Time := od;
   begin
      Put ("Person ");
      Put (operson);
      Put_Line (" is older");
      agediff   := yd - od;
      yearsdiff := Integer (agediff / days_in_year);
      Put ("Age difference is ");
      Put (agediff'Image);
      Put_Line (" days");
      Put ("               or ");
      Put (yearsdiff'Image);
      Put_Line (" years");
      Put_Line ("Double the Age");
      dblage := Age (yd, yearsdiff);

      Put ("On ");
      Put_Line (Formatting.Image (dblage));
      Show_Age (yperson, yd, dblage);
      Show_Age (operson, od, dblage);
   end AgeDiff;
   -- codemd: end

   procedure P1 (d1, d2 : String) is
      myname           : constant String := Enclosing_Entity;
      d1_time, d2_time : Ada.Calendar.Time;
   begin
      if verbose then
         Put_Line (myname);
      end if;
      d1_time := Ada.Calendar.Formatting.Value (d1 & timebasis);
      d2_time := Ada.Calendar.Formatting.Value (d2 & timebasis);
      Show_Day ("A", d1_time);
      Show_Day ("B", d2_time);
      if d1_time < d2_time then
         AgeDiff ("A", d1_time, "B", d2_time);
      else
         AgeDiff ("B", d2_time, "A", d1_time);
      end if;
   end P1;
begin
   if verbose then
      Put_Line (myname);
   end if;
   if Argument_Count < 1 then
      P1 (day1, day2);
   elsif Argument_Count = 1 then
      P1 (day1, Argument (1));
   else
      P1 (Argument (1), Argument (2));
   end if;
end dates;
