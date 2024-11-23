with Interfaces; use Interfaces;

with GNAT.Strings;

package cli is

   VERSION : String := "0.1";
   NAME    : String := "frep";

   Verbosity    : aliased Integer := 0;
   candidate    : aliased GNAT.Strings.String_Access;
   candidateExp : aliased GNAT.Strings.String_Access;
   replacement  : aliased GNAT.Strings.String_Access;

   procedure ProcessCommandLine;
   function GetNextArgument return String;

end cli;
