generic
   type Item_Type is private ;
package fifo is
   type Contents_Type is array (Integer range <>) of aliased Item_Type;
   type Buffer_Type (capacity : Integer ) is
      record
         contents : Contents_Type(1..capacity) ;
         push_to : Integer := 1 ;
         pull_from : Integer := 0 ;
         count : Integer := 0 ;
      end record ;

   empty_Error : exception ;
   overflow_Error : exception ;

   function Create( cap : Integer := 64 ) return Buffer_Type ;
   procedure Push( buf : in out Buffer_Type; item : Item_Type );
   procedure Get( buf : in out Buffer_Type; item : out Item_Type );
   function Empty( buf : Buffer_Type ) return Boolean ;
   function Full( buf : Buffer_Type ) return Boolean ;

end fifo ;
