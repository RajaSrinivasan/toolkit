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

procedure dtypes is
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

   procedure Integer_Types is
      myname : constant String := Enclosing_Entity;
   begin
      if verbose then
         Put (marker);
         Put_Line (myname);
      end if;
      -- codemd: begin segment=IntTypes caption=Integer Types
      Annotation ("Integer", "Size");
      Put (Integer'(Integer'Size)'Image);
      Put_Line (" bits");
      Annotation ("Integer", "Range");
      Put (Integer'(Integer'First)'Image);
      Put (" .. ");
      Put (Integer'(Integer'Last)'Image);
      New_Line;

      Annotation ("Short_Integer", "Size");
      Put (Integer'(Short_Integer'Size)'Image);
      Put_Line (" bits");
      Annotation ("Short_Integer", "Range");
      Put (Integer (Short_Integer'First)'Image);
      Put (" .. ");
      Put (Integer (Short_Integer'Last)'Image);
      New_Line;

      Annotation ("Short_Short_Integer", "Size");
      Put (Integer'(Short_Short_Integer'Size)'Image);
      Put_Line (" bits");
      Annotation ("Short_Short_Integer", "Range");
      Put (Integer (Short_Short_Integer'First)'Image);
      Put (" .. ");
      Put (Integer (Short_Short_Integer'Last)'Image);
      New_Line;

      Annotation ("Long_Integer", "Size");
      Put (Long_Integer'(Long_Integer'Size)'Image);
      Put_Line (" bits");
      Annotation ("Long_Integer", "Range");
      Put (Long_Integer (Long_Integer'First)'Image);
      Put (" .. ");
      Put (Long_Integer (Long_Integer'Last)'Image);
      New_Line;

      -- codemd: end

   end Integer_Types;

   procedure Unsigned_Types is
      myname : constant String := Enclosing_Entity;
   begin
      if verbose then
         Put (marker);
         Put_Line (myname);
      end if;
      -- codemd: begin segment=UnsTypes caption=Unsigned Integer Types
      Annotation ("Unsigned_32", "Size");
      Put (Unsigned_32'(Unsigned_32'Size)'Image);
      Put_Line (" bits");
      Annotation ("Unsigned_32", "Range");
      Put (Unsigned_32'(Unsigned_32'First)'Image);
      Put (" .. ");
      Put (Unsigned_32'(Unsigned_32'Last)'Image);
      New_Line;

      Annotation ("Unsigned_16", "Size");
      Put (Unsigned_16'(Unsigned_16'Size)'Image);
      Put_Line (" bits");
      Annotation ("Unsigned_16", "Range");
      Put (Unsigned_16'(Unsigned_16'First)'Image);
      Put (" .. ");
      Put (Unsigned_16'(Unsigned_16'Last)'Image);
      New_Line;

      Annotation ("Unsigned_8", "Size");
      Put (Unsigned_8'(Unsigned_8'Size)'Image);
      Put_Line (" bits");
      Annotation ("Unsigned_8", "Range");
      Put (Unsigned_8'(Unsigned_8'First)'Image);
      Put (" .. ");
      Put (Unsigned_8'(Unsigned_8'Last)'Image);
      New_Line;

      Annotation ("Unsigned_64", "Size");
      Put (Unsigned_64'(Unsigned_64'Size)'Image);
      Put_Line (" bits");
      Annotation ("Unsigned_64", "Range");
      Put (Unsigned_64'(Unsigned_64'First)'Image);
      Put (" .. ");
      Put (Unsigned_64'(Unsigned_64'Last)'Image);
      New_Line;
      -- codemd: end

      Annotation ("Natural", "Size");
      Put (Natural'(Natural'Size)'Image);
      Put_Line (" bits");
      Annotation ("Natural", "Range");
      Put (Natural'(Natural'First)'Image);
      Put (" .. ");
      Put (Natural'(Natural'Last)'Image);
      New_Line;

      Annotation ("Positive", "Size");
      Put (Positive'(Positive'Size)'Image);
      Put_Line (" bits");
      Annotation ("Positive", "Range");
      Put (Positive'(Positive'First)'Image);
      Put (" .. ");
      Put (Positive'(Positive'Last)'Image);
      New_Line;

   end Unsigned_Types;

   procedure Float_Types is
      myname : constant String := Enclosing_Entity;
   begin
      if verbose then
         Put (marker);
         Put_Line (myname);
      end if;
      Annotation ("Float", "Size");
      Put (Integer'(Float'Size)'Image);
      Put_Line (" bits");
      Annotation ("Float", "Range");
      Put (Float'(Float'First)'Image);
      Put (" .. ");
      Put (Float'(Float'Last)'Image);
      New_Line;
      Annotation ("Float", "Model_Small");
      Put (Float'(Float'Model_Small)'Image);
      New_Line;

      Annotation ("Long_Float", "Size");
      Put (Integer'(Long_Float'Size)'Image);
      Put_Line (" bits");
      Annotation ("Long_Float", "Range");
      Put (Long_Float'(Long_Float'First)'Image);
      Put (" .. ");
      Put (Long_Float'(Long_Float'Last)'Image);
      New_Line;
      Annotation ("Float", "Model_Small");
      Put (Long_Float'(Long_Float'Model_Small)'Image);
      New_Line;

      Annotation ("Long_Long_Float", "Size");
      Put (Integer'(Long_Long_Float'Size)'Image);
      Put_Line (" bits");
      Annotation ("Long_Long_Float", "Range");
      Put (Long_Long_Float'(Long_Long_Float'First)'Image);
      Put (" .. ");
      Put (Long_Long_Float'(Long_Long_Float'Last)'Image);
      New_Line;
      Annotation ("Float", "Model_Small");
      Put (Long_Long_Float'(Long_Long_Float'Model_Small)'Image);
      New_Line;

   end Float_Types;

   procedure Enumeration_Types is
      use Ada.Calendar;
      myname : constant String := Enclosing_Entity;
   begin
      if verbose then
         Put (marker);
         Put_Line (myname);
      end if;
      Annotation ("Character", "Size");
      Put (Integer'(Character'Size)'Image);
      Put_Line (" bits");

      -- codemd: begin segment=EnumTypes caption=Enumeration Data types
      Annotation ("Character", "Range");
      Put (Character (Character'First)'Image);
      Put (" .. ");
      Put (Character'(Character'Last)'Image);
      New_Line;

      Annotation ("Character <CR>", "Internal");
      Put (Integer'(Character'Pos (ASCII.CR))'Image);
      New_Line;

      Annotation ("Character <CR>", "Image");
      Put (Character'Image (ASCII.CR));
      New_Line;

      Annotation ("Character $ ", "Internal");
      Put (Integer'(Character'Pos ('$'))'Image);
      New_Line;

      Annotation ("Character $", "Succ, Pred");
      Put (Character'Succ ('$'));
      Put (" ; ");
      Put (Character'Pred ('$'));
      New_Line;

      -- codemd: end

      Annotation ("Boolean", "Size");
      Put (Integer'(Boolean'Size)'Image);
      Put_Line (" bits");

      Annotation ("Boolean", "Machine_Size");
      Put (Integer'(Boolean'Machine_Size)'Image);
      Put_Line (" bits");

      Annotation ("Day_Name", "Size");
      Put (Integer'(Formatting.Day_Name'Size)'Image);
      Put_Line (" bits");

      Annotation ("Day_Name", "Machine_Size");
      Put (Integer'(Formatting.Day_Name'Machine_Size)'Image);
      Put_Line (" bits");

   end Enumeration_Types;

   procedure String_Type is
      use Ada.Strings;
      myname  : constant String := Enclosing_Entity;
      sample1 : constant String := "~!@#$%^&*()_+`234567890-=";
      sample2 : constant String := "alphabetical";
      procedure String_Type (str : String) is
      begin
         -- codemd: begin segment=StrType caption=String Data Type
         Annotation ("Candidate String ");
         Put_Line (str);
         Annotation ("Length ");
         Put_Line (Positive'(str'Length)'Image);
         Annotation ("Size in bits ");
         Put_Line (Positive'(str'Size)'Image);
         Annotation ("Truncate to first half ");
         Put_Line (str (1 .. str'Length / 2));
         Annotation ("Mid half ");
         Put_Line (str (1 + str'Length / 4 .. 3 * str'Length / 4));
         Annotation ("Multiply ");
         Put_Line (str & str);
         Annotation ("Occurrences of 'a'");
         Put_Line (Fixed.Count (str, "a")'Image);
         Annotation ("Position of 'cal'");
         Put_Line (Fixed.Index (str, "cal")'Image);
         Annotation ("Head ");
         Put (Fixed.Head (str, 48));
         Put_Line (";");
         Annotation ("Tail ");
         Put (Fixed.Tail (str, 48));
         Put_Line (";");
         Annotation ("To Upper Case ");
         Put_Line (Fixed.Translate (str, Maps.Constants.Upper_Case_Map));
         -- codemd: end
      end String_Type;
   begin
      if verbose then
         Put (marker);
         Put_Line (myname);
      end if;
      if Argument_Count > 1 then
         String_Type (Argument (2));
      else
         String_Type (sample1);
         String_Type (sample2);
         String_Type (sample1 & sample2);
      end if;
   end String_Type;

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
      Integer_Types;
   elsif Argument (1) = "int" then
      Integer_Types;
   elsif Argument (1) = "float" then
      Float_Types;
   elsif Argument (1) = "enum" then
      Enumeration_Types;
   elsif Argument (1) = "str" then
      String_Type;
   elsif Argument (1) = "uns" then
      Unsigned_Types;
   end if;
end dtypes;
