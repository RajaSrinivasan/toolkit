with GNAT.Sockets ;

package logging.socket is

   type SocketDestination_Type is new Destination_Type with
      record
         s : GNAT.Sockets.Socket_Type ;
         dest : access GNAT.Sockets.Sock_Addr_Type ;
      end record;
   type SocketDestinationPtr_Type is access all SocketDestination_Type ;

   function Create (port : GNAT.Sockets.Port_Type ;
                    host : String := "localhost" ) return SocketDestinationPtr_Type ;

   overriding
   procedure SendMessage
     ( dest : in out SocketDestination_Type ;
       message : String ;
       level : message_level_type := INFORMATIONAL ;
       source : String := Default_Source_Name ;
       class : String := Default_Message_Class ) ;
   overriding
   procedure Close(dest : SocketDestination_Type) ;

    MAX_MESSAGE_SIZE : constant := Short_Short_Integer'last ;
    type Message_Type is
    record
        l : message_level_type ;
        s : Source_Name_Type ;
        c : Message_Class_Type ;
        ml : Short_Short_Integer ;
        mt : String(1..MAX_MESSAGE_SIZE) ;
    end record ;

end logging.socket ;