---------------------------------------
--      Program: hello               --
--      Author: RajaSrinivasan       --
--      Synopsis:                    --
--        Hello world, exploring     --
--        Scientific and Engineering --
--        applications with Ada.     --
---------------------------------------
with Ada.Text_IO;       use Ada.Text_IO;
with Ada.Float_Text_IO; use Ada.Float_Text_IO;
with Ada.Numerics;
procedure hello is
begin
   Put ("Value of pi is =");
   Put (Float (Ada.Numerics.Pi));
   New_Line;
   Put ("And e is =");
   Put (Float (Ada.Numerics.e));
   New_Line;
end hello;
