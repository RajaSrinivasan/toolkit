with Ada.Command_Line ; use Ada.Command_Line;
with Ada.Text_IO; use Ada.Text_IO;
with npy ;

procedure Npyfile is
   f : npy.File_Type ;
   v : npy.data_type ;
   vals : npy.ValuesPtr_Type ;

   procedure Show_Signed_Integer is
      ce : Integer := npy.ElementSize (f) ;
      c : Integer := Integer(npy.ValueSize (f)) / ce ;
      ivals : array(1..c) of Integer ;
         for ivals'Address use vals.all'Address ;
      livals : array(1..c) of Long_Integer ;
         for livals'Address use vals.all'Address ;
   begin
      if ce = 4
      then
         for i in 1..c
         loop
            Put(i'Image); Put(" => ");
            Put(ivals(i)'Image); 
            New_Line ;
         end loop ;
      elsif ce = 8
      then
         for i in 1..c
         loop
            Put(i'Image); Put(" => ");
            Put(livals(i)'Image); 
            New_Line ;
         end loop ;
      else
         Put_Line("Unsupported Element Size");
      end if ;
   end Show_Signed_Integer;

   procedure Show_Floating is
      ce : Integer := npy.ElementSize (f) ;
      c : Integer := Integer(npy.ValueSize (f)) / ce ;
      fvals : array(1..c) of Float ;
         for fvals'Address use vals.all'Address ;
      lfvals : array(1..c) of Long_Float ;
         for lfvals'Address use vals.all'Address ;
   begin
      if ce = 4
      then
         for i in 1..c
         loop
            Put(i'Image); Put(" => ");
            Put(fvals(i)'Image); 
            New_Line ;
         end loop ;
      elsif ce = 8
      then
         for i in 1..c
         loop
            Put(i'Image); Put(" => ");
            Put(lfvals(i)'Image); 
            New_Line ;
         end loop ;
      else
         Put_Line("Unsupported Element Size");
      end if ;
   end Show_Floating ;

begin
   f := npy.Open( Argument(1) );
   npy.Show(f);
   v := npy.ValueType (f);
   Put("Data type "); Put_Line( v'Image );
   Put("Value Size "); Put_Line( npy.ValueSize(f)'Image);
   vals := npy.Values( f );
   case v is
      when npy.signed_integer => Show_Signed_Integer ;
      when npy.floating => Show_Floating ;
      when others =>
         Put("Unsupported data type");
         New_Line ;
   end case ;
end Npyfile;
