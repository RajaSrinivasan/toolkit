with Ada.Command_Line; use Ada.Command_Line ;
with hex.dump.file ;
procedure Dump is
begin
   hex.dump.file.Dump( Argument(1) );
end Dump;
