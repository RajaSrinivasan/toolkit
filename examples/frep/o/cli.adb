with Ada.Text_IO; use Ada.Text_IO;

with Ada.Directories;
with Ada.Exceptions;

with GNAT.Command_Line;
with GNAT.Source_Info;

package body cli is

   comp_date :constant String := GNAT.Source_Info.Compilation_Date;
   comp_time :constant String := GNAT.Source_Info.Compilation_Time;

   procedure StringArg (name :String; ptr : GNAT.Strings.String_Access) is
   begin
      Put (name);
      Put (" :");
      if ptr.all'Length >= 1 then
         Put_Line (ptr.all);
      else
         Put_Line (" was not specified");
      end if;
   end StringArg;
   procedure Show_Arguments is
   begin
      StringArg ("Candidate", candidate);
      StringArg ("CandidateExp", CandidateExp);
      StringArg ("Replacement", Replacement);
      StringArg ("OutputDir", outputdir);
   end Show_Arguments;

   procedure SwitchHandler
     (Switch :String; Parameter : String; Section : String)
   is
   begin
      Put ("SwitchHandler " & Switch);
      Put (" Parameter " & Parameter);
      Put (" Section " & Section);
      New_Line;
   end SwitchHandler;

   usagestr :constant String :=
     "-s <string> -r <regexp> -R <replacement> -o outputdir <string>" &
     " file1 file2 ,,.";

   procedure ProcessCommandLine is
      use Ada.Directories;
      Config :GNAT.Command_Line.Command_Line_Configuration;
   begin
      GNAT.Command_Line.Set_Usage
        (Config,
         Help  => NAME & " " & VERSION & " " & comp_date & " " & comp_time,
         Usage => usagestr);

      GNAT.Command_Line.Define_Switch
        (Config, Verbosity'Access, Switch => "-v:",
         Long_Switch => "--verbosity:", Help => "Verbosity Level");

      GNAT.Command_Line.Define_Switch
        (Config, Candidate'Access, Switch => "-s:", Long_Switch => "--search:",
         Help                             => "Search Candidate");

      GNAT.Command_Line.Define_Switch
        (Config, CandidateExp'Access, Switch => "-r:",
         Long_Switch => "--regex:", Help => "Search Candidate - Reg Exp");

      GNAT.Command_Line.Define_Switch
        (Config, Replacement'Access, Switch => "-R:",
         Long_Switch => "--replace:", Help => "Replacement String");

      GNAT.Command_Line.Define_Switch
        (Config, outputdir'Access, Switch => "-o:",
         Long_Switch                      => "--output-dir:",
         Help => "Output Directory for edited files");

      GNAT.Command_Line.Getopt (Config, SwitchHandler'Access);

      if Verbosity >= 1 then
         Show_Arguments;
      end if;

      if replacement.all'Length > 0 then
         Put ("Output Dir ");
         Put (outputdir.all);
         New_Line;
         if outputdir.all'Length < 1 then
            raise CLI_ERROR
              with "Please provide an output dir for edited files";
         end if;
         if not Ada.Directories.Exists (outputdir.all) then
            raise CLI_ERROR with "Non existent output dir";
         end if;
         if Ada.Directories.Kind (outputdir.all) /= Ada.Directories.Directory
         then
            raise CLI_ERROR with "Provide a directory for output";
         end if;
      end if;

   exception
      when e :others =>
         Put ("Exception ");
         Put (Ada.Exceptions.Exception_Name (e));
         Put (" ");
         Put (Ada.Exceptions.Exception_Message (e));
         New_Line;
         Put (usagestr);
         New_Line;
         raise;
   end ProcessCommandLine;

   function GetNextArgument return String is
      nextarg :constant String :=
        GNAT.Command_Line.Get_Argument (Do_Expansion => False);
   begin
      return nextarg;
   end GetNextArgument;

end cli;
