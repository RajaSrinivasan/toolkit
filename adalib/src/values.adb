with Interfaces.C ; use Interfaces.C ;
package body values is
    use Interfaces ;
   function sscanf
     (v : Interfaces.C.char_array ;
      f : Interfaces.C.char_array ;
      val : access Interfaces.C.int) return Interfaces.C.int
     with Import,
       Convention    => C_Variadic_1,
     External_Name => "sscanf";

    function Value( format : String ; value : String ) return Integer is
        ival : aliased Interfaces.C.int ;
        status : Interfaces.C.int ;
    begin
        status := sscanf
          (Interfaces.C.To_C (value),
           f   => Interfaces.C.To_C(format),
           val => ival'access );
        if status /= 1
        then
            raise FORMAT_ERROR ;
        end if ;

        return Integer(ival) ;
    end Value ;


   function sscanf
     (v : Interfaces.C.char_array ;
      f : Interfaces.C.char_array ;
      val : access Interfaces.C.unsigned) return Interfaces.C.int
     with Import,
       Convention    => C_Variadic_1,
     External_Name => "sscanf";

    function Value( format : String ; value : String ) return Interfaces.Unsigned_32 is
        uval : aliased Interfaces.C.unsigned ;
        status : Interfaces.C.int ;
    begin
        status := sscanf
          (Interfaces.C.To_C (value),
           f   => Interfaces.C.To_C(format),
           val => uval'access );
        if status /= 1
        then
            raise FORMAT_ERROR ;
        end if ;
        return Unsigned_32(uval) ;
    end Value ;

   function sscanf
     (v : Interfaces.C.char_array ;
      f : Interfaces.C.char_array ;
      val : access Interfaces.C.C_Float) return Interfaces.C.int
     with Import,
       Convention    => C_Variadic_1,
     External_Name => "sscanf";

    function Value( format : String ; value : String ) return Float is
        fval : aliased Interfaces.C.C_Float ;
        status : Interfaces.C.int ;
    begin
        status := sscanf
          (Interfaces.C.To_C (value),
           f   => Interfaces.C.To_C(format),
           val => fval'access );
        if status /= 1
        then
            raise FORMAT_ERROR ;
        end if ;

        return Float(fval) ;
    end Value ;

   function sscanf
     (v : Interfaces.C.char_array ;
      f : Interfaces.C.char_array ;
      val : access Interfaces.C.double) return Interfaces.C.int
     with Import,
       Convention    => C_Variadic_1,
     External_Name => "sscanf";

    function Value( format : String ; value : String ) return Long_Float is
        fval : aliased Interfaces.C.double ;
        status : Interfaces.C.int ;
    begin
        status := sscanf
          (Interfaces.C.To_C (value),
           f   => Interfaces.C.To_C(format),
           val => fval'access );
        if status /= 1
        then
            raise FORMAT_ERROR ;
        end if ;

        return Long_Float(fval) ;
    end Value ;


end values ;
