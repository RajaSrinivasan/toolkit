with Ada.Command_Line; use Ada.Command_Line ;
with hex.dump ;
procedure Dump is
begin
   hex.dump.Dump( Argument(1)'Address , Argument(1)'Length );
end Dump;
