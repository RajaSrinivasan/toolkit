with Ada.Text_IO;             use Ada.Text_IO;
with Ada.Strings.Unbounded;   use Ada.Strings.Unbounded;
with Ada.Calendar;            use Ada.Calendar;
with Ada.Calendar.Formatting; use Ada.Calendar.Formatting;
with Ada.Directories;         use Ada.Directories;
with GNAT.Command_Line;

with cli;

with git;
with wordlistpkg;

procedure Gitrev is
   br          : wordlistpkg.Vector;
   dir         : Unbounded_String := To_Unbounded_String (".");
   longcomment : constant String  :=
     "--------------------------------------------";
   comment     : constant String  := "-- ";

   procedure StringConstOutput (name : String; str : String) is
   begin
      Put (ASCII.HT);
      Put (name);
      Put (" : constant String := ");
      Put ('"');
      Put (str);
      Put ('"');
      Put (" ;");
   end StringConstOutput;

begin
   cli.ProcessCommandLine;
   declare
      arg : constant String := cli.GetNextArgument;
   begin
      if arg'Length >= 1 then
         dir := To_Unbounded_String (arg);
      end if;
      return;
   end;
   declare
      argdir       : constant String := To_String (dir);
      specfilename : constant String := cli.outputFile.all;
      specfile     : File_Type;
   begin
      Create (specfile, Out_File, specfilename & ".ads");
      Set_Output (specfile);
      Put_Line (longcomment);
      Put (comment);
      Put ("Created ");
      Put_Line (Local_Image (Clock));
      Put_Line (longcomment);
      Put ("package ");
      Put (specfilename);
      Put_Line (" is");
      StringConstOutput ("dir", Full_Name (argdir));
      New_Line;
      StringConstOutput ("version", cli.version.all);
      New_Line;
      StringConstOutput ("repo", git.RepoUrl (argdir));
      New_Line;
      StringConstOutput ("commitid", git.CommitId (argdir));
      New_Line;
      StringConstOutput ("abbrev_commitid", git.AbbrevCommitId (argdir));
      New_Line;
      StringConstOutput ("branch", git.CurrentBranch (argdir));
      New_Line;
      Put ("end ");
      Put (specfilename);
      Put_Line (" ;");
      Set_Output (Standard_Output);
      Close (specfile);
   end;
exception
   when GNAT.Command_Line.Exit_From_Command_Line =>
      return;
end Gitrev;
