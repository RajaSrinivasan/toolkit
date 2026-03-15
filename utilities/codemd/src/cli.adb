with Ada.Text_IO;       use Ada.Text_IO;
with Ada.Strings.Fixed; use Ada.Strings.Fixed;

with GNAT.Command_Line;
with GNAT.Source_Info; use GNAT.Source_Info;

with revisions;

package body cli is

   package boolean_text_io is new Enumeration_IO (Boolean);
   use boolean_text_io;

   procedure ProcessCommandLine is
      use revisions;
      Config : GNAT.Command_Line.Command_Line_Configuration;
   begin
      GNAT.Command_Line.Set_Usage
        (Config,
         Help  =>
           NAME
           & " "
           & revisions.Version
           & " "
           & branch
           & ":"
           & abbrev_commitid
           & " "
           & Compilation_ISO_Date
           & " "
           & Compilation_Time,
         Usage => "<input file> <options>");

      GNAT.Command_Line.Define_Switch
        (Config,
         Verbose'Access,
         Switch      => "-v",
         Long_Switch => "--verbose",
         Help        => "Output extra verbose information");

      GNAT.Command_Line.Define_Switch
        (Config,
         extractSection'Access,
         Switch      => "-x:",
         Long_Switch => "--extract:",
         Help        => "Extract the segment. By default all the segments.");

      GNAT.Command_Line.Define_Switch
        (Config,
         caption'Access,
         Switch      => "-c:",
         Long_Switch => "--caption:",
         Help        => "Caption for this segment");

      GNAT.Command_Line.Define_Switch
        (Config,
         lines'Access,
         Switch      => "-L:",
         Long_Switch => "--line-numbers:",
         Help        => "Lines from-count");

      GNAT.Command_Line.Define_Switch
        (Config,
         exec'Access,
         Switch      => "-X:",
         Long_Switch => "--execution-log:",
         Help        => "Execute the command and capture log");

      GNAT.Command_Line.Define_Switch
        (Config,
         lines'Access,
         Switch      => "-O?",
         Long_Switch => "--output-file?",
         Help        => "Save output to a file. Need a filename for cmd exec");

      GNAT.Command_Line.Getopt (Config);

      if lines.all'Length >= 1 then
         declare
            sep : Natural;
         begin
            sep := Index (lines.all, "-");
            if sep = 0 then
               lineno_from := Integer'Value (lines.all);
               linecount := DEFAULT_LINECOUNT;
            else
               lineno_from :=
                 Integer'Value (lines.all (lines.all'First .. sep - 1));
               linecount :=
                 Integer'Value (lines.all (sep + 1 .. lines.all'Last));
            end if;
         end;
      end if;

      if Verbose then
         ShowCommandLineArguments;
      end if;

   exception
      when GNAT.COMMAND_LINE.INVALID_SWITCH =>
         null;
   end ProcessCommandLine;

   -- codemd: begin segment=getnext caption=GetNext
   function GetNextArgument return String is
   begin
      return GNAT.Command_Line.Get_Argument (Do_Expansion => True);
   end GetNextArgument;
   --codemd: end

   --codemd: begin segment=Show caption=Show Command Line Argument
   procedure ShowCommandLineArguments is
   begin
      Put ("Verbose ");
      Put (Verbose);
      New_Line;
      Put ("From Line ");
      Put (lineno_from'Image);
      Put (" count ");
      Put (linecount'Image);
      New_Line;
   end ShowCommandLineArguments;
   -- codemd: end

end cli;
