with Ada.Command_Line ; use Ada.Command_Line ;
with morsecode.signal ;
procedure Morse is
   word : constant String := Argument(1);
begin
   morsecode.signal.Generate(word);
end Morse;
