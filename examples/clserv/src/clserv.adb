with Ada.Text_IO;      use Ada.Text_IO;
with Ada.Command_Line; use Ada.Command_Line;
with Ada.Streams;
with GNAT.Source_Info;
with GNAT.Sockets;

with server;

procedure Clserv is
   debug : Boolean := True;

   package GS renames GNAT.Sockets;
   package GSI renames GNAT.Source_Info;
   package AS renames Ada.Streams;

   sock : GS.Socket_Type;

   procedure T1 is
      pl : Integer;
   begin
      Put_Line (GSI.Enclosing_Entity);

      for i in 1 .. 10 loop
         --codemd: begin segment=Interact caption=send and receive reply
         -- Essentially a half-duplex interaction. Send and wait for a response
         pl := i;
         server.Send (sock, pl'Address, pl'Size / 8);
         declare
            resp  : AS.Stream_Element_Array := server.Receive (sock);
            resps : String (1 .. resp'Length);
            for resps'Address use resp'Address;
         begin
            -- The default server replies with the hex dump of the payload
            Put (resps);
            New_Line;
         end;
         --codemd: end
      end loop;
   end T1;

   --codemd: begin segment=DClient caption=Double floating client
   procedure T2 is
      pl : Long_Float;
   begin
      Put_Line (GSI.Enclosing_Entity);
      for i in 1 .. 20 loop
         pl := Long_Float (i);
         server.Send (sock, pl'Address, pl'Size / 8);
         declare
            resp  : AS.Stream_Element_Array := server.Receive (sock);
            resps : String (1 .. resp'Length);
            for resps'Address use resp'Address;
         begin
            Put (resps);
            New_Line;
         end;
      end loop;
   end T2;
   --codemd: end
begin
   if debug then
      Put (GSI.Enclosing_Entity);
      Put (" ");
      Put (GSI.File);
      Put (" ");
      Put (GSI.Compilation_Date);
      Put (" ");
      Put (GSI.Compilation_Time);
      New_Line;
   end if;

   if Argument_Count < 1 then
      Put_Line ("usage: clserv [s|t1|t2]");
      return;
   end if;

   if Argument (1) = "s" then
      server.CreateDebugServer;
   else
      if Argument (1) = "t1" then
         sock := server.ConnectDebugServer;
         T1;
         T2;
      elsif Argument (1) = "t2" then
         sock := server.ConnectDebugServer;
         T2;
         T1;
      else
         Put (Argument (1));
         Put_Line (" is not recognized");
      end if;
      GS.Close_Socket (sock);
   end if;
end Clserv;
