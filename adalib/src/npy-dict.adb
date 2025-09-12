with Ada.Text_IO; use Ada.Text_IO;
with git;
with gnat.spitbol.patterns ; use gnat.Spitbol.Patterns ;
with npy.dict;

package body npy.dict is 

   use gnat.spitbol ;

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
         Put("Extracted dictinary "); 
         Put_Line( S( baredict ) );
         curString := baredict ;
         loop
            if Match( curString , keypat , "" )
            then
               Put("Entry Key "); Put(S(entrykey)) ; New_Line ;
               newentry.name := entrykey ;
               if entrykey = "shape"
               then
                  if Match( curString , shapepat , "" )
                  then
                     Put("Found shape "); Put_Line( S(entryval) );
                     newentry.value := entryval ;
                     result.Append( newentry );
                  else
                     raise npy.dict.SYNTAX_ERROR with "cannot determine shape" ;
                  end if ;
               else
                  if Match( curString , valpat , "" )
                  then
                        Put("Found value "); Put_Line( S(entryval)) ;
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


   procedure SetShape (f : in out File_Type)  is
      shape : VString ;
      Digs : constant Pattern := Span("0123456789");
      limstr : VString ;
      limpat : constant Pattern := Digs * limstr ;
      procedure Find( c : Dict_Pkg.Cursor ) is
         ce : dictentry := Dict_Pkg.Element(c) ;
      begin
         if ce.name = "shape"
         then
            shape := ce.value ;
         end if ;
      end Find ;
   begin
      f.dict.Iterate( Find'Access );
      loop
         if Match( shape , limpat , "" )
         then
            f.DataShape.Append( Integer'Value( S(limstr) ));
            if Match( shape , "," , "")
            then
               null ;
            else
               exit ;
            end if ;
         else
            exit ;
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
   procedure Show( s : Shape ) is
   begin
      Put("Shape is : ");
      s.Iterate( showEntry'Access ) ;
      New_Line ;
   end ;
end npy.dict ;
