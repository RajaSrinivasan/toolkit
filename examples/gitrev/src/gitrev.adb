with Ada.Text_IO;             use Ada.Text_IO;
with Ada.Strings.Unbounded;   use Ada.Strings.Unbounded;
with Ada.Calendar;            use Ada.Calendar;
with Ada.Calendar.Formatting; use Ada.Calendar.Formatting;
with Ada.Directories;         use Ada.Directories;
with Ada.Containers; use Ada.Containers;

with GNAT.Command_Line;

with Semantic_Versioning ;

with cli;

with git;
with wordlistpkg;


procedure Gitrev is

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
      else
         Put_Line("Please provide a dir. Use '.' for current");
         return;
      end if ;
   end;
--codemd: begin segment=semver caption=Semantic versioning
   declare
      vstring : constant String := 
               Semantic_Versioning.Image(
               Semantic_Versioning.Parse( cli.version.all ) ) ;
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
      StringConstOutput ("version", vstring );
      New_Line;
      --codemd: end
      StringConstOutput ("repo", git.RepoUrl (argdir));
      New_Line;
      StringConstOutput ("commitid", git.CommitId (argdir));
      New_Line;
      StringConstOutput ("abbrev_commitid", git.AbbrevCommitId (argdir));
      New_Line;
      declare
         tags : constant wordlistpkg.Vector := git.Tags( argdir );
         tagstr : Unbounded_String := Null_Unbounded_String ;
         procedure collect ( c : wordlistpkg.Cursor ) is
            t : constant String :=  wordlistpkg.Element(c) ;
         begin
            if Length(tagstr) > 1
            then
               Append(tagstr , " , " & t ) ;
            else
               tagstr := To_Unbounded_String(t) ;
            end if ;
         end collect ;
      begin
         if tags.Length < 1
         then
            StringConstOutput ("tags", "" ) ;
         else
            tags.Iterate( collect'access );
            StringConstOutput ("tags",To_String(tagstr) );
         end if ;
      end ;
      New_Line;
      StringConstOutput ("branch", git.CurrentBranch (argdir));
      New_Line;
      if cli.ci_env.all = "GitLab"
      then
         New_Line ;
         Put(Comment); Put("GitLab CI"); New_Line ;
         New_Line ;
      end if ;
      Put ("end ");
      Put (specfilename);
      Put_Line (" ;");
      Set_Output (Standard_Output);
      Close (specfile);
   end;
exception
   when GNAT.Command_Line.Exit_From_Command_Line =>
      return;
   when Semantic_Versioning.Malformed_Input =>
      Put_Line("Error in version spec");
      raise;
end Gitrev;
