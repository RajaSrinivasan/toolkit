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
    overriding
    procedure About( led : SimLED_Type ; s : String ) is
    begin
        Put( To_String(led.name) );
        Put( " ");
        Put(s);
        Flush ;
    end About ;

   task body SimButton_Type is
      laststate : boolean ;
   begin
      accept Monitor( name : String ; cadence : duration; handle : Integer ; acq : acquire ) do
         loop
            select
               accept Last( last : out Boolean ) do
                  last := laststate ;
               end Last ;
            or
               delay cadence ;
            end select ;
            laststate := acq.all (handle) ;
         end loop ;
      end Monitor ;
   end SimButton_Type;


end realtime ;
