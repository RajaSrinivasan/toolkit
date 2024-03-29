with Ada.Text_Io; use Ada.Text_Io;

package body realtime is
    overriding
    procedure Set( led : SimLED_TYPE ; state : Boolean ) is
    begin
        Put( To_String(led.name) );
        Put( " : ");
        if state
        then
            Put("On");
        else
            Put("Off");
        end if ;
    end Set ;

end realtime ;
