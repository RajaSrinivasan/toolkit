with Ada.Text_IO;      use Ada.Text_IO;
with Ada.Command_Line; use Ada.Command_Line;
with GNAT.Source_Info; use GNAT.Source_Info;

with Ada.Calendar; use Ada.Calendar;
with Ada.Calendar.Formatting;
-- with Ada.Calendar.Arithmetic; use Ada.Calendar.Arithmetic;

with Ada.Numerics.Elementary_Functions; use Ada.Numerics.Elementary_Functions;
procedure realtime is

   verbose : constant Boolean := True;
   myname  : constant String  := Enclosing_Entity;

   now       : constant Ada.Calendar.Time := Ada.Calendar.Clock;
   sleeptime : Duration                   := 3.0;
   procedure P1 is
      myname : constant String := Enclosing_Entity;
      t1, t2 : Time;
   begin
      if verbose then
         Put_Line (myname);
      end if;

      Put ("Sleeping for ");
      Put (sleeptime'Image);
      Put_Line (" seconds");
      t1 := Clock;
      delay sleeptime;
      t2 := Clock;
      Put_Line ("Woke up");
      Put ("Slept from ");
      Put (Formatting.Image (t1));
      Put (" to ");
      Put (Formatting.Image (t2));
      New_Line;
   end P1;

   procedure P2 is
      myname : constant String := Enclosing_Entity;
      t1, t2 : Time;
   begin
      if verbose then
         Put_Line (myname);
      end if;
      sleeptime := sleeptime + sleeptime + sleeptime;
      -- codemd: begin segment=Till caption=Wait till a specific time
      t1        := Clock;
      t2        := t1 + sleeptime;
      Put ("Sleeping till ");
      Put (Formatting.Image (t2));
      Put_Line (" seconds");
      delay until t2;
      Put_Line ("Woke up");
      t2 := Clock;
      Put ("Slept from ");
      Put (Formatting.Image (t1));
      Put (" to ");
      Put (Formatting.Image (t2));
      New_Line;
      -- codemd: end
   end P2;

   procedure P3 is
      myname     : constant String := Enclosing_Entity;
      iterations : Integer         := 1_024;
      vf         : constant Float  := 0.0;
      result     : Float;
      t1, t2     : Time;
   begin
      if verbose then
         Put_Line (myname);
      end if;
      if Argument_Count > 1 then
         iterations := iterations * Integer'Value (Argument (2));
      end if;

      -- codemd: begin segment=Time caption=Time required
      Put ("Starting computations ");
      Put (iterations'Image);
      Put (" cycles");
      t1 := Clock;

      for i in 1 .. iterations loop
         result := Cosh (Float (i) * vf) + Sinh (Float (i) * vf);
      end loop;
      t2 := Clock;
      Put ("Completed ");
      Put (Duration'Image (t2 - t1));
      Put_Line (" seconds");
      -- codemd: end
   end P3;
begin
   if verbose then
      Put_Line (myname);
   end if;
   if Argument_Count >= 1 then
      if Argument (1) = "p1" then
         P1;
      elsif Argument (1) = "p2" then
         P2;
      elsif Argument (1) = "p3" then
         P3;
      end if;
   else
      P1;
   end if;

end realtime;
