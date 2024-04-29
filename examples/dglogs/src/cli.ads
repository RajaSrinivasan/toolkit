with Interfaces ; use Interfaces ;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded ;
with Ada.Containers.Vectors ;


package cli is

   VERSION : string := "0.1" ;
   NAME : String := "dglogs" ;
      
   Verbosity : aliased Integer := 0;
   port : aliased Integer := 8689 ;
   logname : Ada.Strings.Unbounded.Unbounded_String ;
   logdir : Ada.Strings.Unbounded.Unbounded_String ;

   rotation : duration := 3600.0 ;
   
   procedure ProcessCommandLine ;
   function GetNextArgument return String ;
   
end cli ;