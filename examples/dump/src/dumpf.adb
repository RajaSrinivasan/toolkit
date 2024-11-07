-- codemd: begin segment=DumpFile caption=Utility to dump a file
with Ada.Command_Line; use Ada.Command_Line ;
with hex.dump ;
procedure Dumpf is
begin
   hex.dump.Dump( Argument(1) );
end Dumpf ;
-- codemd: end
