with Ada.Text_Io; use Ada.Text_Io;

package body realtime is
    use Ada.Strings.Unbounded ;
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
    overriding
    procedure About( led : SimLED_Type ; s : String ) is
    begin
        Put( To_String(led.name) );
        Put( " ");
        Put(s);
        Flush ;
    end About ;

end realtime ;
