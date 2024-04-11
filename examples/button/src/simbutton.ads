package simbutton is
    function acquire( handle : integer ) return boolean ;
    procedure changed( handle : integer ; newstate : boolean );
end simbutton ;
