package body numlib.differentiation is

   function Derivative (f : FxPtr; 
                        X1, X2 : RealType ) return RealType is
      XDelta : constant RealType := X2 - X1 ;
      H : constant RealType := f.Val(X2) - f.Val(X2) ;
   begin
      return H/XDelta ;
   end Derivative;

end numlib.differentiation; 