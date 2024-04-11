with Ada.Text_Io; use Ada.Text_Io;
package body simbutton is
    state : boolean := false ;
    function acquire( handle : Integer ) return boolean is
    begin
        Put_Line("State is " & state'Image);
        return state ;
    end acquire ;
    task noise ;
    task body noise is
    begin
    	loop
    	    delay 4.0 ;
    	    if state then state := false ; else state := true ; end if ;
    	end loop ;
    end noise ;    
    procedure changed( handle : integer ; newstate : boolean ) is
    begin
        Put("Changed "); Put_Line(newstate'Image);
    end changed ;
end simbutton;
