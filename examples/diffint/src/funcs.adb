Pragma Style_Checks("Off");
with Ada.Numerics.Elementary_Functions ; use Ada.Numerics.Elementary_Functions;
package body funcs is 

   overriding
   function Val( f : Sinusoid ; x : numlib.RealType ) return numlib.RealType is
   begin
      return Sin( x );
   end Val ;

   -- codemd: begin segment=Impl caption=Implementation
   overriding
   function Val( f : PolySinusoid ; x : numlib.RealType ) return numlib.RealType is
   begin
      return cos(x) +
             sqrt( 1.0 + x**2) + -- *
                sin(x) ** 3 + -- *
                cos(x) ** 3 ;
   end Val ;
   -- codemd: end
   
end funcs ;