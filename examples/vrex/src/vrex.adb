with Ada.Text_Io; use Ada.Text_Io;
with cli ;
with impl ;
procedure Vrex is
begin
   cli.ProcessCommandLine ;
   declare
      p : constant String := cli.GetNextArgument ;
   begin
      if cli.filesOption
      then
         loop
            declare
               f : constant String := cli.GetNextArgument ;
            begin
               if f'Length < 1
               then
                  exit ;
               end if;
               impl.Matches( p , f , cli.globOption , cli.caseInsensitiveOption );
            end ;
         end loop ;
      else
         if impl.Matches( p , cli.GetNextArgument , cli.globOption , cli.caseInsensitiveOption )
         then
            Put_Line("Matches");
         else
            Put_Line("Does not match");
         end if ;
      end if ;
   end ;
exception
   when others => return ;
end Vrex;
