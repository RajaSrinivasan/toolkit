with Ada.Containers.Vectors ;

package numlib is

   subtype RealType is Float ;
   eps : constant RealType := 0.0001 ;
   type RealArray is array (integer range <>) of RealType ;
   package RealVectors_Pkg is new Ada.Containers.Vectors( Natural , RealType );
   use RealVectors_Pkg ;
   function Convert( a : RealArray ) return Vector ;
   function Convert( v : Vector ) return RealArray ;

   function Create( length : Natural ; default : RealType := RealType'first ) return Vector ;
   function Create( from : Vector ) return Vector ;
   function Create( length : Natural ; low, high : RealType ) return Vector ;
   function Create( length : Natural ;
                    populate : not null access function ( length, idx : Natural ) return RealType ) 
                    return Vector ;
   procedure Set( v : in out Vector ; value : RealType );

   -- Basic arithmetic support
   procedure Add( v : in out Vector ; value : RealType );
   procedure Sub( v : in out Vector ; value : RealType );
   procedure Mult( v : in out Vector ; value : RealType ) ;
   procedure Div( v : in out Vector ; value : RealType ) ;

   -- Pairwise arithmetic support
   procedure Add( v : in out Vector ; value : Vector );
   procedure Sub( v : in out Vector ; value : Vector );
   procedure Mult( v : in out Vector ; value : Vector ) ;
   procedure Div( v : in out Vector ; value : Vector ) ;

   function Sum( v : Vector ) return RealType ;

   procedure Apply( v : in out Vector ;
                    modifier : not null access function( value : RealType) return RealType );
end numlib ;
