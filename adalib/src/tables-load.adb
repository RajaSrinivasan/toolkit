with Ada.Containers;
with Csv;
separate (tables)
--codemd: begin segment=Load caption=Load the table from csv
procedure Load
  (filename : String; table : in out TableType; sep : String := ";")
is
   use type Ada.Containers.Count_Type;
   tblfile : Csv.File_Type;
begin
   tblfile := Csv.Open (filename, Separator => sep, FieldNames => False);
   loop
      for fld in 0 .. TablePkg.Length (table) - 1 loop
         declare
            --colname : String :=
            --  To_String (TablePkg.Element (table, Integer (fld)).name);
            colval  : constant String := Csv.Field (tblfile, Integer (fld) + 1);
         begin
            TablePkg.Element (table, Integer (fld)).Append (colval);
         end;
      end loop;
      if Csv.End_Of_File (tblfile) then
         exit;
      end if;
      Csv.Get_Line (tblfile);
   end loop;
   Csv.Close (tblfile);
end Load;
--codemd: end
