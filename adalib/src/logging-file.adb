package body logging.file is

   function Create (name : String) return FileDestinationPtr_Type is
      result : FileDestinationPtr_Type ;
   begin
      result := new FileDestination_Type ;
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
      Ada.Text_Io.Put_Line(dest.f.all , Image(message,level,source,class));
   end SendMessage;

   overriding
   procedure Close(dest : FileDestination_Type) is
   begin
      Ada.Text_Io.Put_Line(dest.f.all,"************End of File*****************");
      Ada.Text_Io.Close(dest.f.all);
      --dest.f := null ;
   end Close ;


end logging.file ;
