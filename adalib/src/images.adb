with System ; use System ;
with Interfaces.C ; use Interfaces.C ;

package body images is

   procedure printf_int
  (format : Interfaces.C.char_array;
   value  : Interfaces.C.int)
     with Import,
       Convention    => C_Variadic_1,
       External_Name => "printf";

   function snprintf_int
     (buffer : System.Address ;
      bufsize : Interfaces.C.size_t ;
      format : Interfaces.C.char_array ;
      value  : Interfaces.C.int) return Interfaces.C.int
     with Import,
       Convention    => C_Variadic_1,
     External_Name => "snprintf";

   function Image( format : String ; value : Integer ) return String is
      buffer : aliased String(1..32) ;
      imglen : Interfaces.C.int ;
   begin
      imglen := snprintf_int( buffer(1)'Address , Interfaces.C.size_t(buffer'length) ,
                          Interfaces.C.To_C( format ) ,
                          Interfaces.C.int(value) ) ;
      return buffer(1..Integer(imglen-1));
   end Image ;

end images ;
