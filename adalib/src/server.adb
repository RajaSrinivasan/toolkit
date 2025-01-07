with Ada.Text_IO; use Ada.Text_IO;

with GNAT.Source_Info ; 
with server;
package body server is

   use GNAT.Sockets ;
   package GSI renames GNAT.Source_Info ;

   debugServer : SockServer_PtrType ;
   task body SockServer_Type is

      mysocket : GS.Socket_Type;
      myaddr   : GS.Sock_Addr_Type;
      socketoption : GS.Option_Type (GS.Receive_Timeout);
      bufsize : GS.Option_Type (GS.Receive_Buffer);

      clientsocket : GS.Socket_Type;
      clientaddr   : GS.Sock_Addr_Type;
      accstatus    : GS.Selector_Status;

      sockclient : ClientSockPtr_Type ;
      handler : ClientPtr_Type ;
   begin
      accept Serve (port : Integer; client : ClientPtr_Type) do
         handler := client ;
         GS.Create_Socket
           (mysocket,
            Mode => GNAT.Sockets.Socket_Stream);
         myaddr.Addr := GS.Any_Inet_Addr;
         myaddr.Port := GS.Port_Type (port);
         GS.Bind_Socket (mysocket, myaddr);
         socketoption.Timeout := 1.0;
         GS.Set_Socket_Option (mysocket, GS.Socket_Level , Option => socketoption);
         bufsize.Size := 1024 * 1024;
         GS.Set_Socket_Option (mysocket, GS.Socket_Level , Option => bufsize);
         GS.Listen_Socket(mysocket);
      end Serve ;
      loop
         GS.Accept_Socket
            (mysocket,
            clientsocket,
            clientaddr,
            5.0,
            Status => accstatus);
         if accstatus = GS.Completed 
         then
            pragma Debug (Put_Line ("Received a connection"));
            sockclient := new ClientSock_Type;
            sockclient.Serve ( handler , clientsocket, clientaddr );
         end if;
      end loop ;
   end ;

   task body ClientSock_Type is
      myhandler : ClientPtr_Type ;
      mysock : GS.Socket_Type ;
      myaddr : GS.Sock_Addr_Type ;

      msglen : aliased HeaderType ;
      buffer : AS.Stream_Element_Array(1..server.MAX_MESSAGE_SIZE);
   begin
      accept Serve( handler : ClientPtr_Type ; sock : GS.Socket_Type ; addr : GS.Sock_Addr_Type) do
         myhandler := handler ;
         mysock := sock ;
         myaddr := addr ;
      end Serve ;
      MyHandler.NewClient( mysock , myaddr );
      loop 
         HeaderType'Read( GS.Stream(mysock) , msglen );
         AS.Stream_Element_Array'Read( GS.Stream(mysock) , buffer( 1..AS.Stream_Element_Offset(msglen) ) );
         Myhandler.Message( buffer(1..AS.Stream_Element_Offset(msglen)) , mysock , myaddr );
      end loop ;
   end;

   dg : aliased DebugClient ;
   procedure NewClient( cl : in out DebugClient ; Sock : GS.Socket_Type ; From : GS.Sock_Addr_Type ) is 
   begin
      Put( GSI.Source_Location ); Put(" > ");
      cl.cn := To_Unbounded_String( GS.Image(from) );
      Put( To_String(cl.cn) ) ;
      New_Line ;
   end NewClient ;

   procedure Message( cl : in out DebugClient ; 
                      msgbytes : AS.Stream_Element_Array ; 
                      Sock : GS.Socket_Type ; 
                      From : GS.Sock_Addr_Type 
                    ) is
   begin
      Put( To_String( cl.cn) ); Put(" > ");
      Put( msgbytes'Length'Image );
      New_Line ;
   end Message ;

   procedure Send( sock : GS.Socket_Type ; payload : AS.Stream_Element_Array ) is
      hdr : constant HeaderType := HeaderType(payload'Length) ;
   begin
      HeaderType'Write( GS.Stream(sock) , hdr );
      AS.Stream_Element_Array'Write( GS.Stream(sock) , payload );
   end Send ;

   procedure Send( sock : GS.Socket_Type ; payload : String ) is
      hdr : constant HeaderType := HeaderType(payload'Length) ;
   begin
      HeaderType'Write( GS.Stream(sock) , hdr );
      String'Write( GS.Stream(sock) , payload );
   end Send ;

   procedure Send( sock : GS.Socket_Type ; payload : System.Address ; payloadlen : Integer ) is
      hdr : constant HeaderType := HeaderType(payloadLen) ;
      pl : AS.Stream_Element_Array(1..AS.Stream_Element_Offset(payloadlen));
      for pl'Address use payload;
   begin
      HeaderType'Write( GS.Stream(sock) , hdr );
      AS.Stream_Element_Array'Write( GS.Stream(sock) , pl );
   end Send ;

begin
   if debug
   then
      debugServer := new server.SockServer_Type ;
      debugServer.Serve( 1056 , dg'access );
   end if ;
end server ;