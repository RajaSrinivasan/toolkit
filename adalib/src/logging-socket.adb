with Ada.Text_IO;      use Ada.Text_IO;
with Ada.Exceptions;   use Ada.Exceptions;
with Ada.Streams;      use Ada.Streams;
with GNAT.Source_Info; use GNAT.Source_Info;
package body logging.socket is
   package GS renames GNAT.Sockets;

   function Create
     (port : GNAT.Sockets.Port_Type; host : String := "127.0.0.1")
      return SocketDestinationPtr_Type
   is
      result : constant SocketDestinationPtr_Type    :=
        new SocketDestination_Type;
      he : constant GNAT.Sockets.Host_Entry_Type := GS.Get_Host_By_Name (host);
   begin
      GS.Create_Socket
        (result.s, Mode => GS.Socket_Datagram,
         Level          => GS.IP_Protocol_For_UDP_Level);
      result.dest := new GS.Sock_Addr_Type;

      if GS.Addresses_Length (he) < 1 then
         raise Program_Error with "Unknown host " & host;
      end if;

      result.dest.all :=
        GS.Network_Socket_Address (Addr => GS.Addresses (he, 1), Port => port);

      return result;
   exception
      when e : others =>
         Put_Line (Exception_Message (e));
         Put ("Exception in ");
         Put (Enclosing_Entity);
         New_Line;
         raise;
   end Create;

   -- codemd: begin segment=SockDest caption=Socket destination
   overriding procedure SendMessage
     (dest   : in out SocketDestination_Type; message : String;
      level  :        message_level_type := INFORMATIONAL;
      source :        String             := Default_Source_Name;
      class  :        String             := Default_Message_Class)
   is
      m       : aliased Message_Type;
      payload : Ada.Streams.Stream_Element_Array (1 .. m'Size / 8);
      for payload'Address use m'Address;
      last : Ada.Streams.Stream_Element_Offset;
   begin
      m.t   := Ada.Calendar.Clock;
      m.Seq := dest.Count + 1;
      m.l   := level;
      m.s   := source;
      m.c   := class;
      if message'Length > MAX_MESSAGE_SIZE then
         m.ml := MAX_MESSAGE_SIZE;
         m.mt := message (1 .. MAX_MESSAGE_SIZE);
      else
         m.ml                       := message'Length;
         m.mt (1 .. message'Length) := message;
      end if;
      GS.Send_Socket (dest.s, payload, last, To => dest.dest);
      if last /= m'Size / 8 then
         raise Program_Error with "Truncated datagram";
      end if;
      dest.Count := @ + 1;
   end SendMessage;
   -- codemd: end

   overriding procedure Close (dest : SocketDestination_Type) is
   begin
      GS.Close_Socket (dest.s);
   end Close;

end logging.socket;
