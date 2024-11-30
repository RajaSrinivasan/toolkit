with Ada.Command_Line; use Ada.Command_Line;
with Ada.Text_IO;      use Ada.Text_IO;
with GNAT.Source_Info; use GNAT.Source_Info;

with numbers;
procedure Num is
   procedure Unary is

      arg  : Natural := Natural'First;
      o    : numbers.OctalDigits_Type;
      d    : numbers.DecimalDigits_Type;
      h    : numbers.HexadecimalDigits_Type;
      divs : numbers.NumbersVector_Pkg.Vector;
      facs : numbers.NumbersVector_Pkg.Vector;
   begin
         arg := Natural'Value (Argument (1));
         o   := numbers.Convert (arg);
         Put ("Octal       ");
         Put (numbers.Image (o));
         New_Line;
         if arg = numbers.Value (o) then
            Put_Line ("Octal Conversion Ok");
         else
            Put_Line ("Octal Conversion Failed");
         end if;

         d := numbers.Convert (arg);
         Put ("Decimal     ");
         Put (numbers.Image (d));
         New_Line;
         if arg = numbers.Value (d) then
            Put_Line ("Decimal Conversion Ok");
         else
            Put_Line ("Decimal Conversion Failed");
         end if;
         h := numbers.Convert (arg);
         Put ("Hexadecimal ");
         Put (numbers.Image (h));
         New_Line;
         if arg = numbers.Value (h) then
            Put_Line ("HexaDecimal Conversion Ok");
         else
            Put_Line ("HexaDecimal Conversion Failed");
         end if;
         divs := numbers.Divisors (arg);
         Put_Line ("Divisors");
         numbers.Show (divs);
         facs := numbers.Factors (arg);
         Put_Line ("Prime Factors");
         numbers.Show (facs);

         Put("Prime No "); Set_Col(15);
         if numbers.IsPrime (arg) then
            Put_Line ("Yes");
         else
            Put_Line ("No");
         end if;

         Put("Perfect No "); Set_Col(15);
         if numbers.IsPerfect (arg) then
            Put_Line ("Yes");
         else
            Put_Line ("No");
         end if;

         Put("Kaprekar No "); Set_Col(15); 
         if numbers.IsKaprekar(arg)
         then 
            Put_Line("Yes");
         else
            Put_Line("No");
         end if ;

   end Unary;

   procedure Binary is
      arg1, arg2 : Natural ;
   begin
      arg1 := Natural'Value(Argument(1));
      arg2 := Natural'Value(Argument(2));
      Put("GCD "); Put( numbers.gcd(arg1,arg2)'Image); New_Line ;
   end Binary ;
begin
   if Argument_Count = 1
   then 
      Unary;
   end if ;
   if Argument_Count = 2
   then
      Binary ;
   end if ;
end Num;
