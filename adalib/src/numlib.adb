with Ada.Text_Io; use Ada.Text_Io;
--with Ada.Numerics.Elementary_Functions ;

package body numlib is
   function Convert( a : RealArray ) return Vector is
      result : Vector ;
      idx : Integer := a'First ;
      procedure Copy( c : cursor ) is
      begin
         Replace_Element(result,c,a(idx));
         idx := idx + 1 ;
      end Copy ;
   begin
      result.Set_Length( a'Length );
      result.Iterate(Copy'access);
      return result ;
   end Convert ;
   function Convert( v : Vector ) return RealArray is
      result : RealArray(1..Integer(Length(v))) ;
      ptr : Integer := 0 ;
      procedure Copy( c : cursor ) is
      begin
         ptr := ptr + 1 ;
         result(ptr) := Element( c );
      end Copy ;
   begin
      v.Iterate(Copy'access);
      return result ;
   end Convert ;

   function Create( length : Natural ; default : RealType := RealType'first ) return Vector is
      result : Vector ;
   begin
      result := To_Vector( default , Ada.Containers.Count_Type(length) );
      return result ;
   end Create ;

   function Create( from : Vector ) return Vector is
      result : Vector ;
   begin
      result := To_Vector( 0.0 , from.Length );
      Add( result , from );
      return result ;
   end Create ;

   function Create( length : Natural ; low, high : RealType ) return Vector is
      result : Vector := Create( length );
      val : RealType := low ;
      vdelta : constant RealType := (high - low) / float(length-1) ;
   begin
      for idx in 0..length-1
      loop
         result.Replace_Element(  idx , val );
         val := val + vdelta ;
      end loop ;
      return result ;
   end Create ;

   function Create( length : Natural ;
                    populate : not null access function ( length, idx : Natural ) return RealType ) return Vector is
      use type Ada.Containers.Count_Type ;
      result : Vector ;
   begin
      result.Set_Length( Ada.Containers.Count_Type(length) );
      for idx in 0..length-1
      loop
         Replace_Element( result , idx , populate(length,idx) );
      end loop ;
      return result ;
   end Create ;

   procedure Set( v : in out Vector ; value : RealType ) is
      procedure Set( c : cursor ) is
      begin
         Replace_Element( v , c , value );
      end Set ;
   begin
      v.Iterate( Set'Access );
   end Set;

   procedure Add( v : in out Vector ; value : RealType ) is
      procedure Add( c : cursor ) is
      begin
         Replace_Element( v , c , value + Element(c) );
      end Add ;
   begin
      v.Iterate( Add'access );
   end Add ;

   procedure Sub( v : in out Vector ; value : RealType ) is
      procedure Sub( c : cursor ) is
      begin
         Replace_Element( v , c , value - Element(c) );
      end Sub ;
   begin
      v.Iterate( Sub'access );
   end Sub ;

   procedure Mult( v : in out Vector ; value : RealType ) is
      procedure Mult( c : cursor ) is
      begin
         Replace_Element( v , c , value * Element(c) );
      end Mult ;
   begin
      v.Iterate( Mult'access );
   end Mult ;

   procedure Div( v : in out Vector ; value : RealType ) is
      procedure Div( c : cursor ) is
      begin
         Replace_Element( v , c , value / Element(c) );
      end Div ;
   begin
      v.Iterate( Div'access );
   end Div ;

   procedure Add( v : in out Vector ; value : Vector ) is
      procedure add( c : Cursor ) is
         idx : constant Extended_Index := To_Index(c);
      begin
         Replace_Element( v , c , Element(c) + Element(value,idx) );
      end add ;
   begin
      v.Iterate(add'access);
   end Add ;

   procedure Sub( v : in out Vector ; value : Vector ) is
      procedure sub( c : Cursor ) is
         idx : constant Extended_Index := To_Index(c);
      begin
         Replace_Element( v , c , Element(c) - Element(value,idx) );
      end sub ;
   begin
      v.Iterate(sub'access);
   end Sub ;

   procedure Mult( v : in out Vector ; value : Vector ) is
      procedure Mult( c : Cursor ) is
         idx : constant Extended_Index := To_Index(c);
      begin
         Replace_Element( v , c , Element(c) * Element(value,idx) );
      end Mult ;
   begin
      v.Iterate(Mult'access);
   end Mult ;

   procedure Div( v : in out Vector ; value : Vector ) is
      procedure Div( c : Cursor ) is
         idx : constant Extended_Index := To_Index(c);
      begin
         Replace_Element( v , c , Element(c) / Element(value,idx) );
      end Div ;
   begin
      v.Iterate(Div'access);
   end Div ;

   function sum( v : Vector ) return RealType is
      result : RealType := 0.0 ;
      procedure sum( c : cursor ) is
      begin
         result := result + Element(c) ;
      end sum ;
   begin
      v.Iterate( sum'access) ;
      return result ;
   end sum ;

   procedure Apply( v : in out Vector ;
                    modifier : not null access function( value : RealType) return RealType ) is
      procedure apply( c : Cursor ) is
      begin
         Replace_Element( v , c , modifier(Element(C)));
      end apply ;
   begin
      v.Iterate( apply'access );
   end Apply ;

end numlib ;