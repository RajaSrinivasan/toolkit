with Ada.Strings.Fixed;

with values;

package body fields is

   function Split
     (full : String; separator : String := ","; fmt : String := "")
      return IntFieldsPkg.Vector
   is

      result : IntFieldsPkg.Vector;
      st     : Integer := full'First;
      idx    : Natural;
      procedure Add_Id (ids : String) is
      begin
         if fmt'Length > 0 then
            result.Append (values.Value (fmt, ids));
         else
            result.Append (Integer'Value (ids));
         end if;
      end Add_Id;
   begin
      while st < full'Last loop
         idx := Ada.Strings.Fixed.Index (full, separator, st);
         if idx = 0 then
            if st < full'Last then
               --Put_Line( ids(st..ids'last) ) ;
               Add_Id (full (st .. full'Last));
               st := full'Last + 1;
            end if;
         else
            --Put_Line( ids(st..idx-1) );
            Add_Id (full (st .. idx - 1));
            st := idx + 1;
         end if;
      end loop;
      return result;
   end Split;
end fields;
