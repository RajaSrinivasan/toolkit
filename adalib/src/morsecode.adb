
package body MorseCode is
    use Ada.Strings.Unbounded ;
    function unb(s : String) return Unbounded_String renames To_Unbounded_String ;
    function Str(s : Unbounded_String) return String renames To_String ;
    function Code( c : Character ) return String is
    begin
        return Str( fullcode(c) );
    end Code ;
begin
    fullcode('A') := Unb(".-");
end MorseCode ;