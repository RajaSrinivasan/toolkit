-- codemd: begin segment=Library caption=Predefined Library usage
with Ada.Containers.Indefinite_Vectors;
with GNAT.AWK;
-- codemd: end

-- codemd: begin segment=Spec caption=Specification
package Csv is
   Debug : Boolean := True;
   Duplicate_Column : exception;
   type File_Object_Type is limited private;
   type File_Type is access File_Object_Type;

   subtype Field_Count_Type is Integer range 1 .. 255;
   package String_Vectors_Pkg is new Ada.Containers.Indefinite_Vectors
     (Index_Type => Field_Count_Type, Element_Type => String);

   -- codemd: skipbegin
   -- codemd: begin segment=Interface caption=Interface Specification
   function Open
     (Name : String; Separator : String; FieldNames : Boolean := True)
      return File_Type;
   procedure Close (File : in File_Type);
   function No_Columns (File : File_Type) return Integer;
   function Field_Name (File : File_Type; Column : Integer) return String;
   procedure Get_Line (File : in File_Type);
   function Line_No (File : File_Type) return Integer;
   function End_Of_File (File : File_Type) return Boolean;
   function Field (File : File_Type; Column : Integer) return String;
   function Field (File : File_Type; Name : String) return String;
   procedure Set_Names (file : File_Type; names : String_Vectors_Pkg.Vector);
   function Names (file : File_Type) return String_Vectors_Pkg.Vector;
   -- codemd: end
   -- codemd: skipend
private
   type File_Object_Type is limited record
      Session      : GNAT.AWK.Session_Type;
      No_Columns   : Integer := 0;
      Current_Line : Integer := -1;
      Field_Names  : String_Vectors_Pkg.Vector;
   end record;
end Csv;
-- codemd: end
