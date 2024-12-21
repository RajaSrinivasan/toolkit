with Ada.Containers ;
with csv ;
separate (tables)
procedure Load( filename : String ; table : in out TableType ; sep : String := ";") is
   use type Ada.Containers.Count_Type;
   tblfile : csv.File_Type ;
begin
   tblfile := csv.Open( filename , separator => sep , fieldnames => false );
   while not csv.End_Of_File(tblfile)
   loop
      csv.Get_Line(tblfile);
      for fld in 0 .. TablePkg.Length(table)-1
      loop 
         declare
            colname : String := To_String(TablePkg.Element(table,Integer(fld)).name) ;
            colval : String := csv.Field(tblfile,Integer(fld)+1) ;
         begin
            TablePkg.Element(table,Integer(fld)).Append( colval );
         end ;
      end loop ;
   end loop ;
   csv.Close(tblfile);
end Load ;
   