with Ada.Text_Io; use Ada.Text_Io;

package logging.file is

   type FileDestination_Type is new Destination_Type with
      record
         f : access File_Type ;
      end record;
   type FileDestinationPtr_Type is access all FileDestination_Type ;

   function Create (name : String) return FileDestinationPtr_Type ;

   overriding
   procedure SendMessage
     ( dest : FileDestination_Type ;
       message : String ;
       level : message_level_type := INFORMATIONAL ;
       source : String := Default_Source_Name ;
       class : String := Default_Message_Class ) ;
   overriding
   procedure Close(dest : FileDestination_Type) ;

end logging.file;
