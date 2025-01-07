with System ;
with Interfaces ;
with Ada.Strings.Unbounded ; use Ada.Strings.Unbounded;
with Ada.Streams ;
with GNAT.Sockets;

package server is
   debug : boolean := true ;
   package AS renames Ada.Streams ;
   package GS renames GNAT.Sockets ;
   type ClientType is interface ;
   type ClientPtr_Type is access all ClientType'Class ;
   procedure NewClient( cl : in out ClientType ; Sock : GS.Socket_Type ; From : GS.Sock_Addr_Type ) is null ;
   procedure Message( cl : in out ClientType ; msgbytes : AS.Stream_Element_Array ;
                      Sock : GS.Socket_Type ; 
                      From : GS.Sock_Addr_Type
                      ) is null ;

   task type SockServer_Type is
      entry Serve (port : Integer; client : ClientPtr_Type) ;
   end SockServer_Type;
   type SockServer_PtrType is access all SockServer_Type;

   task type ClientSock_Type is
      entry Serve( handler : ClientPtr_Type ; sock : GS.Socket_Type ; addr : GS.Sock_Addr_Type); 
   end ClientSock_Type;
   type ClientSockPtr_Type is access all ClientSock_Type ;

   -- Compatible with the server design
   procedure Send( sock : GS.Socket_Type ; payload : AS.Stream_Element_Array );
   procedure Send( sock : GS.Socket_Type ; payload : String );
   procedure Send( sock : GS.Socket_Type ; payload : System.Address ; payloadlen : Integer );

   MAX_MESSAGE_SIZE : constant := 1024 ;

   subtype HeaderType is Interfaces.Unsigned_16 ;
private

   type DebugClient is new ClientType with
   record
      cn : Unbounded_String := Null_Unbounded_String ;
   end record ;

   procedure NewClient( cl : in out DebugClient ; Sock : GS.Socket_Type ; From : GS.Sock_Addr_Type ) ;
   procedure Message( cl : in out DebugClient ; 
                      msgbytes : AS.Stream_Element_Array ;
                      Sock : GS.Socket_Type ; 
                      From : GS.Sock_Addr_Type) ;
end server;
