with Ada.Text_IO; use Ada.Text_IO;

with GNAT.Source_Info;
with Hex;

package body server is

   use GNAT.Sockets;
   package GSI renames GNAT.Source_Info;

   task body SockServer_Type is

      mysocket     : GS.Socket_Type;
      myaddr       : GS.Sock_Addr_Type;
      socketoption : GS.Option_Type (GS.Receive_Timeout);
      bufsize      : GS.Option_Type (GS.Receive_Buffer);

      clientsocket : GS.Socket_Type;
      clientaddr   : GS.Sock_Addr_Type;
      accstatus    : GS.Selector_Status;

      sockclient : ClientSockPtr_Type;
      handler    : ServicePtr_Type;
   begin
      accept Serve (port : Integer; svc : ServicePtr_Type) do
         handler := svc;
         GS.Create_Socket (mysocket, Mode => GNAT.Sockets.Socket_Stream);
         myaddr.Addr := GS.Any_Inet_Addr;
         myaddr.Port := GS.Port_Type (port);
         GS.Bind_Socket (mysocket, myaddr);
         socketoption.Timeout := 1.0;
         GS.Set_Socket_Option
           (mysocket, GS.Socket_Level, Option => socketoption);
         bufsize.Size := 1_024 * 1_024;
         GS.Set_Socket_Option (mysocket, GS.Socket_Level, Option => bufsize);
         GS.Listen_Socket (mysocket);
      end Serve;
      -- codemd: begin segment=Server caption=main Server logic
      loop
         GS.Accept_Socket
           (mysocket, clientsocket, clientaddr, 5.0, Status => accstatus);
         if accstatus = GS.Completed then
            pragma Debug (Put_Line ("Received a connection"));
            sockclient := new ClientSock_Type;
            sockclient.Serve (handler, clientsocket, clientaddr);
         end if;
      end loop;
      -- codemd: end
   end SockServer_Type;

   task body ClientSock_Type is
      myhandler : ServicePtr_Type;
      mysock    : GS.Socket_Type;
      myaddr    : GS.Sock_Addr_Type;

      msglen : aliased HeaderType;
      buffer : AS.Stream_Element_Array (1 .. server.MAX_MESSAGE_SIZE);
   begin

      accept Serve
        (handler : ServicePtr_Type; sock : GS.Socket_Type;
         addr    : GS.Sock_Addr_Type)
      do
         myhandler := handler;
         mysock    := sock;
         myaddr    := addr;
      end Serve;
   -- codemd: begin segment=Clientproxy caption=Basic Socket handling
      -- Let the handler do its thing
      myhandler.ServiceConnection (mysock, myaddr);
      loop
         HeaderType'Read (GS.Stream (mysock), msglen);
         AS.Stream_Element_Array'Read
           (GS.Stream (mysock),
            buffer (1 .. AS.Stream_Element_Offset (msglen)));
         myhandler.Message
           (buffer (1 .. AS.Stream_Element_Offset (msglen)), mysock, myaddr);
      end loop;
   -- codemd: end

   end ClientSock_Type;

   ds : aliased DebugService;

   -- codemd: begin segment=Debugserv caption=Example for Service
   procedure ServiceConnection
     (svc  : in out DebugService; Sock : GS.Socket_Type;
      From :        GS.Sock_Addr_Type)
   is
   begin
      Put (GSI.Source_Location);
      Put (" > New Connection from ");
      svc.cn := To_Unbounded_String (GS.Image (From));
      Put (To_String (svc.cn));
      New_Line;
   end ServiceConnection;

   procedure Message
     (svc  : in out DebugService; msgbytes : AS.Stream_Element_Array;
      Sock :        GS.Socket_Type; From : GS.Sock_Addr_Type)
   is
      resp : aliased constant String :=
        Hex.Image (msgbytes'Address, msgbytes'Length);
   begin
      Put (To_String (svc.cn));
      Put (" sent > Message of length ");
      Put (msgbytes'Length'Image);
      New_Line;
      Send (Sock, resp);
   end Message;
   -- codemd: end

   -- codemd: begin segment=SendReceive caption=Core send/receive
   procedure Send (sock : GS.Socket_Type; payload : AS.Stream_Element_Array) is
      hdr : constant HeaderType := HeaderType (payload'Length);
   begin
      HeaderType'Write (GS.Stream (sock), hdr);
      AS.Stream_Element_Array'Write (GS.Stream (sock), payload);
   end Send;

   function Receive (sock : GS.Socket_Type) return AS.Stream_Element_Array is
      hdr    : HeaderType;
      buffer : AS.Stream_Element_Array (1 .. MAX_MESSAGE_SIZE);
   begin
      HeaderType'Read (GS.Stream (sock), hdr);
      AS.Stream_Element_Array'Read
        (GS.Stream (sock), buffer (1 .. AS.Stream_Element_Offset (hdr)));
      return buffer (1 .. AS.Stream_Element_Offset (hdr));
   end Receive;
   -- codemd: end

   procedure Send (sock : GS.Socket_Type; payload : String) is
      hdr : constant HeaderType := HeaderType (payload'Length);
   begin
      HeaderType'Write (GS.Stream (sock), hdr);
      String'Write (GS.Stream (sock), payload);
   end Send;

   procedure Send
     (sock : GS.Socket_Type; payload : System.Address; payloadlen : Integer)
   is
      hdr : constant HeaderType := HeaderType (payloadlen);
      pl  :
        AS.Stream_Element_Array (1 .. AS.Stream_Element_Offset (payloadlen));
      for pl'Address use payload;
   begin
      HeaderType'Write (GS.Stream (sock), hdr);
      AS.Stream_Element_Array'Write (GS.Stream (sock), pl);
   end Send;

   debugServer : SockServer_PtrType;
   procedure CreateDebugServer is
   begin
      debugServer := new server.SockServer_Type;
      debugServer.Serve (1_056, ds'Access);
   end CreateDebugServer;

   function ConnectDebugServer return GS.Socket_Type is
      result : GS.Socket_Type;
      myaddr : GS.Sock_Addr_Type;
   begin
      GS.Create_Socket (result, Mode => GNAT.Sockets.Socket_Stream);
      myaddr.Addr := GS.Any_Inet_Addr;
      myaddr.Port := GS.Port_Type (1_056);
      GS.Connect_Socket (result, myaddr);
      return result;
   end ConnectDebugServer;

end server;
