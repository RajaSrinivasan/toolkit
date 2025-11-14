with Ada.Text_IO;         use Ada.Text_IO;

with GNAT.Command_Line;
with GNAT.Source_Info; use GNAT.Source_Info;

with revisions;

package body cli is

   package boolean_text_io is new Enumeration_IO (Boolean);
   use boolean_text_io;

   procedure ShowRevision is
   begin
      Put( name ); Put_Line(" version");
      Put ("Repo ");
      Put_Line (revisions.repo);
      Put ("Version ");
      Put_Line (revisions.version);
      Put("Commit Id ");
      Put_Line(revisions.commitid);
   end ShowRevision;

   procedure ProcessCommandLine is
      Config : GNAT.Command_Line.Command_Line_Configuration;
   begin

      GNAT.Command_Line.Set_Usage
        (Config,
         Help  => NAME & " " & Compilation_ISO_Date & " " & Compilation_Time,
         Usage => "");

      GNAT.Command_Line.Define_Switch
        (Config, Verbose'Access, Switch => "-v", Long_Switch => "--verbose",
         Help                           => "Output extra verbose information");

      GNAT.Command_Line.Define_Switch
        (Config, OutputFile'Access, Switch => "-o:",
         Long_Switch                       => "--output:",
         Help => "Output package spec name. default: revisions");

      GNAT.Command_Line.Define_Switch
        (Config, Version'Access, Switch => "-r:", Long_Switch => "--revision:",
         Help => "Semantic version spec <major>.<minor>.<patch>");


      GNAT.Command_Line.Define_Switch
        (Config, ci_env'Access, Switch => "-e:", Long_Switch => "--environment:",
         Help => "Additional CI build references. GitLab|GitHub|codeberg");

      GNAT.Command_Line.Getopt (Config);

      if Verbose then
         ShowCommandLineArguments;
         ShowRevision;
      end if;

      if ci_env.all /= "GitLab"
      then
         Put_Line("CI Environment is unknown|unsupported. Ignored");
      end if ;
      
   end ProcessCommandLine;

   function GetNextArgument return String is
   begin
      return GNAT.Command_Line.Get_Argument (Do_Expansion => True);
   end GetNextArgument;

   procedure ShowCommandLineArguments is
   begin
      Put_Line("Command Line Arguments");
      Put ("Verbose ");
      Put (Verbose);
      New_Line;
      Put ("Output File ");
      Put_Line (outputFile.all);
      Put ("Version ");
      Put_Line (version.all);
   end ShowCommandLineArguments;

end cli;
