with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package realtime is
   type LED_Type is interface;
   procedure Set (led : LED_Type; state : Boolean) is abstract;
   procedure About (led : realtime.LED_Type; S : String) is abstract;

   type SimLED_Type is new LED_Type with record
      name : Unbounded_String := Null_Unbounded_String;
   end record;
   overriding procedure Set (led : SimLED_Type; state : Boolean);
   overriding procedure About (led : SimLED_Type; s : String);

   type acquire is access function (h : Integer) return Boolean;
   type statechange is access procedure (h : Integer; newstate : Boolean);

   task type Button_Type is
      entry Monitor
        (name : String; cadence : Duration; handle : Integer;
         acq  : not null acquire; st : not null statechange);
      entry Last (last : out Boolean);
   end Button_Type;
   type Button_Ptr_Type is access Button_Type;

end realtime;
