with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Text_Io; use Ada.Text_Io;
with realtime ; use realtime ;

package body morsecode.signal is

    procedure Generate( C : character ; led : realtime.LED_Type'Class := simled ) is
        code : Letter_Representation := Translate(C);
    begin
        Put(c); New_Line;
        for a in code'Range
        loop
            case code(a) is
                when Dot => 
                        realtime.Set( led , true );
                        delay Span(dot);
                        About(led," ");
                        realtime.Set( led , false );
                        About(led," .");
                        delay Span(minigap);

                when Dash =>
                        realtime.Set( led , true );
                        delay Span(dash);
                        About(led," ");
                        realtime.Set( led , false );
                        About(led," -");
                        delay Span(minigap);
                when others => null ;
            end case;
        end loop ;
        delay Span(gap);
    end Generate ;

    procedure Generate( S : String ; led : realtime.LED_Type'Class := simled  ) is
    begin
        for c in S'Range
        loop
            Generate(s(c),led);
            delay Span(gap);
            New_Line;
        end loop ;
        delay Span(macrogap);
    end Generate ;

begin
    simled.name := To_Unbounded_String("Sim");
end morsecode.signal ;