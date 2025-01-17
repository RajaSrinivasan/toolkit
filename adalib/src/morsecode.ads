with Ada.Calendar ;
package Morsecode is

   type Alphabet is (Dot, 
                     Dash,
                     minigap ,           -- intra letter gap
                     gap ,               -- inter letter gap
                     macrogap );

   type Letter_Representation is array (Natural range <>) of Alphabet;
   type Letter is access constant Letter_Representation;
   type Word is array (Natural range <>) of Letter;

   function Translate (C : Character) return Letter_Representation;

   Unsupported_Character : exception;

   function Span( a : Alphabet ) return duration ;

end Morsecode;
