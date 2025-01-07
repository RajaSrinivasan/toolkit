
package body logging.socket.stream is

    package GS Renames GNAT.Sockets;

   function Create (port : GNAT.Sockets.Port_Type ;
                    host : String := "127.0.0.1" ) return SocketDestinationPtr_Type is
      result : constant SocketDestinationPtr_Type := new SocketDestination_Type ;
      adr : GS.Sock_Addr_Type ;
   begin
      GS.Create_Socket( result.s );
      adr.Addr := GS.Addresses(GS.Get_Host_By_Name (Host), 1);
      adr.Port := port ;
      GS.Connect_Socket( result.s , adr ) ;
      result.connected := true ;
      SetDestination( result );
      return result ;
   end Create ;

   overriding
   procedure SendMessage
     ( dest : in out SocketDestination_Type ;
       message : String ;
       level : message_level_type := INFORMATIONAL ;
       source : String := Default_Source_Name ;
       class : String := Default_Message_Class ) is
      hdr : Message_Header_Type ;
      hdrsize : constant Short_Integer := hdr'Size/8 ;
   begin
      hdr.ms :=  Short_Short_Integer(hdrsize) + 
                  (message'length)  - 2 ;

      hdr.t := Ada.Calendar.Clock ;
      hdr.l := level ;
      hdr.s := source ;
      hdr.c := class ;
      Message_Header_Type'Write ( GS.Stream(dest.s) , hdr);
      String'Write (GS.Stream(dest.s) , message );
   end SendMessage;

   overriding
   procedure Close(dest : SocketDestination_Type) is
   begin
      GS.Close_Socket( dest.s );
   end Close ;

end logging.socket.stream;
