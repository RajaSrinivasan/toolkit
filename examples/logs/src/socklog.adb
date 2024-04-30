with logging;
with logging.socket ;
with GNAT.Source_Info ;

procedure Logs is

   procedure T1 is
      myname : constant String := gnat.Source_Info.Enclosing_Entity ;
      logsock : aliased logging.socket.SocketDestinationPtr_Type ;
   begin
      logsock := logging.socket.Create( 1056 , "127.0.0.1");
      logging.SetDestination(logsock);
      for i in 1..10
      loop
         Logging.SendMessage("Message 1");
         Logging.SendMessage("Critical ",logging.CRITICAL);
         Logging.SendMessage("Error",logging.ERROR);
         logging.SendMessage("Warning",logging.WARNING);
         delay 2.0;
      end loop ;
   end T1;

begin
   T1;
end Logs;
