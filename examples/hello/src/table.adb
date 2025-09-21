---------------------------------------
--      Program: table               --
--      Author: RajaSrinivasan       --
--      Synopsis:                    --
--        generate a table of values --
--        of different functions     --
---------------------------------------
with Ada.Text_IO;  use Ada.Text_IO;
with Ada.Float_Text_IO;  use Ada.Float_Text_IO;
with Ada.Numerics.Elementary_Functions; use Ada.Numerics.Elementary_Functions;
procedure table is
   x     : Float := 0.1;
   x_max : Float := Ada.Numerics.Pi / 2.0;
begin
   Put_Line
     ("  x   |Sqrt(x)| Log(x)   |Log10(x)| exp(x)|      x^3   |     x^x");
   while x <= x_max loop
      Put (x, Aft => 2, Exp => 0); Put (" | ");
      Put (Sqrt (x), Aft => 2, Exp => 0); Put (" | ");
      Put (Log (x), Exp => 0);  Put (" | ");
      Put (Log (x, Base => 10.0), Aft => 2, Exp => 0);  Put ("  | ");
      Put (Exp (x), Aft => 2, Exp => 0); Put (" | ");
      Put ( "**" (x, 3.0), Aft => 7, Exp => 0);  Put (" | ");
      Put (x ** x, Aft => 8, Exp => 0);
      New_Line;
      x := x + 0.1;
   end loop;
end table;
