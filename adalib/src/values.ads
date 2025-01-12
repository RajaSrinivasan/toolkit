with Ada.Calendar;

with Interfaces;
with Interfaces.C;

package values is

   FORMAT_ERROR : exception;

   function Value (format : String; value : String) return Integer;
   function Value
     (format : String; value : String) return Interfaces.Unsigned_32;

   function Value (format : String; value : String) return Float;
   function Value (format : String; value : String) return Long_Float;
   function Value (format : String; value : String) return Interfaces.C.double;

end values;
