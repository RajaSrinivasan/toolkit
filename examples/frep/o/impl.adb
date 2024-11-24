with Ada.Text_IO;       use Ada.Text_IO;
with Ada.Strings.Fixed; use Ada.Strings.Fixed;
with Ada.Directories;
with GNAT.Regpat;
with GNAT.Strings;

package body impl is

   MAX_LINE_LENGTH :constant        := 128;
   Separator       :constant String := "-----------------------";

   procedure Search (filename :String; candidate : String) is
      count      :Natural := 0;
      file       :File_Type;
      line       :String (1 .. MAX_LINE_LENGTH);
      linelength :Natural;
      linenumber :Natural := 0;
      Position   :Natural;
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
            Put (" :");
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
   end Search;

   procedure Replace
     (filename  :String; candidate : String; replacement : String;
      OutputDir :String)
   is
      outfilename :constant String :=
        Ada.Directories.Compose
          (OutputDir, Ada.Directories.Simple_Name (filename));

      outfile :File_Type;

      count      :Natural := 0;
      file       :File_Type;
      line       :String (1 .. MAX_LINE_LENGTH);
      linelength :Natural;
      Position   :Natural;

   begin
      Put (Separator);
      Put ("Creating ");
      Put (outfilename);
      Put (" from ");
      Put (filename);
      Put (Separator);
      New_Line;
      Open (file, In_File, filename);
      Create (outfile, Out_File, outfilename);
      while not End_Of_File (file) loop
         Get_Line (file, line, linelength);
         Position := Index (line (1 .. linelength), candidate);
         if Position > 0 then
            Put (outfile, line (1 .. Position - 1));
            Put (outfile, replacement);
            Put (outfile, line (Position + candidate'Length .. linelength));
            New_Line (outfile);
            Count := Count + 1;
         else
            Put_Line (outfile, line (1 .. linelength));
         end if;
      end loop;
      Close (outfile);
      Close (file);
      Put (count'Image);
      Put_Line (" substitions made");
   end Replace;

   patternStr :GNAT.Strings.String_Access;
   pcompiled  :access GNAT.RegPat.Pattern_Matcher;

   procedure SearchRegEx (filename :String; candidate : String) is
      use GNAT.RegPat, GNAT.Strings;
      count      :Natural := 0;
      file       :File_Type;
      line       :String (1 .. MAX_LINE_LENGTH);
      linelength :Natural;
      linenumber :Natural := 0;
      matched    :GNAT.RegPat.Match_Array (0 .. 1);
   begin
      if patternStr = null then
         patternStr     := new String (candidate'Range);
         patternStr.all := candidate;
         pcompiled := new GNAT.RegPat.Pattern_Matcher'(Compile (candidate));
      end if;
      Put (Separator);
      Put (filename);
      Put (Separator);
      New_Line;

      Open (file, In_FIle, filename);
      while not End_Of_File (file) loop
         Get_Line (file, line, linelength);
         linenumber := linenumber + 1;
         GNAT.RegPat.Match (pcompiled.all, line (1 .. linelength), matched);
         if matched (0) /= GNAT.RegPat.No_Match then
            Put (linenumber'Image);
            Set_Col (6);
            Put (" :");
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

   procedure ReplaceRegEx
     (filename  :String; candidate : String; replacement : String;
      outputdir :String)
   is

      use GNAT.RegPat, GNAT.Strings;

      outfilename :constant String :=
        Ada.Directories.Compose
          (OutputDir, Ada.Directories.Simple_Name (filename));
      outfile     :File_Type;

      count      :Natural := 0;
      file       :File_Type;
      line       :String (1 .. MAX_LINE_LENGTH);
      linelength :Natural;
      matched    :GNAT.RegPat.Match_Array (0 .. 1);

   begin
      if patternStr = null then
         patternStr     := new String (candidate'Range);
         patternStr.all := candidate;
         pcompiled := new GNAT.RegPat.Pattern_Matcher'(Compile (candidate));
      end if;

      Put (Separator);
      Put ("Creating ");
      Put (outfilename);
      Put (" from ");
      Put (filename);
      Put (Separator);
      New_Line;
      Open (file, In_File, filename);
      Create (outfile, Out_File, outfilename);
      while not End_Of_File (file) loop
        Get_Line (file, line, linelength);
        GNAT.RegPat.Match (pcompiled.all, line (1 .. linelength), matched);
         if matched (0) = GNAT.RegPat.No_Match then
            Put_Line(outfile,line(1..linelength));
         else
            Put (outfile,line (1 .. matched (0).First - 1));
            Put (outfile,replacement);
            Put (outfile,line (matched (0).Last + 1 .. linelength));
            New_Line(outfile);
            Count := Count + 1;
         end if;
      end loop;
      Close (outfile);
      Close (file);
      Put (count'Image);
      Put_Line (" substitions made");
   end ReplaceRegEx;

end impl;
