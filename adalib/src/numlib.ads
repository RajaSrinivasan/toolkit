with Ada.Text_IO; use Ada.Text_IO;
with Ada.Containers.Vectors;

-- codemd: begin segment=Core caption=basic core definitions
package numlib is

   subtype RealType is Float;
   eps : constant RealType := 0.000_1;
   type RealArray is array (Integer range <>) of RealType;
   package RealVectors_Pkg is new Ada.Containers.Vectors (Natural, RealType);
   use RealVectors_Pkg;
   package Sorter_Pkg is new RealVectors_Pkg.generic_sorting( "<" );

   function Convert (a : RealArray) return Vector;
   function Convert (v : Vector) return RealArray;

   function Create
     (length : Natural; default : RealType := RealType'First) return Vector;
   function Create (from : Vector) return Vector;
   function Create (length : Natural; low, high : RealType) return Vector;
   function Create (low, high, step : RealType) return Vector;

-- codemd: end

   function Create
     (length   : Natural;
      populate : not null access function
        (length, idx : Natural) return RealType)
      return Vector;
   procedure Set (v : in out Vector; value : RealType);
   procedure Print
     (v    : Vector; sep : String := ","; linelen : Positive_Count := 80;
      dest : File_Type := Standard_Output);

   function Rev (v : Vector) return Vector;

   -- Basic arithmetic support
   procedure Add (v : in out Vector; value : RealType);
   procedure Sub (v : in out Vector; value : RealType);
   procedure Mult (v : in out Vector; value : RealType);
   procedure Div (v : in out Vector; value : RealType);

   -- codemd: begin segment=Pair caption=Pairwise Arithmetic Support
   -- Pairwise arithmetic support
   procedure Add (v : in out Vector; value : Vector);
   procedure Sub (v : in out Vector; value : Vector);
   procedure Mult (v : in out Vector; value : Vector);
   procedure Div (v : in out Vector; value : Vector);   
   
   procedure Append (v1 : in out Vector; v2 : Vector) renames RealVectors_Pkg.Append_Vector ;
   function Append (v1 : Vector; v2 : Vector) return Vector;
   -- codemd: end

   function Sum (v : Vector) return RealType;

   -- These are inspired by dplyr https://dplyr.tidyverse.org
   -- Functions/Procedures of the same name
   -- For a more comprehensive emulation, refer numlib.dplyr
  function Mutate
     (v        : Vector;
      modifier : not null access function (value : RealType) return RealType) return Vector ;
   procedure Mutate
     (v        : in out Vector;
      modifier : not null access function (value : RealType) return RealType);

end numlib;
