with System;
with Interfaces;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Streams;
with GNAT.Sockets;

package server is
   debug : Boolean := False;
   package AS renames Ada.Streams;
   package GS renames GNAT.Sockets;

   -- codemd: begin segment=Interface caption=Another OO style
   type ServiceType is interface;
   type ServicePtr_Type is access all ServiceType'Class;

   -- Services that can be provided by a server
   procedure ServiceConnection
     (svc  : in out ServiceType; Sock : GS.Socket_Type;
      From :        GS.Sock_Addr_Type) is null;
   procedure Message
     (svc  : in out ServiceType; msgbytes : AS.Stream_Element_Array;
      Sock :        GS.Socket_Type; From : GS.Sock_Addr_Type) is null;
   -- codemd: end

   -- codemd: begin segment=Server caption=serverframework
   task type SockServer_Type is
      entry Serve (port : Integer; svc : ServicePtr_Type);
   end SockServer_Type;
   type SockServer_PtrType is access all SockServer_Type;

   -- proxy for each client
   task type ClientSock_Type is
      entry Serve
        (handler : ServicePtr_Type; sock : GS.Socket_Type;
         addr    : GS.Sock_Addr_Type);
   end ClientSock_Type;
   type ClientSockPtr_Type is access all ClientSock_Type;
   -- codemd: end
   
   -- Compatible with the server design.
   -- Use to send to server or
   -- as reply from servers
   procedure Send (sock : GS.Socket_Type; payload : AS.Stream_Element_Array);
   procedure Send (sock : GS.Socket_Type; payload : String);
   procedure Send
     (sock : GS.Socket_Type; payload : System.Address; payloadlen : Integer);
   function Receive (sock : GS.Socket_Type) return AS.Stream_Element_Array;

   MAX_MESSAGE_SIZE : constant := 1_024;

   subtype HeaderType is Interfaces.Unsigned_16;

   procedure CreateDebugServer;
   function ConnectDebugServer return GS.Socket_Type;

private

   type DebugService is new server.ServiceType with record
      cn : Unbounded_String := Null_Unbounded_String;
   end record;

   procedure ServiceConnection
     (svc  : in out DebugService; Sock : GS.Socket_Type;
      From :        GS.Sock_Addr_Type);
   procedure Message
     (svc  : in out DebugService; msgbytes : AS.Stream_Element_Array;
      Sock :        GS.Socket_Type; From : GS.Sock_Addr_Type);
end server;
