with Ada.Containers ;
with csv ;
separate (tables)
--codemd: begin segment=Load caption=Load the table from csv
procedure Load( filename : String ; table : in out TableType ; sep : String := ";") is
   use type Ada.Containers.Count_Type;
   tblfile : csv.File_Type ;
begin
   tblfile := csv.Open( filename , separator => sep , fieldnames => false );
   loop
      for fld in 0 .. TablePkg.Length(table)-1
      loop 
         declare
            colname : String := To_String(TablePkg.Element(table,Integer(fld)).name) ;
            colval : String := csv.Field(tblfile,Integer(fld)+1) ;
         begin
            TablePkg.Element(table,Integer(fld)).Append( colval );
         end ;
      end loop ;
      if csv.End_Of_File(tblfile)
      then
         exit ;
      end if ;
      csv.Get_Line(tblfile);
   end loop ;
   csv.Close(tblfile);
end Load ;
--codemd: end
   