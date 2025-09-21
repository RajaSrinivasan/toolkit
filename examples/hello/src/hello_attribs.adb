with Ada.Text_IO; use Ada.Text_IO;
with Ada.Numerics;

with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Long_Float_Text_IO;   use Ada.Long_Float_Text_IO;

procedure hello_attribs is
begin
   Put("Integer'first = "); Put( Integer'First ) ; New_Line ;
   Put("Integer'last = "); Put(Integer'Last) ; New_Line ;

   Put ("Long_Float'Size = ");
   Put (Long_Float'Size);
   New_Line;
   
   Put ("Long_Float'Safe_First = ");
   Put (Long_Float'Safe_First);
   New_Line;
   
   Put ("Long_Float'Safe_Last = ");
   Put (Long_Float'Safe_Last);
   New_Line;
   
   Put ("Long_Float'Model_Mantissa = ");
   Put (Long_Float'Model_Mantissa);
   New_Line;
   
   Put ("Long_Float'Model_Emin = ");
   Put (Long_Float'Model_Emin);
   New_Line;
   
   Put ("Long_Float'Model_Epsilon = ");
   Put (Long_Float'Model_Epsilon);
   New_Line;
   
   Put ("Long_Float'Model_Small = ");
   Put (Long_Float'Model_Small);
   New_Line;
   
   Put ("pi in Long_float = ");
   Put (Long_Float'Model (Ada.Numerics.Pi));
   New_Line;
   
   Put ("e in Long_float = ");
   Put (Long_Float'Model (Ada.Numerics.e));
   New_Line;
   
end hello_attribs;
