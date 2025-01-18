with Ada.Text_Io; use Ada.Text_Io;

with Ada.Characters.Handling ; use Ada.Characters.Handling;
with Ada.Directories ;

with Ada.Strings.Fixed ; -- use Ada.Strings.Fixed ;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Strings.Maps ; use Ada.Strings.Maps ;

with GNAT.os_lib ; use GNAT.os_lib ;
with GNAT.Expect; -- use GNAT.Expect ;

package body git is

    fullgit : constant GNAT.os_lib.String_Access := Locate_Exec_On_Path("git");
    ws : constant Ada.Strings.Maps.Character_Set := To_Set(' ') or To_Set(ASCII.HT) ;
    LF : constant String(1..1) := [others => ASCII.LF];

    function End_Of_Line(str : String; from : integer) return integer is
       result : Integer ;
    begin
      result := Ada.Strings.Fixed.Index( str(from..str'Last) , LF);
      if result < from 
      then
         return str'Last ;
      else
         return result ;
      end if ;
    end End_Of_Line ;


    function RepoBaseName( url : String ) return String is
        gitpos,slpos : Natural ;
    begin
        gitpos := Ada.Strings.Fixed.Index(url,".git",url'Last,Ada.Strings.backward );
        if gitpos < url'First
        then
           Put("git repo name "); Put(url); Put (" is invalid:"); Put(Natural'Image(gitpos)); New_Line;
           raise REPO_ERROR with "repo name in " & url ;
        end if ;
        slpos := Ada.Strings.Fixed.Index(url,"/",gitpos-1,Ada.Strings.Backward);
        if slpos < url'First
        then
           Put_Line("git repo host name invalid");
           raise REPO_ERROR with "hostname in " & url ;
        end if ;
        return url(slpos+1..gitpos-1) ;
    end RepoBaseName ;

    function Exec( dir : string ;
                   cmd : String  ) return String is
        cwd : constant String := Ada.Directories.Current_Directory ;
        status : aliased Integer ;
        arglist : constant Argument_List_Access := Argument_String_To_List(cmd);

    begin
         Ada.Directories.Set_Directory(dir) ;
        declare
           result : constant string := 
                    GNAT.Expect.Get_Command_Output(fullgit.all, arglist.all , "" , Status'Access, Err_To_Out => True);
        begin
         if Verbose
         then 
             Put("Dir: "); Put(dir); Put(" cmd: "); Put_Line(cmd);
             Put_Line(result);
         end if ;
         Ada.Directories.Set_Directory(cwd);
         return result ;
        end ;
    exception
       when others =>
        Put("Exception executing "); Put(cmd); Put( " @ dir "); Put_Line(dir);
        return "" ;
    end Exec ;

   function RemoteBranches( repo : String ) return wordlistPkg.Vector is
      result : WordListPkg.Vector ;

      arglista : constant Argument_List_Access := Argument_String_To_List("ls-remote --heads " & repo );
      status : aliased Integer ;

      function branch(line: string) return string is
        wsidx : Integer ;
        nwsidx : Integer ;
      begin
        wsidx := Ada.Strings.Fixed.Index(line,ws);
        if wsidx < 1
        then
           return line ;
        end if ;
        nwsidx := Ada.Strings.Fixed.Index(line,not ws , wsidx+1);
        return line(nwsidx..line'Last) ;
      end branch ;

   begin
      declare
         lsremote : constant string := GNAT.Expect.Get_Command_Output(fullgit.all, arglista.all , "" , Status'Access, Err_To_Out => True);
         startidx, endidx : integer ;

      begin
         if status = 0
         then
            startidx := 1 ;
            loop
               endidx := Ada.Strings.Fixed.Index( lsremote(startidx..lsremote'Last) , LF);
               if endidx < Startidx 
               then
                   result.Append(branch(lsremote(startidx..lsremote'Last))) ;
                   exit ;
               end if ;
               result.Append(branch(lsremote(startidx..endidx-1)));
               startidx := endidx + 1 ;
            end loop ;
         else
            Put_Line("Error getting the branch names from the repo");
            Put_Line(lsremote);
        end if;
        end ;
        return result ;
    end RemoteBranches ;

    function Branches( repo : String ) return wordlistPkg.Vector is
        result : wordlistpkg.Vector ;
        cmd : constant String := "branch --list" ;
        allbranches : constant String := Exec(repo,cmd);
        from : Integer := 1 ;
        to : Integer ;
    begin
        while from < allbranches'Last 
        loop
            to := End_Of_Line(allbranches,from);
            result.Append(allbranches(from..to));
            from := to + LF'length;
        end loop ;
        return result ;
    end Branches ;


    function DefaultBranch( repo : String ) return String is
        arglista : constant Argument_List_Access := Argument_String_To_List("remote show " & repo );
        status : aliased Integer ;
        showremote : constant string := GNAT.Expect.Get_Command_Output(fullgit.all, arglista.all , "" , Status'Access, Err_To_Out => True);
        headword : constant String := "HEAD branch: ";
        hidx : integer ;
  begin
        if status = 0
        then
            hidx := Ada.Strings.Fixed.Index( showremote , headword) ;
            if hidx > 0
            then
                -- cridx := Ada.Strings.Fixed.Index( showremote , cr , hidx+1 );
                declare
                   brname : Unbounded_String := Null_Unbounded_String ;
                begin
                   for idx in hidx + headword'length .. showremote'Last
                   loop
                       if Is_Alphanumeric(showremote(idx))
                       then
                          Append(brname,showremote(idx));
                       else
                          return To_String(brname) ;
                       end if ;
                   end loop ;
                   return To_String(brname);
                end ;
            else
               return "unknown" ;
            end if ;
        else
           return "unknown" ;
        end if ;
    end DefaultBranch ;
 

   function RepoUrl( dir : String := ".") return String is
       repourlcmd : constant String := "remote get-url origin" ; 
   begin
      declare
         url : constant string := Exec(dir,repourlcmd) ; 
      begin
         return url ;
       end ;
   end RepoUrl ;

  function CommitId( dir : String := ".") return String is
       cmd : constant String := "rev-parse HEAD" ; 
   begin
      declare
         cid : constant string := Exec(dir,cmd) ; 
      begin
         return cid ;
       end ;
   end CommitId ;


   function AbbrevCommitId( dir : String := ".") return String is
    begin
      return Abbrev(commitid(dir)) ;
   end AbbrevCommitId ;

   function Abbrev( fullcommitid : String ) return String is
    begin
      return fullcommitid(fullcommitid'First..fullcommitid'First+6);
   end Abbrev ;


    function CurrentBranch( dir : String := "." ) return String is
        cwd : constant  String := Ada.Directories.Current_Directory ;
        arglista : constant Argument_List_Access := Argument_String_To_List("rev-parse --abbrev-ref HEAD" );
        status : aliased Integer ;
    begin
        if dir /= "."
        then
           Ada.Directories.Set_Directory(dir);
        end if ;
        declare
            brname : constant string := GNAT.Expect.Get_Command_Output(fullgit.all, arglista.all , "" , Status'Access, Err_To_Out => True);
        begin
            Ada.Directories.Set_Directory(cwd);
            return brname ;
        end ;
    end CurrentBranch ;

    procedure Clone( dir : string ;
                     repo : String ; 
                     branch : String := "@" ) is
        cwd : constant String := Ada.Directories.Current_Directory ;
        brname : Unbounded_String := To_Unbounded_String(branch);
        status : aliased Integer ;
        use Ada.Directories ;
    begin
        Put("Cloning "); Put(repo) ; Put(" "); Put( dir ); Put(" "); Put("Branch "); Put(branch); New_LIne;
        if branch = "@"
        then
           brname := To_Unbounded_String( DefaultBranch(repo) );
        end if ;
        declare
           target : constant String := Ada.Directories.Compose( dir , To_String(brname) );
        begin
           if Ada.Directories.Exists( target )
           then
              if Ada.Directories.Kind( target ) /= Ada.Directories.Directory
              then
                 Put(target); Put( " exists. but not a directory. aborting clone"); New_Line ;
                 raise Program_Error ;
              end if ;
              Put(target); Put( " already exists. Already cloned?"); New_Line ;
              return ;
           end if ;
        end ;
        Ada.Directories.Set_Directory(dir) ;
        declare
          brnamestr : constant String := To_String(brname);
          clonecmd : constant String := "clone --branch " & brnamestr & " "
                               & repo & " " & brnamestr ;
          arglist : constant Argument_List_Access := Argument_String_To_List(clonecmd);
          result : constant string := 
                    GNAT.Expect.Get_Command_Output(fullgit.all, arglist.all , "" , Status'Access, Err_To_Out => True);
        begin
        Put_Line(repo);
          Put("Executing "); Put_Line(clonecmd);
          Put_Line(result);
        end ;
        Ada.Directories.Set_Directory(cwd);
    end Clone ;

   function Clean( dir : String ; exclude : String := "_keep" ) return String is
      result : constant String := Exec(dir,"clean -f -d -x " & exclude );
   begin
      return result ;
   end Clean ;

   function Pull( dir : String ) return String is
      result : constant String := Exec(dir,"pull --log");
   begin
      return result ;
   end Pull ;


end git ;
