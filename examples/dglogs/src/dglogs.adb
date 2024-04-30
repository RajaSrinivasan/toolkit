with Ada.Text_Io; use Ada.Text_Io;
with Ada.Streams ; use Ada.Streams ;
with Ada.Calendar.Formatting ; use Ada.Calendar.Formatting ;
with Ada.Calendar.Time_Zones ; use Ada.Calendar.Time_Zones ;
with Ada.Strings.Unbounded ;  use Ada.Strings.Unbounded;
with GNAT.Sockets ; use GNAT.Sockets;

with cli ; use cli ;
with images ;
with logging ; 
with logging.file ;
with logging.socket ;


procedure Dglogs is
   package GS renames GNAT.Sockets ;
   s : GS.Socket_Type ;

   sa : GS.Sock_Addr_Type ;
   sender : GS.Sock_Addr_Type ;
   lm : aliased logging.socket.Message_Type ;
   logmsg : Stream_Element_Array( 1..lm'Size/8 );
   for logmsg'Address use lm'Address ;
   logmsgsize : Stream_Element_Offset ;
   logfile : logging.file.FileDestinationPtr_Type ;

   function Time_Stamp (t : Ada.Calendar.Time ) return String is
   begin

      return Ada.Calendar.Formatting.Image (t , Time_Zone => Local_Time_Offset ) ;

   end Time_Stamp;

begin
   ProcessCommandLine ;

   GS.Create_Socket( s , 
                     mode => GS.Socket_Datagram ,
                     level => GS.IP_Protocol_For_UDP_Level);
   if cli.Verbosity > 1
   then
      Put("Starting logging service"); New_Line ;
   end if ;
   sa := GS.Network_Socket_Address( addr => GS.Inet_Addr("127.0.0.1") ,
                              port => GS.Port_Type(cli.port) );
   GS.bind_socket( s , sa );
   logfile := logging.file.Create(To_String(cli.logname),rotate => 60.0 );
   logging.SetDestination(logfile);
   loop
      GS.Receive_Socket( s , logmsg , logmsgsize , sender );
      if cli.Verbosity > 10
      then
         Put("Received a message from "); Put( GS.Image(sender)); New_Line;
      end if ;
      declare
         mimg : String := logging.Image( lm.mt(1..Integer(lm.ml)) ,
                                         lm.l ,
                                         lm.s , 
                                         lm.c );
         mprefix : String := GS.Image(sender) &
                             images.Image("> %06d : ",lm.seq ) ; 
      begin
         --Put_Line(mprefix);
         logging.file.SendMessage(logfile.all , mprefix , mimg );
      end ;
   end loop ;
end Dglogs;
