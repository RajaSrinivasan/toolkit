with wordlistPkg ; 

-- @summary
-- Interface to git
--
-- @descriptionn
-- Uses git command line to perform common functions
-- Requires git to be locatable in the path
package git is

   verbose : boolean := false ;
   REPO_ERROR : exception ;
   function RepoBaseName( url : String ) return String ;

   function Branches( repo : String ) return wordlistPkg.Vector ;
   -- List the branches of a checked out repository
   -- @param repo The dir of the repository
   -- @returns A list of branch names

   function RemoteBranches( repo : String ) return wordlistPkg.Vector ;
   -- List the branches of the remote repository
   -- @param repo The url of the repository
   -- @returns A list of branch names

   function DefaultBranch( repo : String ) return String ;
   -- Find out the default branch
   -- @param repo The url of the repository
   -- @returns The default branch name

   function RepoUrl( dir : String := ".") return String ;

   function CurrentBranch( dir : String := "." ) return String ;
   -- Find the current branch in the local working directory
   -- @param dir The local working directory
   -- @returns Current branch name

   function CommitId( dir : String := "." ) return String ;
   function AbbrevCommitId( dir : String := "." ) return String ;
   function Abbrev( fullcommitid : String ) return String ;
    

   procedure Clone( dir : string ;
                    repo : String ; 
                    branch : String := "@" ) ;
   -- Clones the repsitory to the Jobpace. Create a directory for the
   -- specified branch.
   -- @param dir The directory for where the repo should be cloned with the branch name
   -- @param repo The url of the repository
   -- @param branch The name of the branch to clone. if default then default branch

   function Clean( dir : String ; exclude : String := "_keep" ) return String;
   function Pull( dir : String ) return String;

end git ;
