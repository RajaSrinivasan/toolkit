with Interfaces ; use Interfaces ;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded ;
with Ada.Containers.Vectors ;


package cli is

   VERSION : string := "0.1" ;
   NAME : String := "clitool" ;
      
   Verbosity : aliased Integer := 0;

   
   procedure ProcessCommandLine ;
   function GetNextArgument return String ;
   
end cli ;