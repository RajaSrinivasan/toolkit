with Ada.Calendar ;
with Ada.Containers.Vectors ;
with Ada.Text_Io;

--with Ada.Containers.Indefinite_Vectors ;
--with Ada.Tags ;
--with GNAT.Strings ;
with Ada.Strings.Unbounded ; use Ada.Strings.Unbounded ;

package tables is

   -- codemd: begin segment=Abstract caption=Abstraction of table
   type ColumnType is abstract tagged record
      name : Unbounded_String  ;
   end record ;

   procedure Append( col : in out ColumnType ; value : String ) is abstract ;
   procedure Set( col : in out ColumnType ; idx : Natural ; value : String ) is abstract ;
   function Image( col : in out ColumnType ; idx : Natural ) return String is abstract ;
   function Length( col : ColumnType ) return Natural is abstract;
   procedure Remove( col : in out ColumnType ; idx : Natural ) is abstract ;

   type ColPtrType is access all ColumnType'Class ;
   function Create( name : String ) return ColPtrType is abstract ;
   package TablePkg is new Ada.Containers.Vectors( Natural , ColPtrType );
   subtype TableType is TablePkg.Vector ;
   -- codemd: end

   -- codemd: begin segment=BasicTypes caption=basic data types
   generic 
      type T is private ;
      with function Vfun( s : String ) return T ;
      with function Ifun( v : T ) return String ;
   package ColumnPkg is

      package ColumnValues_Pkg is new Ada.Containers.Vectors( Natural , T ) ;
      subtype ColumnValuesType is ColumnValues_Pkg.Vector ;

      type TColumnType is new ColumnType with record
         values : ColumnValuesType ;
      end record ;

      function Create( name : String ) return ColPtrType ;
      function Length( col : TColumnType ) return Natural ;
      procedure Remove( col : in out TColumnType ; idx : Natural ) ;
      function Get( col : TColumnType ; idx : Natural) return T ;

      procedure Append( col : in out TColumnType ; value : String ) ;
      procedure Set( col : in out TColumnType ; idx : Natural ; value : String ) ;
      function Image( col : in out TColumnType ; idx : Natural ) return String ;

   end ColumnPkg ;
   -- codemd: end

   --codemd: begin segment=StrCol caption=String Columns
   package StringColumnValues_Pkg is new Ada.Containers.Vectors( Natural , Unbounded_String );
   type StringColumnType is new ColumnType with record
      values : StringColumnValues_Pkg.Vector ;
   end record ;
   --codemd: end
   
   function CreateStringColumn( name : String ) return ColPtrType ;
   function Length( col : StringColumnType ) return Natural ;
   procedure Remove( col : in out StringColumnType ; idx : Natural ) ;

   function Get( col : StringColumnType ; idx : Natural) return String ;
   procedure Append( col : in out StringColumnType ; value : String ) ;
   procedure Set( col : in out StringColumnType ; idx : Natural ; value : String ) ;
   function Image( col : in out StringColumnType ; idx : Natural ) return String ;

   -- https://ebird.org/data/download

   -- CSV Files
   procedure Load( filename : String ; table : in out TableType ; sep : String := ";");
   procedure Print( table : TableType ; sep : String := " ; " ; header : boolean := false ;
                    outfile : Ada.Text_Io.File_Type := Ada.Text_Io.Standard_Output ) ;
    procedure Save( filename : String ; table : TableType ; sep : String := ";" ; header : boolean := false );

   function Rows( table : TableType ) return Natural ;
   function Columns( table : TableType ) return Natural ; 

   -- codemd: begin segment=dplyr caption=Operations
   -- Algorithms on tables
   procedure Iterate( table : TableType ;
                      proc : not null access procedure (table : TableType ;
                                                    rownum : Natural)) ;

   procedure Mutate( table : in out TableType ;
                     col : in out ColPtrType ;
                     proc : not null access procedure (table : in out TableType ;
                                                       rownum : Natural ;
                                                       col : in out ColPtrType ));
   
   procedure Filter( table : in out TableType ;
                     remove : not null access function (table : in out TableType ;
                                                       rownum : Natural ) return boolean );
   -- codemd: end
end tables ;