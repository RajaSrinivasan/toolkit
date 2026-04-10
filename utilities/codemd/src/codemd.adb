with Ada.Text_IO; use Ada.Text_IO;
with GNAT.Command_Line;

with cli;
with impl;

procedure Codemd is
begin
   cli.ProcessCommandLine;

   if cli.Exec.all'Length >= 1 then
      pragma Debug (Put_Line ("Executing " & cli.exec.all));
      impl.Execute (cli.Exec.all, cli.lineno_from, cli.linecount);
      return;
   end if;

   loop
      declare
         inpfile : constant String := cli.GetNextArgument;
      begin
         if inpfile'Length < 1 then
            pragma Debug (Put_Line ("Please provide an input file"));            
            return;
         end if ;
         Put_Line ("Processing file " & inpfile);
         if cli.extractSection.all'Length > 1 then
            impl.Extract
               (inpfile, cli.extractSection.all, caption => cli.caption);
         else
            if cli.lineno_from > 0 then
               impl.Extract
                  (inpfile, cli.lineno_from, cli.linecount, cli.caption);
            else
               impl.Extract (inpfile, caption => cli.caption);
            end if;
         end if;
      end;
   end loop ;
exception
   when GNAT.Command_Line.Exit_From_Command_Line =>
      null;
end Codemd;
