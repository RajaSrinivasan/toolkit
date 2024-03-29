package body Morsecode is

   ---------------
   function Translate (C : Character) return Letter_Representation is
   begin
      case C is
         when 'A' =>
            return (Dot, Dash);
         when 'B' =>
            return (Dash, Dot, Dot, Dot);
         when 'C' =>
            return (Dash, Dot, Dash, Dot);
         when 'D' =>
            return (Dash, Dot, Dot);
         when 'E' =>
            return Letter_Representation'(1 => Dot);
         when 'F' =>
            return (Dot, Dot, Dash, Dot);
         when 'G' =>
            return (Dash, Dash, Dot);
         when 'H' =>
            return (Dot, Dot, Dot, Dot);
         when 'I' =>
            return (Dot, Dot);
         when 'J' =>
            return (Dot, Dash, Dash, Dash);
         when 'K' =>
            return (Dash, Dot, Dash);
         when 'L' =>
            return (Dot, Dash, Dot, Dot);
         when 'M' =>
            return (Dash, Dash);
         when 'N' =>
            return (Dash, Dot);
         when 'O' =>
            return (Dash, Dash, Dash);
         when 'P' =>
            return (Dot, Dash, Dash, Dot);
         when 'Q' =>
            return (Dash, Dash, Dot, Dash);
         when 'R' =>
            return (Dot, Dash, Dot);
         when 'S' =>
            return (Dot, Dot, Dot);
         when 'T' =>
            return Letter_Representation'(1 => Dash);
         when 'U' =>
            return (Dot, Dot, Dash);
         when 'V' =>
            return (Dot, Dot, Dot, Dash);
         when 'W' =>
            return (Dot, Dash, Dash);
         when 'X' =>
            return (Dash, Dot, Dot, Dash);
         when 'Y' =>
            return (Dash, Dot, Dash, Dash);
         when 'Z' =>
            return (Dash, Dash, Dot, Dot);

         when '0' =>
            return (Dash, Dash, Dash, Dash, Dash);
         when '1' =>
            return (Dot, Dash, Dash, Dash, Dash);
         when '2' =>
            return (Dot, Dot, Dash, Dash, Dash);
         when '3' =>
            return (Dot, Dot, Dot, Dash, Dash);
         when '4' =>
            return (Dot, Dot, Dot, Dot, Dash);
         when '5' =>
            return (Dot, Dot, Dot, Dot, Dot);
         when '6' =>
            return (Dash, Dot, Dot, Dot, Dot);
         when '7' =>
            return (Dash, Dash, Dot, Dot, Dot);
         when '8' =>
            return (Dash, Dash, Dash, Dot, Dot);
         when '9' =>
            return (Dash, Dash, Dash, Dash, Dot);
         when others =>
            raise Unsupported_Character;
      end case;
   end Translate;

   function Span( a : Alphabet ) return duration is
   begin
      case a is
         when dot => return 1.0 ;               -- dit/dot
         when dash => return 3.0 ;              --
         when minigap => return 1.0 ;           -- intra letter gap
         when gap => return 2.0 ;               -- inter letter gap
         when macrogap => return 4.0 ;          -- inter word gap
      end case ;
   end Span ;

end Morsecode;
