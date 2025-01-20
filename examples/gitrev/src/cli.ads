with GNAT.Strings;

package cli is

   NAME : String := "gitrev";

   Verbose    : aliased Boolean                    := False;
   HelpOption : aliased Boolean;
   outputFile : aliased GNAT.Strings.String_Access := new String'("revisions");
   version    : aliased GNAT.Strings.String_Access := new String'("0.0.1");

   procedure ProcessCommandLine;
   function GetNextArgument return String;
   procedure ShowCommandLineArguments;

end cli;
