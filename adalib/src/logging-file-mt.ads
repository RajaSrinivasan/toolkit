package logging.file.mt is

   protected MTFileDestination is
      procedure Create ( name : String ; 
                        filetype : String := ".log" ;
                        number : Integer := 0 ;
                        rotate : duration := 0.0 ) ;
      procedure SendMessage
      (  message : String ;
         level : message_level_type := INFORMATIONAL ;
         source : String := Default_Source_Name ;
         class : String := Default_Message_Class ) ;
   private 
      fdest : FileDestinationPtr_Type ;
   end MTFileDestination;
   
end logging.file.mt ;