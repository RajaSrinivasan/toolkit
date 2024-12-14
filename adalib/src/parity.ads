with Interfaces ; use Interfaces ;
package parity is

-- codemd: begin segment=Basic caption=basic definitions
   type ParityType is (
      Odd,
      Even
   ) ;

   type ParityBitType is (
      Low ,
      High
   ) ;

   type BitCountType is new Natural range 0..Unsigned_8'Machine_Size ;
-- codemd: end

   function BitCount( byte : Unsigned_8 ) return BitCountType ;
   function ParityBit( byte : Unsigned_8 ; spec : ParityType := Odd ) return ParityBitType ;
   function Matches( byte : Unsigned_8 ; spec : ParityType ; parbit : ParityBitType ) return boolean ;

end parity ;
