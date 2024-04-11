with Ada.Strings.Unbounded ; use Ada.Strings.Unbounded ;

package realtime is
    type LED_Type is interface ;
    procedure Set( led : LED_Type ; state : Boolean ) is abstract ;
    procedure About( led : realtime.LED_Type ; S : String ) is abstract ;

    type SimLED_Type is new LED_Type with
    record
        name : Unbounded_String := Null_Unbounded_String ;
    end record ;
    overriding
    procedure Set( led : SimLED_TYPE ; state : Boolean );
    overriding
   procedure About( led : SimLED_Type ; s : String );
   
   type acquire is access function ( h : Integer ) return Boolean ;
   
   type Button_Type is task interface ;
   procedure Monitor( b : Button_Type ; name : String ; cadence : duration ; handle : Integer ; acq : acquire) is null ;
   procedure Last( b : Button_Type ; last : out Boolean ) is null ; 
      
   task type SimButton_Type is new Button_Type with
      entry Monitor( name : String ; cadence : duration ; handle : Integer ; acq : acquire ) ;
      entry Last( last : out Boolean ) ; 
   end SimButton_Type;



   
end realtime ;
