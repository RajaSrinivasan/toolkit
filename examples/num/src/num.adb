with Ada.Command_Line; use Ada.Command_Line;
with Ada.Text_IO;      use Ada.Text_IO;
with GNAT.Source_Info; use GNAT.Source_Info;

with numbers;
procedure Num is
   procedure Unary is
      arg : Natural := 0 ;
      o    : numbers.OctalDigits_Type;
      d    : numbers.DecimalDigits_Type;
      h    : numbers.HexadecimalDigits_Type;
      divs : numbers.NumbersVector_Pkg.Vector;
      facs : numbers.NumbersVector_Pkg.Vector;
   begin
      for argn in 2 .. Argument_Count
      loop
         arg := Natural'Value (Argument (argn));
         Put("================= Number "); Put(arg'Image); New_Line;

         o   := numbers.Convert (arg);
         Put ("Octal       ");
         Put (numbers.Image (o));
         --New_Line;
         if arg = numbers.Value (o) then
            Put_Line (" Octal back conversion Ok");
         else
            Put_Line (" Octal back conversion Failed");
         end if;

         d := numbers.Convert (arg);
         Put ("Decimal     ");
         Put (numbers.Image (d));
         --New_Line;
         if arg = numbers.Value (d) then
            Put_Line (" Decimal back conversion Ok");
         else
            Put_Line (" Decimal back conversion Failed");
         end if;
         h := numbers.Convert (arg);
         Put ("Hexadecimal ");
         Put (numbers.Image (h));
         -- New_Line;
         if arg = numbers.Value (h) then
            Put_Line (" HexaDecimal back conversion Ok");
         else
            Put_Line (" HexaDecimal back c onversion Failed");
         end if;
         divs := numbers.Divisors (arg);
         Put ("Divisors "); Set_Col(20);
         numbers.Show (divs);
         New_Line ;
         Put("DivisorSum"); Set_Col(20); Put( numbers.DivisorSum(arg)'Image); New_Line ;

         facs := numbers.Factors (arg);
         Put("Prime Factors "); Set_Col(20);
         numbers.Show (facs);
         New_Line ;
         Put("Prime No "); Set_Col(20);
         if numbers.IsPrime (arg) then
            Put_Line ("Yes");
         else
            Put_Line ("No");
         end if;

         Put("Perfect No "); Set_Col(20);
         if numbers.IsPerfect (arg) then
            Put_Line ("Yes");
         else
            Put_Line ("No");
         end if;

        Put("MultiPerfect No "); Set_Col(20);
         if numbers.IsMultiperfect (arg) then
            Put_Line ("Yes");
         else
            Put_Line ("No");
         end if;

         Put("Kaprekar No "); Set_Col(20); 
         if numbers.IsKaprekar(arg)
         then 
            Put_Line("Yes");
         else
            Put_Line("No");
         end if ;

      end loop;

   end Unary;

   procedure Binary is
      arg1, arg2 : Natural ;
      argn : Natural := 2 ;
   begin
      loop
         if Argument_Count >= argn + 1
         then
            arg1 := Natural'Value(Argument(argn));
            arg2 := Natural'Value(Argument(argn+1));
            Put("========================="); Put(arg1'Image) ; Put(" & "); Put_Line(arg2'Image); 
            Put("GCD "); Set_Col(20); Put( numbers.gcd(arg1,arg2)'Image); New_Line ;
            Put("Friendly"); Set_Col(20); Put( numbers.AreFriendly(arg1,arg2)'Image); New_Line;
         else
            exit ;
         end if ;
         argn := argn + 2 ;
      end loop ;
   end Binary ;

begin
   if Argument_Count > 1
   then 
      if Argument(1) = "U"
      then 
         Unary ;
      elsif  Argument(1) = "B"
      then
         Binary ;
      end if ;
   end if ;
end Num;
