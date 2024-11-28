generic
   type T is private ;
package apply is
   type T_Array is array (integer range <>) of T ;
   procedure ToAll( a : T_Array) ;
   function ToAll( a : T_Array ) return T_Array ;
end apply ;

