with logging;
with cstdout ;
procedure Logs is
begin
   logging.SelfTest;
   Logging.SendMessage("Message 1");
   Logging.SendMessage("Critical ",logging.CRITICAL);
   Logging.SendMessage("Error",logging.ERROR);
   logging.SendMessage("Warning",logging.WARNING);
end Logs;
