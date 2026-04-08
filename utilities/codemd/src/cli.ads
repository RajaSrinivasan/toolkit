with GNAT.Strings;

package cli is

   VERSION : String := "0.6.0";

   NAME       : String := "codemd";
   Verbose    : aliased Boolean := False;
   HelpOption : aliased Boolean;
   allsections     : aliased Boolean := False;

   extractSection : aliased GNAT.Strings.String_Access;
   caption        : aliased GNAT.Strings.String_Access;
   lines          : aliased GNAT.Strings.String_Access;
   exec           : aliased GNAT.Strings.String_Access;
   output         : aliased GNAT.Strings.String_Access;
   output_file    : aliased GNAT.Strings.String_Access;
   output_dir     : aliased GNAT.Strings.String_Access;
   
   DEFAULT_LINECOUNT : constant := 8;
   lineno_from, linecount : Integer := 0;

   procedure ProcessCommandLine;
   function GetNextArgument return String;
   procedure ShowCommandLineArguments;

end cli;
