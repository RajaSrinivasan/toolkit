with System ; use System ;
with Interfaces.C ; use Interfaces.C ;

package body images is

   function snprintf
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
      imglen := snprintf( buffer(1)'Address , Interfaces.C.size_t(buffer'length) ,
                          Interfaces.C.To_C( format ) ,
                          Interfaces.C.int(value) ) ;
      return buffer(1..Integer(imglen ));
   end Image ;

   function snprintf
     (buffer : System.Address ;
      bufsize : Interfaces.C.size_t ;
      format : Interfaces.C.char_array ;
      value  : Interfaces.C.double ) return Interfaces.C.int
     with Import,
       Convention    => C_Variadic_1,
     External_Name => "snprintf";

   function Image( format : String ; value : float ) return String is
      buffer : aliased String(1..32) ;
      imglen : Interfaces.C.int ;
   begin
      imglen := snprintf( buffer(1)'Address , Interfaces.C.size_t(buffer'length) ,
                          Interfaces.C.To_C( format ) ,
                          Interfaces.C.double(value) ) ;
      return buffer(1..Integer(imglen ));
   end Image ;

   function Image( format : String ; value : Long_Float ) return String is
      buffer : aliased String(1..64) ;
      imglen : Interfaces.C.int ;
   begin
      imglen := snprintf( buffer(1)'Address , Interfaces.C.size_t(buffer'length) ,
                          Interfaces.C.To_C( format ) ,
                          Interfaces.C.double(value) ) ;
      return buffer(1..Integer(imglen));
   end Image ;

end images ;
