package body logging.socket is
   function Create (port : GNAT.Sockets.Port_Type ;
                    host : String := "localhost" ) 
                    return SocketDestinationPtr_Type is
        result : SocketDestinationPtr_Type := new SocketDestination_Type ;
    begin
        return result ;
    end Create ;

   overriding
   procedure SendMessage
     ( dest : SocketDestination_Type ;
       message : String ;
       level : message_level_type := INFORMATIONAL ;
       source : String := Default_Source_Name ;
       class : String := Default_Message_Class ) is
    begin
        null ;
    end SendMessage;

   overriding
   procedure Close(dest : SocketDestination_Type) is
    begin
        null ;
    end Close ;

end logging.socket ;
