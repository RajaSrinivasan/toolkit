with GNAT.Strings ;
package frame is
   type DataItem_Type is abstract tagged record
      name : GNAT.Strings.String_Access ;
   end record;
   type DataItems_Type is array (integer range <>) of access DataItem_Type ;
end frame ;