with Ada.Text_IO; use Ada.Text_IO;

with npy.dict;

package body npy.dict is 

   procedure SetDict( f : in out File_Type ) is
      procedure organize( c : dict_pkg.Cursor ) is
         de : dictentry := dict_pkg.Element(c) ;
      begin
         if de.name = "descr"
         then
            f.descr := new String'(S(de.value)) ;
         elsif de.name = "fortran_order"
         then
            if de.Value = "True"
            then
               f.fortran_order := true ;
            else
               f.fortran_order := false ;
            end if ;
         elsif de.name = "shape"
         then
            f.shapestr := new String'( S( de.value ));
            SetShape (f , de.value );
         end if ;
      end organize ;
   begin
      f.dict := Value( f.header.all );
      f.dict.Iterate( organize'Access );
   end SetDict ;

   function Value( str : String ) return Dictionary is

      result : Dictionary ;
      baredict : VString ;
      curString : VString_Var ;
      barepat : Pattern := '{' &
                              Arb * baredict & 
                           '}' ;
      entrykey , entryval : VString ;

      keypat : Pattern :=     "'" &
                              Arb * entrykey &
                              "'" &
                              Arb &
                              ":" ;
      shapepat : Pattern := 
                              '(' &
                              Arb * entryval &
                              ')' ;

      valpat : Pattern := Arb * entryval &
                           "," ;

      newentry : dictentry ;
   begin
      if Match( str , barepat )
      then
         if debug
         then
            Put("Extracted dictinary "); 
            Put_Line( S( baredict ) );
         end if ;
         curString := baredict ;
         loop
            if Match( curString , keypat , "" )
            then
               if debug
               then
                  Put("Entry Key "); Put(S(entrykey)) ; New_Line ;
               end if ;
               newentry.name := entrykey ;
               if entrykey = "shape"
               then
                  if Match( curString , shapepat , "" )
                  then
                     if debug
                     then
                        Put("Found shape "); Put_Line( S(entryval) );
                     end if ;
                     newentry.value := entryval ;
                     result.Append( newentry );
                  else
                     raise npy.dict.SYNTAX_ERROR with "cannot determine shape" ;
                  end if ;
               else
                  if Match( curString , valpat , "" )
                  then
                     if debug
                     then
                        Put("Found value "); Put_Line( S(entryval)) ;
                     end if ;
                     newentry.value := entryval ;
                     result.Append( newentry );
                  else
                        raise npy.dict.SYNTAX_ERROR with "cannot establish value" ;
                  end if ;
               end if ;
            else
               exit ;
            end if ;
         end loop ;
      else
         Put_Line("Failed to find the bare dictionary");
         raise npy.dict.SYNTAX_ERROR;
      end if ;
      return result;
   end Value ;

   function Image( d : Dictionary ) return String is
      result : Unbounded_String := Null_Unbounded_String ;
   begin
      return To_String(result) ;
   end Image ;


   procedure SetShape (f : in out File_Type; shapestrarg : VString ) is
      shapestr : VString := shapestrarg ;
      Digs : constant Pattern := Span("0123456789");
      limstr : VString ;
      limpat : constant Pattern := Digs * limstr ;
      termpat : constant Pattern := Any(",") ;
   begin
      loop
         if Match( shapestr , limpat , "" )
         then
            f.Shape.Append( Integer'Value( S(limstr) ));
            if Match( shapestr , termpat , "")
            then
               null ;
            else
               return ;
            end if ;
         else
            return ;
         end if ;
      end loop ;
   end SetShape ;


   procedure ShowEntry( c : dict_pkg.Cursor ) is
      de : dictentry := dict_pkg.Element(c) ;
   begin
      Put( S( de.name) );
      Put(" => ");
      Put( S( de.value ));
      New_Line;
   end ShowEntry ;

   procedure Show( d : Dictionary ) is
   begin
      d.Iterate( showEntry'Access );
   end Show ;

   procedure ShowEntry( c : shape_pkg.Cursor ) is
   begin
      Put( shape_pkg.Element(c)'Image );
      Put(", ");
   end ShowEntry ;

   procedure Show( s : ShapeType ) is
   begin
      Put("Shape is : ");
      s.Iterate( showEntry'Access ) ;
      New_Line ;
   end ;
end npy.dict ;
