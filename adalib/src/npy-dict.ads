
package npy.dict is

   SYNTAX_ERROR : exception ;
   function Value( str : String ) return Dictionary ;
   procedure SetShape (f : in out File_Type);
   function Image( d : Dictionary ) return String ;
   procedure Show( d : Dictionary );
   procedure Show( s : Shape );
end npy.dict ;