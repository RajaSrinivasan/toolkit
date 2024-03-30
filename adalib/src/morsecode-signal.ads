with realtime ;
package Morsecode.signal is
    Pragma Elaborate_Body;
    simled : realtime.SimLED_Type ;

    procedure Generate( C : character ; led : realtime.LED_Type'Class := simled );
    procedure Generate( S : string ; led : realtime.LED_Type'Class := simled );

end morsecode.signal ;
