package body numlib.polynomials is
-- codemd: begin segment=Eval caption=Evaluate a polynomial
   function Evaluate( v : Vector ; x : RealType ) return RealType is
      result : RealType := 0.0 ;
      procedure Evaluate( c : Cursor ) is
      begin
         result := result * x + Element(c) ;
      end Evaluate ;
   begin
      v.Reverse_Iterate( Evaluate'access ) ;
      return result ;
   end Evaluate ;
-- codemd: end
end numlib.polynomials ;