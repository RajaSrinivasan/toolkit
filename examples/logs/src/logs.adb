with logging;
with logging.file ;

with cstdout ;
with GNAT.Source_Info ;

procedure Logs is
   fdest : access logging.file.FileDestination_Type;
   procedure T1 is
      myname : constant String := gnat.Source_Info.Enclosing_Entity ;
      logfilename : constant String := myname & ".log" ;
   begin
      fdest := logging.file.Create(logfilename);
      logging.SetDestination(fdest);
      Logging.SendMessage("Message 1");
      Logging.SendMessage("Critical ",logging.CRITICAL);
      Logging.SendMessage("Error",logging.ERROR);
      logging.SendMessage("Warning",logging.WARNING);
   end T1;
   procedure T2 is
      myname : constant String := gnat.Source_Info.Enclosing_Entity ;
   begin
      logging.SetDestination(cstdout.handle'access);
      Logging.SendMessage("Message 1");
      Logging.SendMessage("Critical ",logging.CRITICAL);
      Logging.SendMessage("Error",logging.ERROR);
      logging.SendMessage("Warning",logging.WARNING);
   end T2 ;
begin
   T1;
   T2;
   --logging.SelfTest;
   Logging.SendMessage("Message 1");
   Logging.SendMessage("Critical ",logging.CRITICAL);
   Logging.SendMessage("Error",logging.ERROR);
   logging.SendMessage("Warning",logging.WARNING);
end Logs;
