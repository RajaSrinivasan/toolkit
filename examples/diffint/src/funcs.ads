with numlib ;
package funcs is

   type Sinusoid is new numlib.Fx with null record ;

   overriding
   function Val( f : Sinusoid ; x : numlib.RealType ) return numlib.RealType ;

   tf : aliased Sinusoid ;


   -- codemd: begin segment=Spec caption=Specification 
   type PolySinusoid is new numlib.Fx with null record ;

   overriding
   function Val( f : PolySinusoid ; x : numlib.RealType ) return numlib.RealType ;

   tpf : aliased PolySinusoid ;
   -- codemd: end

end funcs ;