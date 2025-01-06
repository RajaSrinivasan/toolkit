package logging.socket.stream is


   type SocketDestination_Type is new logging.socket.SocketDestination_Type with
   record
      connected : boolean := false ;             -- Remote Socket
   end record ;
   type SocketDestinationPtr_Type is access all SocketDestination_Type ;
   -- type LogReceiverPtr_Type is new SocketDestinationPtr_Type ;

   function Create (port : GNAT.Sockets.Port_Type ;
                    host : String := "127.0.0.1" ) return SocketDestinationPtr_Type ;

   overriding
   procedure SendMessage
     ( dest : in out SocketDestination_Type ;
       message : String ;
       level : message_level_type := INFORMATIONAL ;
       source : String := Default_Source_Name ;
       class : String := Default_Message_Class ) ;

   overriding
   procedure Close(dest : SocketDestination_Type) ;

    type Message_Header_Type is
    record
         ms : Short_Short_Integer ;
         s : Source_Name_Type ;
         c : Message_Class_Type ;
         l : message_level_type ;
         t : Ada.Calendar.Time ;
    end record ;
    pragma Pack(Message_Header_Type);

end logging.socket.stream ;
