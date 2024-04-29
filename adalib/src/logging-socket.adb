
package body logging.socket is
    package GS Renames GNAT.Sockets;

   function Create (port : GNAT.Sockets.Port_Type ;
                    host : String := "localhost" ) 
                    return SocketDestinationPtr_Type is
        result : constant SocketDestinationPtr_Type := new SocketDestination_Type ;
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
     ( dest : in out SocketDestination_Type ;
       message : String ;
       level : message_level_type := INFORMATIONAL ;
       source : String := Default_Source_Name ;
       class : String := Default_Message_Class ) is
       m : aliased Message_Type ;
       payload : Ada.Streams.Stream_Element_Array( 1..m'Size/8 );
       for payload'Address use m'Address;
       last : Ada.Streams.Stream_Element_Offset ;
    begin
        m.l := level ;
        m.s := source ;
        m.c := class ;
        if message'Length > MAX_MESSAGE_SIZE
        then
            m.ml := MAX_MESSAGE_SIZE ;
            m.mt := message(1..MAX_MESSAGE_SIZE);
        else
            m.ml := message'Length ;
            m.mt(1..message'Length) := message ;
        end if ;
        GS.Send_Socket( dest.s , payload , last , to => dest.dest );
        if last /= m'Size/8
        then
            raise Program_Error with "Truncated datagram";
        end if ;
    end SendMessage;

   overriding
   procedure Close(dest : SocketDestination_Type) is
    begin
        GS.Close_Socket( dest.s );
    end Close ;

end logging.socket ;
