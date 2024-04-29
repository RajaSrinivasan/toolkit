with Ada.Text_Io; use Ada.Text_Io;
with Ada.Strings.Unbounded ; use Ada.Strings.Unbounded ;
with Ada.Calendar ; use Ada.Calendar ;
package logging.file is

   type FileDestination_Type is new Destination_Type with
      record
         basename : Unbounded_String := Null_Unbounded_String ;
         basetype : Unbounded_String := To_Unbounded_String(".log") ;
         filenumber : Integer := 0 ;
         cadence : duration ;
         filestarted : Time ;
         f : access File_Type ;
      end record;
   type FileDestinationPtr_Type is access all FileDestination_Type ;

   function Create (name : String ; 
                    filetype : String := ".log" ;
                    number : Integer := 0 ;
                    rotate : duration := 0.0 ) return FileDestinationPtr_Type ;

   overriding
   procedure SendMessage
     ( dest : in out FileDestination_Type ;
       message : String ;
       level : message_level_type := INFORMATIONAL ;
       source : String := Default_Source_Name ;
       class : String := Default_Message_Class ) ;
   overriding
   procedure Close(dest : FileDestination_Type) ;

end logging.file;
