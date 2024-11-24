with Ada.Text_IO; use Ada.Text_IO;

with cli;
with impl;
procedure Frep is
   verbose : Boolean := True;
begin
   -- codemd: begin segment=Overall caption=Overall processing
   cli.ProcessCommandLine;
   loop
      declare
         arg : constant String := cli.GetNextArgument;
      begin
         if arg'Length < 1 then
            exit;
         end if;
         -- codemd: skipbegin
         if cli.Candidate.all'Length >= 1 then
            null; -- impl.Search (arg, cli.Candidate.all);
         elsif cli.CandidateExp.all'Length >= 1 then
            null;
         else
            Put ("Need a candidate or an expression to search for");
            New_Line;
            return;
         end if;
         -- codemd: skipend
         if cli.Replacement.all'Length >= 1 then
            if cli.Candidate.all'Length >= 1 then
               impl.Replace
                 (arg, cli.Candidate.all, cli.Replacement.all,
                  cli.outputdir.all);
            elsif cli.CandidateExp.all'Length >= 1 then
               impl.ReplaceRegEx
                 (arg, cli.CandidateExp.all, cli.Replacement.all,
                  cli.outputdir.all);
            end if;
         else
            if cli.Candidate.all'Length >= 1 then
               impl.Search (arg, cli.Candidate.all);
            elsif cli.CandidateExp.all'Length >= 1 then
               impl.SearchRegEx (arg, cli.CandidateExp.all);
            end if;
         end if;
      end;
   end loop;
   -- codemd: end

   -- codemd: begin segment=Exception caption=Exception handling
   exception
      when others =>
         Put_Line("Exiting ...");
   -- codemd: end
end Frep;
