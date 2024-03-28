with Ada.Strings.Unbounded ;

package MorseCode is
    pragma Elaborate_Body;
    type basic is
    (
        dot ,           -- Dot
        dash ,          -- Dash
        gap ,           -- Intra Letter space
        lspace ,        -- Letter space
        wspace          -- Word space
    );

    type CodeType is array (character) of 
              Ada.Strings.Unbounded.Unbounded_String ;
    function Code( c : Character ) return String ;
private
    fullcode : CodeType ;
end MorseCode ;
