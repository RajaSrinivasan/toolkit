with GNAT.Regpat;

with Ada.Text_IO;       use Ada.Text_IO;
with Ada.Strings.Fixed; use Ada.Strings.Fixed;

package body impl is

   MAX_LINE_LENGTH : constant        := 128;
   Separator       : constant String := "-----------------------";

   procedure Search (filename : String; candidate : String) is
      count      : Natural := 0;
      file       : File_Type;
      line       : String (1 .. MAX_LINE_LENGTH);
      linelength : Natural;
      linenumber : Natural := 0;
      Position   : Natural;
   begin

      Put (Separator);
      Put (filename);
      Put (Separator);
      New_Line;
      Open (file, In_File, filename);
      while not End_Of_File (file) loop
         Get_Line (file, line, linelength);
         linenumber := linenumber + 1;
         Position   := Index (line (1 .. linelength), candidate);
         if Position > 0 then
            Put (linenumber'Image);
            Set_Col (6);
            Put (" : ");
            Put (line (1 .. Position - 1));
            Put ("[");
            Put (candidate);
            Put ("]");
            Put (line (Position + candidate'Length .. linelength));
            New_Line;
            Count := Count + 1;
         end if;
      end loop;
      Close (file);
      Put (count'Image);
      Put_Line (" occurrences");
   end search;

   procedure SearchRegEx (filename : String; candidate : String) is
      use GNAT.RegPat;
      count      : Natural         := 0;
      file       : File_Type;
      line       : String (1 .. MAX_LINE_LENGTH);
      linelength : Natural;
      linenumber : Natural         := 0;
      pattern    : constant Pattern_Matcher := Compile (candidate);
      matched    : GNAT.RegPat.Match_Array (0 .. 1);
   begin

      Put (Separator);
      Put (filename);
      Put (Separator);
      New_Line;

      Open (file, In_FIle, filename);
      while not End_Of_File (file) loop
         Get_Line (file, line, linelength);
         linenumber := linenumber + 1;
         GNAT.RegPat.Match (pattern, line (1 .. linelength), matched);
         if matched (0) /= GNAT.RegPat.No_Match then
            Put (linenumber'Image);
            Set_Col (6);
            Put (" : ");
            Put (line (1 .. matched (0).First - 1));
            Put ("[");
            Put (line (matched (0).First .. matched (0).Last));
            Put ("]");
            Put (line (matched (0).Last + 1 .. linelength));
            New_Line;
            Count := Count + 1;
         end if;
      end loop;
      Close (file);
      Put (count'Image);
      Put_Line (" occurrences");
   end SearchRegEx;

end impl;
