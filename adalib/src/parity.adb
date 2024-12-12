package body parity is

   function BitCount( byte : Unsigned_8 ) return BitCountType is
      result : Natural := 0 ;
      mask : Unsigned_8 := 1 ;
   begin
      for b in 1..8
      loop
         if mask = (mask and byte)
         then
            result := result + 1 ;
         end if ;
         mask := Shift_Left(mask,1) ;
      end loop ;
      return BitCountType(result) ;
   end BitCount ;

   odd_mask : constant := 2#0000_0001# ;
   function ParityBit( byte : Unsigned_8 ; spec : ParityType := Odd ) return ParityBitType is
      bc : constant Unsigned_8 := Unsigned_8(BitCount(byte)) ;
   begin
      if odd_mask = (bc and odd_mask)
      then
         case spec is
            when Odd => return Low ;
            when Even => return High ;
         end case ;
      else
         case spec is
            when Odd => return High ;
            when Even => return Low ;
         end case ;
      end if ;
   end ParityBit ;

   function Matches( byte : Unsigned_8 ; spec : ParityType ; parbit : ParityBitType ) return boolean is
      reqpar : constant ParityBitType := ParityBit( byte , spec ) ;
   begin
      if reqpar = parbit
      then
         return true ;
      else
         return false ;
      end if ;
   end Matches ;

end parity ;
