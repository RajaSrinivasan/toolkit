with GNAT.Strings;

package cli is

   VERSION : String := "0.1";
   NAME    : String := "vrex";
   CLI_ERROR : exception;

   Verbosity    : aliased Integer := 0;
   candidateExp : aliased GNAT.Strings.String_Access;
   filesOption : aliased boolean ;
   globOption : aliased boolean ;
   caseInsensitiveOption : aliased boolean ;
   
   procedure ProcessCommandLine;
   function GetNextArgument return String;

end cli;
