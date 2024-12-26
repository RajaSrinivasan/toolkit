with Ada.Calendar.Formatting;
with Ada.Streams;
with Ada.Text_IO;      use Ada.Text_IO;
with GNAT.Source_Info; use GNAT.Source_Info;

with GNAT.Sockets;

with logging;
with logging.socket;
with cstdout;

procedure dgserver is

   myname   : constant String := Enclosing_Entity;
   mysocket : GNAT.Sockets.Socket_Type;
   myaddr   : GNAT.Sockets.Sock_Addr_Type;
   port     : constant        := 1_056;

   procedure ReceiveAndLogDatagram is
      use type Ada.Streams.Stream_Element_Offset;
      logmsg      : aliased logging.socket.Message_Type;
      msgreceived : Ada.Streams.Stream_Element_Array (1 .. logmsg'Size / 8);
      for msgreceived'Address use logmsg'Address;
      msgrlength : Ada.Streams.Stream_Element_Offset;
      From       : GNAT.Sockets.Sock_Addr_Type;
   begin
      logging.SetDestination (cstdout.handle'Access);
      loop
         GNAT.Sockets.Receive_Socket
           (mysocket, msgreceived, msgrlength, From => From);
         pragma Debug
           (Put_Line ("Got a message. from " & GNAT.Sockets.Image (From)));

         logging.SendMessage
           (GNAT.Sockets.Image (from) & " " &
            Ada.Calendar.Formatting.Local_Image (logmsg.t) & " " &
            logmsg.mt (1 .. Integer (logmsg.ml)),
            logmsg.l, logmsg.s, logmsg.c);
      end loop;
   exception
      when Error : others =>
         null;
   end ReceiveAndLogDatagram;
begin
   GNAT.Sockets.Create_Socket (mysocket, Mode => GNAT.Sockets.Socket_Datagram);
   myaddr.Addr := GNAT.Sockets.Any_Inet_Addr;
   myaddr.Port := GNAT.Sockets.Port_Type (port);
   GNAT.Sockets.Bind_Socket (mysocket, myaddr);
   ReceiveAndLogDatagram;
end dgserver;
