with realtime;
package Morsecode.signal is
   pragma Elaborate_Body;
   simled : realtime.SimLED_Type;

   procedure Generate (C : Character; led : realtime.LED_Type'Class := simled);
   procedure Generate (S : String; led : realtime.LED_Type'Class := simled);

end Morsecode.signal;
