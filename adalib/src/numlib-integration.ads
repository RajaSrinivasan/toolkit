package numlib.integration is

   function Newton_Coates_3 (f : FxPtr; X1, X2 : RealType) return RealType;

   function Simpsons (f : FxPtr; X1, X2 : RealType) return RealType renames
     Newton_Coates_3;

   function Newton_Coates_4 (f : FxPtr; X1, X2 : RealType) return RealType;

   function Newton_Coates_5 (f : FxPtr; X1, X2 : RealType) return RealType;

end numlib.integration;
