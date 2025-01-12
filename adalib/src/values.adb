with Interfaces.C;      use Interfaces.C;
with Ada.Text_IO;       use Ada.Text_IO;
with Ada.Strings.Fixed; use Ada.Strings.Fixed;
package body values is
   use Interfaces;
   function sscanf
     (v   : Interfaces.C.char_array; f : Interfaces.C.char_array;
      val : access Interfaces.C.int) return Interfaces.C.int with
     Import, Convention => C_Variadic_2, External_Name => "sscanf";

   function Value (format : String; value : String) return Integer is
      ival   : aliased Interfaces.C.int;
      status : Interfaces.C.int;
   begin
      status :=
        sscanf
          (Interfaces.C.To_C (value), f => Interfaces.C.To_C (format),
           val                          => ival'Access);
      if status /= 1 then
         raise FORMAT_ERROR;
      end if;

      return Integer (ival);
   end Value;

   function sscanf
     (v   : Interfaces.C.char_array; f : Interfaces.C.char_array;
      val : access Interfaces.C.unsigned) return Interfaces.C.int with
     Import, Convention => C_Variadic_2, External_Name => "sscanf";

   function Value
     (format : String; value : String) return Interfaces.Unsigned_32
   is
      uval   : aliased Interfaces.C.unsigned;
      status : Interfaces.C.int;
   begin
      status :=
        sscanf
          (Interfaces.C.To_C (value), f => Interfaces.C.To_C (format),
           val                          => uval'Access);
      if status /= 1 then
         raise FORMAT_ERROR;
      end if;
      return Unsigned_32 (uval);
   end Value;

   function sscanf
     (v   : Interfaces.C.char_array; f : Interfaces.C.char_array;
      val : access Interfaces.C.C_float) return Interfaces.C.int with
     Import, Convention => C_Variadic_2, External_Name => "sscanf";

   function Value (format : String; value : String) return Float is
      fval   : aliased Interfaces.C.C_float;
      status : Interfaces.C.int;
   begin
      status :=
        sscanf
          (Interfaces.C.To_C (value), f => Interfaces.C.To_C (format),
           val                          => fval'Access);
      if status /= 1 then
         raise FORMAT_ERROR;
      end if;

      return Float (fval);
   end Value;

   function Value (format : String; value : String) return Long_Float is
      fval   : aliased Interfaces.C.C_float;
      status : Interfaces.C.int;
   begin
      status :=
        sscanf
          (Interfaces.C.To_C (value), f => Interfaces.C.To_C (format),
           val                          => fval'Access);
      if status /= 1 then
         raise FORMAT_ERROR;
      end if;

      return Long_Float (fval);
   end Value;

   function Value (format : String; value : String) return Interfaces.C.double
   is
      fval   : aliased Interfaces.C.C_float;
      status : Interfaces.C.int;
   begin
      status :=
        sscanf
          (Interfaces.C.To_C (value), f => Interfaces.C.To_C (format),
           val                          => fval'Access);
      if status /= 1 then
         raise FORMAT_ERROR;
      end if;

      return Interfaces.C.double (fval);
   end Value;

   type struct_tm is record
      tm_sec   : int;
      tm_min   : int;
      tm_hour  : int;
      tm_mday  : int;
      tm_mon   : int;
      tm_year  : int;
      tm_wday  : int;
      tm_yday  : int;
      tm_isdst : int;
   end record;

   function strftime
     (str    : Interfaces.C.char_array; maxsize : size_t;
      format : Interfaces.C.char_array; timptr : access struct_tm)
      return size_t with
     Import, Convention => C, External_Name => "strftime";

end values;
