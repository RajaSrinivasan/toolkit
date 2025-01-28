with Ada.Text_IO; use Ada.Text_IO;

with Ada.Characters.Handling; use Ada.Characters.Handling;
with Ada.Directories;

with Ada.Strings.Fixed; -- use Ada.Strings.Fixed ;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
-- with Ada.Strings.Maps ; use Ada.Strings.Maps ;

with GNAT.OS_Lib; use GNAT.OS_Lib;
with GNAT.Expect; -- use GNAT.Expect ;

package body git is

   --codemd: begin segment=Locate caption=locate the exec
   fullgit : constant GNAT.os_lib.String_Access := Locate_Exec_On_Path ("git");
   --codemd: end

   function Get_Line (str : String; from : Integer) return Integer is
      result : Integer;
      ptr    : Integer := from;
   begin
      while ptr <= str'Last loop
         if not Is_Line_Terminator (str (ptr)) then
            exit;
         end if;
         ptr := ptr + 1;
      end loop;
      if ptr > str'Last then
         return from;
      end if;
      result := ptr + 1;
      while result < str'Last loop
         if Is_Line_Terminator (str (result)) then
            result := result - 1;
            return result;
         end if;
         result := result + 1;
      end loop;
      return result;
   end Get_Line;

   -- codemd: begin segment=Get_Lines caption=Split multi line output
   function Get_Lines (str : String) return wordlistpkg.Vector is
      result : wordlistpkg.Vector;
      from   : Integer := str'First;
      to     : Integer;
   begin
      while from < str'Last loop
         to := Get_Line (str, from);
         result.Append (str (from .. to));
         to := to + 1;
         while to < str'Last loop
            if not Is_Line_Terminator (str (to)) then
               exit;
            end if;
            to := to + 1;
         end loop;
         from := to;
      end loop;
      return result;
   end Get_Lines;
   -- codemd: end

   -- codemd: begin segment=Exec caption=Execute the command
   -- Execute the command in the specified directory and return the output
   function Exec (dir : string; cmd : String) return String is
      cwd     : constant String := Ada.Directories.Current_Directory;
      status  : aliased Integer;
      arglist : constant Argument_List_Access := Argument_String_To_List (cmd);
   begin
      Ada.Directories.Set_Directory (dir);
      declare
         result : constant string :=
           GNAT.Expect.Get_Command_Output
             (fullgit.all, arglist.all, "", Status'Access, Err_To_Out => True);
      begin
         if Verbose then
            Put ("Dir: ");
            Put (dir);
            Put (" cmd: ");
            Put_Line (cmd);
            Put_Line (result);
         end if;
         Ada.Directories.Set_Directory (cwd);
         return result;
      end;
   exception
      when others =>
         Put ("Exception executing ");
         Put (cmd);
         Put (" @ dir ");
         Put_Line (dir);
         return "";
   end Exec;
   --codemd: end

   function Branches (repo : String := ".") return wordlistpkg.Vector is
      cmd         : constant String := "branch --list";
      allbranches : constant String := Exec (repo, cmd);
   begin
      return Get_Lines (allbranches);
   end Branches;

   function RemoteBranches (repo : String) return wordlistpkg.Vector is
      cmd         : constant String := "ls-remote --heads " & repo;
      allbranches : constant String := Exec (repo, cmd);
   begin
      return Get_Lines (allbranches);
   end RemoteBranches;

   function DefaultBranch (repo : String) return String is
      arglista   : constant Argument_List_Access :=
        Argument_String_To_List ("remote show " & repo);
      status     : aliased Integer;
      showremote : constant string               :=
        GNAT.Expect.Get_Command_Output
          (fullgit.all, arglista.all, "", Status'Access, Err_To_Out => True);
      headword   : constant String               := "HEAD branch: ";
      hidx       : integer;
   begin
      if status = 0 then
         hidx := Ada.Strings.Fixed.Index (showremote, headword);
         if hidx > 0 then
            -- cridx := Ada.Strings.Fixed.Index( showremote , cr , hidx+1 );
            declare
               brname : Unbounded_String := Null_Unbounded_String;
            begin
               for idx in hidx + headword'Length .. showremote'Last loop
                  if Is_Alphanumeric (showremote (idx)) then
                     Append (brname, showremote (idx));
                  else
                     return To_String (brname);
                  end if;
               end loop;
               return To_String (brname);
            end;
         else
            return "unknown";
         end if;
      else
         return "unknown";
      end if;
   end DefaultBranch;

   function RepoUrl (dir : String := ".") return String is
      repourlcmd : constant String := "remote get-url origin";
   begin
      return Exec (dir, repourlcmd);
   end RepoUrl;

   function CommitId (dir : String := ".") return String is
      cmd : constant String := "rev-parse HEAD";
   begin
      return Exec (dir, cmd);
   end CommitId;

   function AbbrevCommitId (dir : String := ".") return String is
   begin
      return Abbrev (commitid (dir));
   end AbbrevCommitId;

   function Abbrev (fullcommitid : String) return String is
   begin
      return fullcommitid (fullcommitid'First .. fullcommitid'First + 6);
   end Abbrev;

   --codemd: begin segment=CurrentBranch caption=Current branch
  function CurrentBranch (dir : String := ".") return String is
      cmd : String := "rev-parse --abbrev-ref HEAD" ;
   begin
      return Exec( dir , cmd );
   end CurrentBranch ;
   --codemd: end

   procedure Clone (dir : string; repo : String; branch : String := "@") is
      cwd    : constant String  := Ada.Directories.Current_Directory;
      brname : Unbounded_String := To_Unbounded_String (branch);
      status : aliased Integer;
      use Ada.Directories;
   begin
      Put ("Cloning ");
      Put (repo);
      Put (" ");
      Put (dir);
      Put (" ");
      Put ("Branch ");
      Put (branch);
      New_Line;
      if branch = "@" then
         brname := To_Unbounded_String (DefaultBranch (repo));
      end if;
      declare
         target : constant String :=
           Ada.Directories.Compose (dir, To_String (brname));
      begin
         if Ada.Directories.Exists (target) then
            if Ada.Directories.Kind (target) /= Ada.Directories.Directory then
               Put (target);
               Put (" exists. but not a directory. aborting clone");
               New_Line;
               raise Program_Error;
            end if;
            Put (target);
            Put (" already exists. Already cloned?");
            New_Line;
            return;
         end if;
      end;
      Ada.Directories.Set_Directory (dir);
      declare
         brnamestr : constant String               := To_String (brname);
         clonecmd  : constant String               :=
           "clone --branch " & brnamestr & " " & repo & " " & brnamestr;
         arglist   : constant Argument_List_Access :=
           Argument_String_To_List (clonecmd);
         result    : constant string               :=
           GNAT.Expect.Get_Command_Output
             (fullgit.all, arglist.all, "", Status'Access, Err_To_Out => True);
      begin
         Put_Line (repo);
         Put ("Executing ");
         Put_Line (clonecmd);
         Put_Line (result);
      end;
      Ada.Directories.Set_Directory (cwd);
   end Clone;

   function Clean
     (dir : String := "."; exclude : String := "_keep") return String
   is
      result : constant String := Exec (dir, "clean -f -d -x " & exclude);
   begin
      return result;
   end Clean;

   function Pull (dir : String := ".") return String is
      result : constant String := Exec (dir, "pull --log");
   begin
      return result;
   end Pull;

   --codemd: begin segment=Tags caption=Get tags
   function Tags (dir : String := ".") return wordlistpkg.Vector is
      taglines : constant String             := Exec (dir, "tag --list");
      result   : constant wordlistPkg.Vector := Get_Lines (taglines);
   begin
      return result;
   end Tags;
   --codemd: end

   procedure Print (vec : wordlistpkg.Vector) is
      procedure Print (c : wordlistpkg.Cursor) is
         val : constant String := wordlistPkg.Element (c);
      begin
         Put_Line (val);
      end Print;
   begin
      vec.Iterate (Print'Access);
   end Print;

end git;
