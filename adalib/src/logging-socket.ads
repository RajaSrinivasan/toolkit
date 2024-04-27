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
     ( dest : SocketDestination_Type ;
       message : String ;
       level : message_level_type := INFORMATIONAL ;
       source : String := Default_Source_Name ;
       class : String := Default_Message_Class ) ;
   overriding
   procedure Close(dest : SocketDestination_Type) ;

end logging.socket ;