package body logging.file is

   function Create (name : String) return FileDestination_Type is
      result : FileDestination_Type ;
   begin
      result.f := new Ada.Text_Io.File_Type ;
      Ada.Text_Io.Create( result.f.all , Ada.Text_Io.Out_File , name ) ;
      return result ;
   end Create ;

   overriding
   procedure SendMessage
     ( dest : FileDestination_Type ;
       message : String ;
       level : message_level_type := INFORMATIONAL ;
       source : String := Default_Source_Name ;
       class : String := Default_Message_Class ) is
   begin
      null ;
   end SendMessage;
end logging.file ;
