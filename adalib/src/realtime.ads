with Ada.Strings.Unbounded ; use Ada.Strings.Unbounded ;

package realtime is
    type LED_Type is interface ;
    procedure Set( led : LED_Type ; state : Boolean ) is abstract ;

    type SimLED_Type is new LED_Type with
    record
        name : Unbounded_String := Null_Unbounded_String ;
    end record ;
    overriding
    procedure Set( led : SimLED_TYPE ; state : Boolean );

end realtime ;