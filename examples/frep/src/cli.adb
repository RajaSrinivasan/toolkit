with Ada.Text_IO;         use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Strings.Fixed;
-- with Ada.Directories;

with GNAT.OS_Lib;
with GNAT.Command_Line;
with GNAT.Source_Info; use GNAT.Source_Info;

package body cli is

   package boolean_text_io is new Enumeration_IO (Boolean);
   use boolean_text_io;

   comp_date : constant String := GNAT.Source_Info.Compilation_Date;
   comp_time : constant String := GNAT.Source_Info.Compilation_Time;

   procedure Show_Arguments is
   begin
      if Candidate.all'Length > 1 then
         Put ("Search Candidate : ");
         Put (Candidate.all);
         New_Line;
      else
         Put_Line ("Search Candidate not specified");
      end if;

      if CandidateExp.all'Length > 1 then
         Put ("Search Candidate RegEx : ");
         Put (CandidateExp.all);
         New_Line;
      else
         Put_Line ("Search Candidate RegEx not specified");
      end if;

      if Replacement.all'Length > 1 then
         Put ("Replacement String : ");
         Put (Replacement.all);
         New_Line;
      else
         Put_Line ("Replacement String not specified");
      end if;
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
     "-s <string> -r <regexp> -R <replacement string> file1 file2 ,,.";

   procedure ProcessCommandLine is
      Config : GNAT.Command_Line.Command_Line_Configuration;
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

      GNAT.Command_Line.Getopt (Config, SwitchHandler'Access);

      if Verbosity >= 1 then
         Show_Arguments;
      end if;
   exception
      when others =>
         Put (usagestr);
         New_Line;
   end ProcessCommandLine;

   function GetNextArgument return String is
      nextarg : String :=
        GNAT.Command_Line.Get_Argument (Do_Expansion => False);
   begin
      return nextarg;
   end GetNextArgument;

end cli;
