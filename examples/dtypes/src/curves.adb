-- codemd: begin segment=Library caption=Predefined Library Support
with Ada.Text_IO;       use Ada.Text_IO;
with Ada.Float_Text_IO; use Ada.Float_Text_IO;

with Ada.Command_Line; use Ada.Command_Line;
with Ada.Numerics.Elementary_Functions;

with GNAT.Source_Info;
use GNAT.Source_Info;
-- codemd: end

procedure curves is

   verbose : constant Boolean := True;
   myname  : constant String := Enclosing_Entity;
   marker  : constant String := "--------- ";

   procedure Annotation (operation : String) is
   begin
      Put (operation);
      Set_Col (24);
      Put (": ");
   end Annotation;

   procedure Annotation (typename : String; attribute : String) is
   begin
      Put (typename);
      Set_Col (24);
      Put (attribute);
      Set_Col (40);
   end Annotation;

   procedure CreateOutputFile (name : String; f : in out File_Type) is
   begin
      Create (f, Out_File, name & ".csv");
      Set_Output (f);
   end CreateOutputFile;

   -- codemd: begin segment=DegRad caption=Conversion routines radians vs degrees
   function Radians (d : Integer) return Float is
   begin
      return 2.0 * Ada.Numerics.Pi * Float (d) / 360.0;
   end Radians;
   function Degrees (r : Float) return Integer is
   begin
      return Integer (r * 360.0 / (2.0 * Ada.Numerics.Pi));
   end Degrees;
   --codemd: end

   procedure Trigonometric is
      use Ada.Numerics;
      myname  : constant String := Enclosing_Entity;
      outfile : File_Type;

   begin
      if verbose then
         Put (myname);
         New_Line;
      end if;
      -- codemd: begin segment=Trig caption=Trigonometric Functions
      CreateOutputFile (myname, outfile);
      for deg in 0 .. 360 loop
         Put (Float'(Radians (deg))'Image);
         Put (" ; ");
         Put (Float'(Elementary_Functions.Sin (Radians (deg)))'Image);
         Put (" ; ");
         Put (Float'(Elementary_Functions.Cos (Radians (deg)))'Image);
         Put (" ; ");
         Put (Float'(Elementary_Functions.Tan (Radians (deg)))'Image);
         New_Line;
      end loop;
      Close (outfile);
      -- codemd: end
      Set_Output (Standard_Output);
   end Trigonometric;

   procedure Hyperbolic is
      use Ada.Numerics;
      myname  : constant String := Enclosing_Entity;
      x       : Float;
      outfile : File_Type;
   begin
      if verbose then
         Put (myname);
         New_Line;
      end if;
      -- codemd: begin segment=Hyper caption=Hyperbolic Functions
      CreateOutputFile (myname, outfile);
      for d in 0 .. 40 loop
         x := Float (d) * 0.1 - 2.0;
         Put (x'Image);
         Put (" ; ");
         Put (Elementary_Functions.Sinh (x), Fore => 3, Aft => 3, Exp => 0);
         Put (" ; ");
         Put (Elementary_Functions.Cosh (x), Fore => 3, Aft => 3, Exp => 0);
         Put (" ; ");
         Put (Elementary_Functions.Tanh (x), Fore => 3, Aft => 3, Exp => 0);
         Put (" ; ");
         New_Line;
      end loop;
      Close (outfile);
      Set_Output (Standard_Output);
      -- codemd: end
   end Hyperbolic;

   -- Hypotrochoid parametric equations defined in:
   -- https://en.wikipedia.org/wiki/Hypotrochoid
   procedure Hypotrochoid is
      use Ada.Numerics;
      use Elementary_Functions;
      myname   : constant String := Enclosing_Entity;
      outfile  : File_Type;
      fixedR   : constant Float := 5.0;
      rollingR : constant Float := 3.0;
      d        : constant Float := 5.0;
      x, y     : Float;
   begin
      if verbose then
         Put (myname);
         New_Line;
      end if;
      CreateOutputFile (myname, outfile);
      -- codemd: begin segment=Hypo caption=Generate the coordinates
      for theta in 0 .. 3 * 360 loop
         x :=
           (fixedR - rollingR) * Cos (Radians (theta))
           + d * Cos (Radians (theta) * (fixedR - rollingR) / rollingR);
         y :=
           (fixedR - rollingR) * Sin (Radians (theta))
           - d * Sin (Radians (theta) * (fixedR - rollingR) / rollingR);
         Put (Float (Radians (theta))'Image);
         Put (" ; ");
         Put (x'Image);
         Put (" ; ");
         Put (y'Image);
         New_Line;
      end loop;
      -- codemd: end

      Close (outfile);
      Set_Output (Standard_Output);
   end Hypotrochoid;

begin

   if verbose then
      Put (myname);
      Put (" ");
      Put (File);
      Put (" ");
      Put ("Compiled ");
      Put (Compilation_Date);
      Put (" ");
      Put (Compilation_Time);
      New_Line;
   end if;

   if Argument_Count < 1 then
      Trigonometric;
   elsif Argument (1) = "trig" then
      Trigonometric;
   elsif Argument (1) = "hyper" then
      Hyperbolic;
   elsif Argument (1) = "troch" then
      Hypotrochoid;
   end if;
end curves;
