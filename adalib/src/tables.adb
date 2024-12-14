with Ada.Calendar.Formatting ;

package body tables is

   procedure Append( vec : in out IntegerColumnType ; valStr : String ; formatStr : String := "" ) is
      val : Integer := Integer'Value(valStr) ;
   begin
      vec.Values.Append(val);
   end Append ;

    procedure Append( vec : in out RealColumnType ; valStr : String ; formatStr : String := "" ) is
      val : Long_Float := Long_Float'Value(valStr) ;
   begin
      vec.Values.Append(val);
   end Append ;

   procedure Append( vec : in out StringColumnType ; valStr : String ; formatStr : String := "" ) is
   begin
      vec.Values.Append(valStr);
   end Append ;


   procedure Append( vec : in out TimeColumnType ; valStr : String ; formatStr : String := "" ) is
      val : Ada.Calendar.Time := Ada.Calendar.Formatting.Value(valStr);
   begin
      vec.Values.Append(val);
   end Append ;

   function "=" (Left,Right : Ada.Calendar.Time) return boolean is
      use Ada.Calendar ;
   begin
      if Left < Right
      then
         return false ;
      elsif Left > Right
      then
         return false ;
      else
         return true ;
      end if ;
   end "=" ;
end tables ;