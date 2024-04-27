package body logging.socket is
    package GS Renames GNAT.Sockets;

   function Create (port : GNAT.Sockets.Port_Type ;
                    host : String := "localhost" ) 
                    return SocketDestinationPtr_Type is
        result : SocketDestinationPtr_Type := new SocketDestination_Type ;
    begin
        GS.Create_Socket( result.s , 
                            mode => GS.Socket_Datagram ,
                            level => GS.IP_Protocol_For_UDP_Level);
        result.dest := new GS.Sock_Addr_Type ;
        result.dest.all := GS.Network_Socket_Address( addr => GS.Inet_Addr(host) ,
                                                   port => port );
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
