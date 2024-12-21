-- Periodic Table of Elements
-- Source: https://pubchem.ncbi.nlm.nih.gov/periodic-table/
with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Command_Line;      use Ada.Command_Line;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with GNAT.Source_Info;

with tables;
with integer_column;
with float_column;

procedure Ptable is
   myname  : constant String := GNAT.Source_Info.Enclosing_Entity;
   verbose : Boolean         := True;

   procedure show( tbl : tables.TableType ; rn : Natural ) is
   begin
      -- Put("Row "); 
      Put(rn'Image);
      for c in 0 .. tables.Columns( tbl )-1
      loop
         -- Put( To_String(tables.TablePkg.Element(tbl,c).name)); Put(" => ");
         Put(ASCII.ht);
         Put( tables.TablePkg.Element(tbl,c).Image(rn)) ;
      end loop ;
      New_Line ;
   end show ;

   procedure T1 is
      tname         : constant String   := GNAT.Source_Info.Enclosing_Entity;

      atomic_number : tables.ColPtrType := integer_column.Create("AtomicNumber");
      symbol : tables.ColPtrType := tables.CreateStringColumn ("Symbol");
      name          : tables.ColPtrType := tables.CreateStringColumn ("Name");
      atomic_mass   : tables.ColPtrType := float_column.Create ("AtomicMass");
      pt            : tables.TableType;
   begin
      pt.Append (atomic_number);
      pt.Append (name);
      pt.Append (symbol);
      pt.Append (atomic_mass);

      tables.Load( Argument(1) , pt , "," );
      tables.Iterate( pt , show'access );
   end T1;
begin
   if Argument_Count > 0 then
      T1;
   end if;
end Ptable;
