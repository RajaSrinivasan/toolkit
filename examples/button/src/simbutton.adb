package body simbutton is
    state : boolean := false ;
    function acquire( handle : Integer ) return boolean is
    begin
        if state
        then
            state := false ;
        else
            state := true ;
        end if;
        return state ;
    end acquire ;
end simbutton;