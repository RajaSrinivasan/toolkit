package body numlib.integration is

   function Newton_Coates_3 (f : FxPtr; X1, X2 : RealType) return RealType is

      C            : constant RealType := -1.0 / 90.0;
      W1           : constant RealType := 1.0 / 3.0;
      W2           : constant RealType := 4.0 / 3.0;
      W3           : constant RealType := 1.0 / 3.0;
      MIDX         : constant RealType := (X1 + X2) / 2.0;
      Y1, Y2, MIDY : RealType;
      H            : constant RealType := MIDX - X1;
   begin
      Y1   := f.Val (X1);
      Y2   := f.Val (X2);
      MIDY := f.Val (MIDX);

      return H * (W1 * Y1 + W2 * MIDY + W3 * Y2);

   end Newton_Coates_3;

   function Newton_Coates_4 (f : FxPtr; X1, X2 : RealType) return RealType is

      C  : constant RealType := -3.0 / 80.0;
      W1 : constant RealType := 3.0 / 8.0;
      W2 : constant RealType := 9.0 / 8.0;
      W3 : constant RealType := 9.0 / 8.0;
      W4 : constant RealType := 3.0 / 8.0;
      H  : constant RealType := (X2 - X1) / 3.0;

   begin
      return
        H *
        (W1 * f.Val (X1) + W2 * f.Val (X1 + H) + W3 * f.Val (X1 + H * 2.0) +
         W4 * f.Val (X2));
   end Newton_Coates_4;

   function Newton_Coates_5 (f : FxPtr; X1, X2 : RealType) return RealType is

      C  : constant RealType := -8.0 / 945.0;
      W1 : constant RealType := 14.0 / 45.0;
      W2 : constant RealType := 64.0 / 45.0;
      W3 : constant RealType := 24.0 / 45.0;
      W4 : constant RealType := 64.0 / 45.0;
      W5 : constant RealType := 14.0 / 45.0;
      H  : constant RealType := (X2 - X1) / 4.0;
   begin
      return
        H *
        (W1 * f.Val (X1) + W2 * f.Val (X1 + H) + W3 * f.Val (X1 + H * 2.0) +
         W4 * f.Val (X1 + H * 3.0) + W5 * f.Val (X2));

      --W5 * f.Val X2) ) ;
   end Newton_Coates_5;

end numlib.integration;
