with logging;
with logging.file;

with cstdout;
with GNAT.Source_Info;

procedure Logs is
   fdest : access logging.file.FileDestination_Type;
   procedure T1 is
      myname      : constant String := GNAT.Source_Info.Enclosing_Entity;
      logfilename : constant String := myname;
   begin
      fdest := logging.file.Create (logfilename, rotate => 5.0);
      logging.SetDestination (fdest);
      for i in 1 .. 10 loop
         Logging.SendMessage ("Message 1");
         Logging.SendMessage ("Critical ", logging.CRITICAL);
         Logging.SendMessage ("Error", logging.ERROR);
         logging.SendMessage ("Warning", logging.WARNING);
         delay 2.0;
      end loop;

   end T1;
   procedure T2 is
      myname : constant String := GNAT.Source_Info.Enclosing_Entity;
   begin
      logging.SetDestination (cstdout.handle'Access);
      Logging.SendMessage ("Message 1");
      Logging.SendMessage ("Critical ", logging.CRITICAL);
      Logging.SendMessage ("Error", logging.ERROR);
      logging.SendMessage ("Warning", logging.WARNING);
   end T2;
begin

   T2;
   --logging.SelfTest;
   Logging.SendMessage ("Message 1");
   Logging.SendMessage ("Critical ", logging.CRITICAL);
   Logging.SendMessage ("Error", logging.ERROR);
   logging.SendMessage ("Warning", logging.WARNING);
   T1;
end Logs;
