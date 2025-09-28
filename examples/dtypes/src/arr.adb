-- codemd: begin segment=Library caption=Predefined Library Support
with Interfaces;  use Interfaces;
with Ada.Text_IO; use Ada.Text_IO;

with Ada.Command_Line; use Ada.Command_Line;
with Ada.Strings.Fixed;
with Ada.Strings.Maps.Constants;

with Ada.Calendar.Formatting;

with GNAT.Source_Info;
use GNAT.Source_Info;
-- codemd: end

procedure arr is

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

   procedure Int_Array is
      myname     : constant String := Enclosing_Entity;
      -- codemd: begin segment=Constrained caption=Array range in character
      charcounts : array (Character'First .. Character'Last) of Integer :=
        (others => 0);
      -- codemd: end
      quote      : constant String :=
        "Shakespeare remains arguably the most influential writer in the English language,"
        & " and his works continue to be studied and reinterpreted.";

   begin
      if verbose then
         Put (marker);
         Put_Line (myname);
      end if;

      -- codemd: begin segment=ForEachChar caption=Walking all elements
      for c in quote'Range loop
         charcounts (quote (c)) := charcounts (quote (c)) + 1;
      end loop;
      Put_Line ("Characters that occurred in the quote");
      for c in Character'Range loop
         if charcounts (c) > 0 then
            Annotation ("Character " & c'Image);
            Put_Line (Integer'(charcounts (c))'Image);
         end if;
      end loop;
      --codemd: end
   end Int_Array;

   procedure Real_Array is
      myname : constant String := Enclosing_Entity;
      -- codemd: begin segment=ArrTypeFloat caption=Named array type
      type Real_Array is array (Integer range <>) of Float;
      args   : Real_Array := (1 => 1.0, 2 => 10.0, 3 => 100.0, 4 => 1_000.0);
      procedure Show_Powers (vals : Real_Array; p : Integer) is
      begin
         for v in vals'Range loop
            Put (v'Image);
            Put (ASCII.HT);
            Put (vals (v)'Image);
            Put (ASCII.HT);
            Put (Float'(vals (v) ** p)'Image);
            New_Line;
         end loop;
      end Show_Powers;
      -- codemd: end
   begin
      if verbose then
         Put (marker);
         Put_Line (myname);
      end if;
      Annotation ("Real Array", "Length");
      Put_Line (Integer'(args'Length)'Image);
      Annotation ("", "Size");
      Put (Integer'(args'Size)'Image);
      Put_Line (" bits");
      Annotation ("", "Range");
      Put (Integer'(args'First)'Image);
      Put (" .. ");
      Put (Integer'(args'Last)'Image);
      New_Line;
      Annotation ("Raise to the Power 3");
      New_Line;
      Show_Powers (args, 3);
   end Real_Array;

   procedure Unsigned_Array is
      myname     : constant String := Enclosing_Entity;
      -- codemd: begin segment=ArrTypeUns caption=Named array type
      type Unsigned_Array is array (Integer range <>) of Unsigned_8;
      subtype DecimalDigits_Array is Unsigned_Array (1 .. 11);
      candidates : Unsigned_Array (1 .. 4) := (7, 99, 199, 244);

      function Digitize (val : Unsigned_8) return DecimalDigits_Array is
         result : DecimalDigits_Array := (others => 0);
         dp     : Integer := 0;
         valnow : Unsigned_8 := val;
      begin
         while valnow > 0 loop
            result (result'Last - dp) := valnow rem 10;
            dp := dp + 1;
            valnow := valnow / 10;
         end loop;
         return result;
      end Digitize;

      function Value (val : DecimalDigits_Array) return Unsigned_8 is
         result : Unsigned_8 := 0;
      begin
         for d in val'Range loop
            result := result * 10 + val (d);
         end loop;
         return result;
      end Value;

      procedure Show (vals : Unsigned_Array) is
         significant : Boolean := False;
      begin
         for v in vals'Range loop
            if significant then
               Put (vals (v)'Image);
               Put (", ");
            elsif vals (v) > 0 then
               significant := True;
               Put (vals (v)'Image);
               Put (", ");
            end if;
         end loop;
         if not significant then
            Put ("0");
         end if;
      end Show;
      -- codemd: end
      digs : DecimalDigits_Array;
   begin
      if verbose then
         Put (marker);
         Put_Line (myname);
      end if;
      for c in candidates'Range loop
         Annotation ("Candidate");
         Put (candidates (c)'Image);
         New_Line;
         digs := Digitize (candidates (c));
         Annotation ("", "Digitised");
         Show (digs);
         New_Line;
         Annotation ("", "Reconstructed");
         Put (Value (digs)'Image);
         New_Line;
      end loop;
   end Unsigned_Array;

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
      Int_Array;
   elsif Argument (1) = "int" then
      Int_Array;
   elsif Argument (1) = "real" then
      Real_Array;
   elsif Argument (1) = "uns" then
      Unsigned_Array;
   end if;
end arr;
