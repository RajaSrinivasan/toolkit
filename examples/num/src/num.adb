with Ada.Command_Line ; use Ada.Command_Line ;
with Ada.Text_Io; use Ada.Text_Io ;
with numbers ;
procedure Num is
   arg : Natural := Natural'first ;
   o : numbers.OctalDigits_Type ;
   d : numbers.DecimalDigits_Type ;
   h : numbers.HexadecimalDigits_Type ;
begin
   if Argument_Count >= 1
   then
      arg := Natural'Value( Argument(1) );
      o := numbers.Convert( arg );
      Put("Octal       "); Put(numbers.Image(o)); New_LIne ;
      if arg = numbers.Value(o)
      then
         Put_Line("Octal Conversion Ok");
      else
         Put_Line("Octal Conversion Failed");
      end if ;

      d := numbers.Convert( arg );
      Put("Decimal     "); Put(numbers.Image(d)); New_Line ;
      if arg = numbers.Value(d)
      then
         Put_Line("Decimal Conversion Ok");
      else
         Put_Line("Decimal Conversion Failed");
      end if ;
      h := numbers.Convert( arg );
      Put("Hexadecimal "); Put(numbers.Image(h)); New_Line ;
      if arg = numbers.Value(h)
      then
         Put_Line("HexaDecimal Conversion Ok");
      else
         Put_Line("HexaDecimal Conversion Failed");
      end if ;

   end if ;
end Num;
