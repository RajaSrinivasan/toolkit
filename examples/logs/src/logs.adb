with Ada.Command_Line; use Ada.Command_Line ;
with logging;
with logging.file;

with cstdout;
with GNAT.Source_Info;

procedure Logs is
   -- codemd: begin segment=FileDest caption=File Destination
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
   -- codemd: end
   
   -- codemd: begin segment=Simple caption=Default basic usage
   procedure T2 (argc : integer) is
      myname : constant String := GNAT.Source_Info.Enclosing_Entity;
   begin
      if argc = 0
      then 
         logging.SetDestination (cstdout.handle'Access);
      end if ;
      Logging.SendMessage ("Message 1");
      Logging.SendMessage ("Critical ", logging.CRITICAL);
      Logging.SendMessage ("Error", logging.ERROR);
      logging.SendMessage ("Warning", logging.WARNING);
   end T2;
   -- codemd: end
begin
   if Argument_Count > 0
   then
      T2 (Argument_Count);
      return ;
   end if ;
   T2(0);
   --logging.SelfTest;
   Logging.SendMessage ("Message 1");
   Logging.SendMessage ("Critical ", logging.CRITICAL);
   Logging.SendMessage ("Error", logging.ERROR);
   logging.SendMessage ("Warning", logging.WARNING);
   T1;
end Logs;
