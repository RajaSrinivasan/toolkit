with Ada.Calendar ;
with Ada.Containers.Vectors ;
with Ada.Containers.Indefinite_Vectors ;
with Ada.Tags ;
with GNAT.Strings ;

package tables is

   type ColumnType is abstract tagged record
      name : GNAT.Strings.String_Access ;
   end record ;

   procedure Append( vec : in out ColumnType ; valStr : String ; formatStr : String := "" ) is abstract ;

   package IntegerVector_Pkg is new Ada.Containers.Vectors( Natural , Integer );
   type IntegerColumnType is new ColumnType with record
      values : IntegerVector_Pkg.Vector ;
   end record ;
   procedure Append( vec : in out IntegerColumnType ; valStr : String ; formatStr : String := "" ) ;
   ITag : constant String := Ada.Tags.External_Tag(IntegerColumnType'tag) ;
   IName : constant String := Ada.Tags.Expanded_Name(IntegerColumnType'Tag) ;

   package RealVector_Pkg is new Ada.Containers.Vectors( Natural , Long_Float );
   type RealColumnType is new ColumnType with record
      values : RealVector_Pkg.Vector ;
   end record;
   procedure Append( vec : in out RealColumnType ; valStr : String ; formatStr : String := "" ) ;

   package StringVector_Pkg is new Ada.Containers.Indefinite_Vectors( Natural , String );
   type StringColumnType is new ColumnType with record
      values : StringVector_Pkg.Vector ;
   end record ;
   procedure Append( vec : in out StringColumnType ; valStr : String ; formatStr : String := "" ) ;

   function "=" (Left,Right : Ada.Calendar.Time) return boolean ;
   package TimeVector_Pkg is new Ada.Containers.Vectors( Natural , Ada.Calendar.Time );
   type TimeColumnType is new ColumnType with record
      values : TimeVector_Pkg.Vector;
   end record;
   procedure Append( vec : in out TimeColumnType ; valStr : String ; formatStr : String := "" ) ;

   package ColumnVector_Pkg is new Ada.Containers.Indefinite_Vectors( Natural , ColumnType'Class );
   subtype TableType is ColumnVector_Pkg.Vector ;

   -- procedure AddRow( table : in out TableType ; values : StringVector_Pkg.Vector );

   type ValueType is abstract tagged null record ;
   type IntegerValueType is new ValueType with record 
      value : Integer ;
   end record ;
   type RealValueType is new ValueType with record 
      value : Long_Float ;
   end record ;
   type TimeValueType is new ValueType with record 
      value : Ada.Calendar.Time ;
   end record ;
   type StringValueType is new ValueType with record
      value : GNAT.Strings.String_Access;
   end record ;

   package Values_Pkg is new Ada.Containers.Indefinite_Vectors( Natural , ValueType'Class );
   subtype RowType is Values_Pkg.Vector ;

   -- function Get( table : TableType ; rownum : Natural ) return RowType ;
   -- function Append( table : in out TableType ; row : RowType );

end tables ;