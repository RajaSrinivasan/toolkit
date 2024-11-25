-- codemd: begin segment=Environment caption=CLI environment
with Ada.Text_IO; use Ada.Text_IO;

with Ada.Directories;
with Ada.Exceptions;

with GNAT.Command_Line;
with GNAT.Source_Info;
-- codemd: end

package body cli is

   comp_date : constant String := GNAT.Source_Info.Compilation_Date;
   comp_time : constant String := GNAT.Source_Info.Compilation_Time;

   procedure StringArg (name : String; ptr : GNAT.Strings.String_Access) is
   begin
      Put (name);
      Put (" : ");
      if ptr.all'Length >= 1 then
         Put_Line (ptr.all);
      else
         Put_Line (" was not specified");
      end if;
   end StringArg;

   procedure Show_Arguments is
   begin
      StringArg ("CandidateExp", CandidateExp);
      Put("FilesOption "); Put_Line(FilesOption'Image);
   end Show_Arguments;

   procedure SwitchHandler
     (Switch : String; Parameter : String; Section : String)
   is
   begin
      Put ("SwitchHandler " & Switch);
      Put (" Parameter " & Parameter);
      Put (" Section " & Section);
      New_Line;
   end SwitchHandler;

   usagestr : constant String :=
     "regex [<string>] or -f " &
     " file1 file2 ,,.";

   procedure ProcessCommandLine is
      use Ada.Directories;
      Config : GNAT.Command_Line.Command_Line_Configuration;
   begin

      GNAT.Command_Line.Set_Usage
        (Config,
         Help  => NAME & " " & VERSION & " " & comp_date & " " & comp_time,
         Usage => usagestr);

    --codemd: begin segment=Define caption=Define the Switches
      GNAT.Command_Line.Define_Switch
        (Config, Verbosity'Access, Switch => "-v:",
         Long_Switch => "--verbosity:", Help => "Verbosity Level");

      GNAT.Command_Line.Define_Switch
        (Config, filesOption'Access, Switch => "-f",
         Long_Switch                      => "--files",
         Help => "Validate lines in the input file(s)" );

      GNAT.Command_Line.Define_Switch
        (Config, filesOption'Access, Switch => "-g",
         Long_Switch                      => "--glob",
         Help => "Glob Option" );

      GNAT.Command_Line.Define_Switch
        (Config, caseInsensitiveOption'Access, Switch => "-c",
         Long_Switch                      => "--case-insensitive",
         Help => "Case insensitive. (Default sensitive)" );

      GNAT.Command_Line.Getopt (Config, SwitchHandler'Access);
    -- codemd: end

      if Verbosity >= 1 then
         Show_Arguments;
      end if;


   -- codemd: begin segment=Exception caption=Exception handling 
   exception
      when GNAT.COMMAND_LINE.EXIT_FROM_COMMAND_LINE =>
        raise ;
      when e : others =>
         Put ("Exception ");
         Put (Ada.Exceptions.Exception_Name (e));
         Put (" ");
         Put (Ada.Exceptions.Exception_Message (e));
         New_Line;
         Put (usagestr);
         New_Line;
         raise;
    -- codemd: end
   end ProcessCommandLine;

   function GetNextArgument return String is
      nextarg : constant String :=
        GNAT.Command_Line.Get_Argument (Do_Expansion => False);
   begin
      return nextarg;
   end GetNextArgument;

end cli;
