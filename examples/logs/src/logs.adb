with logging;
with logging.file ;

with cstdout ;
with GNAT.Source_Info ;

procedure Logs is
   fdest : aliased logging.file.FileDestination_Type;
   procedure T1 is
      myname : constant String := gnat.Source_Info.Enclosing_Entity ;
      logfilename : constant String := myname & ".log" ;
   begin
      fdest := logging.file.Create(logfilename);
      logging.SetDestination(fdest'Access);
      Logging.SendMessage("Message 1");
      Logging.SendMessage("Critical ",logging.CRITICAL);
      Logging.SendMessage("Error",logging.ERROR);
      logging.SendMessage("Warning",logging.WARNING);
   end T1;
begin
   logging.SelfTest;
   Logging.SendMessage("Message 1");
   Logging.SendMessage("Critical ",logging.CRITICAL);
   Logging.SendMessage("Error",logging.ERROR);
   logging.SendMessage("Warning",logging.WARNING);
   T1;
end Logs;
