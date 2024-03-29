with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with realtime ; use realtime ;

package body morsecode.signal is
    simled : SimLED_Type ;
    procedure Generate( C : character ) is
        code : Letter_Representation := Translate(C);
    begin
        for a in code'Range
        loop
            case code(a) is
                when Dot => 
                        realtime.Set( simled , true );
                        delay Span(dot);
                        realtime.Set( simled , false );
                        delay Span(minigap);
                when Dash =>
                        realtime.Set( simled , true );
                        delay Span(dash);
                        realtime.Set( simled , false );
                        delay Span(minigap);
                when others => null ;
            end case;
        end loop ;
        delay Span(gap);
    end Generate ;

    procedure Generate( S : string ) is
    begin
        for c in S'Range
        loop
            Generate(s(c));
            delay Span(gap);
        end loop ;
        delay Span(macrogap);
    end Generate ;

begin
    simled.name := To_Unbounded_String("Sim");
end morsecode.signal ;