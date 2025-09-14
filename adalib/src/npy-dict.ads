
with gnat.spitbol.patterns ; use gnat.Spitbol.Patterns ;

package npy.dict is
   use GNAT.Spitbol ;
   SYNTAX_ERROR : exception ;
   function Value( str : String ) return Dictionary ;
   procedure SetDict( f : in out File_Type );
   procedure SetShape (f : in out File_Type; shapestrarg : VString );
   function Image( d : Dictionary ) return String ;
   procedure Show( d : Dictionary );
   procedure Show( s : ShapeType );

end npy.dict ;