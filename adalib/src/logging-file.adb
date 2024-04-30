with Images ;
package body logging.file is

   procedure Create(fd : in out FileDestination_Type) is
      filename : Unbounded_String ;
   begin
      if fd.cadence > 0.0
      then
         filename := To_Unbounded_String(To_String(fd.basename) & 
                                         images.Image(".%04d",fd.filenumber) & 
                                         To_String(fd.basetype) );
      else
         filename := To_Unbounded_String( To_String(fd.basename) & 
                                          To_String(fd.basetype) );
      end if ;
      Ada.Text_Io.Create( fd.f.all , Ada.Text_Io.Out_File , To_String(filename) ) ;
      fd.filestarted := Clock ;
   end Create ;

   function Create (name : String; 
                    filetype : String := ".log" ;
                    number : Integer := 0 ;
                    rotate : duration := 0.0 ) return FileDestinationPtr_Type is
      result : FileDestinationPtr_Type ;
   begin
      result := new FileDestination_Type ;
      result.basename := To_Unbounded_String(name) ;
      result.basetype := To_Unbounded_String(filetype) ;
      result.cadence := rotate ;
      result.filenumber := number ;

      result.f := new Ada.Text_Io.File_Type ;
      Create(result.all) ;

      return result ;
   end Create ;

   overriding
   procedure SendMessage
     ( dest : in out FileDestination_Type ;
       message : String ;
       level : message_level_type := INFORMATIONAL ;
       source : String := Default_Source_Name ;
       class : String := Default_Message_Class ) is
   begin
      if dest.cadence > 0.0 and then Clock - dest.filestarted > dest.cadence
      then
         Close(dest);
         dest.filenumber := @ + 1 ;
         Create(dest);
      end if ;
      Ada.Text_Io.Put_Line(dest.f.all , Image(message,level,source,class));
   end SendMessage;

   procedure SendMessage
     ( dest : in out FileDestination_Type ;
       prefix : String ;
       message : String ) is
   begin
       if dest.cadence > 0.0 and then Clock - dest.filestarted > dest.cadence
      then
         Close(dest);
         dest.filenumber := @ + 1 ;
         Create(dest);
      end if ;
      Ada.Text_Io.Put(dest.f.all, prefix);
      Ada.Text_Io.Put(dest.f.all," ");
      Ada.Text_Io.Put_Line(dest.f.all , message );
      Ada.Text_Io.Flush(dest.f.all);
      --Put_Line(message);
   end SendMessage ;

   overriding
   procedure Close(dest : FileDestination_Type) is
   begin
      Ada.Text_Io.Put_Line(dest.f.all,"************End of File*****************");
      Ada.Text_Io.Close(dest.f.all);
   end Close ;


end logging.file ;
