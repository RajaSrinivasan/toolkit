with Ada.Strings.Fixed ;
with Values; 

package body fields is

    function Split( full : String ;
                    separator : String := "," ;
                    fmt : String := "" )
                    return IntFieldsPkg.Vector is
              
      result : IntFieldsPkg.Vector;
      st : integer := full'first ;
      idx : natural ;
      procedure Add_Id(ids : string ) is
      begin
        if fmt'Length > 0
        then
            result.Append( Values.Value(ids,fmt) );
        else
            result.Append(  Integer'Value(ids) ) ;
        end if ;
      end Add_Id ;      
   begin
      while st < full'last
      loop
         idx := Ada.Strings.Fixed.Index( full , separator , st );
         if idx = 0
         then
            if st < full'last
            then
               --Put_Line( ids(st..ids'last) ) ;
               Add_Id(full(st..full'last));
               st := full'last + 1; 
            end if ;
         else
            --Put_Line( ids(st..idx-1) );
            Add_Id(full(st..idx-1));
            st := idx + 1 ;
         end if ;
      end loop ;
      return result;
   end Split ;
end fields ;
