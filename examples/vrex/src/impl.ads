package impl is
    function Matches( pattern : String ; line : String ;
                      glob : boolean := false ; caseinsensitive : boolean := false ) 
                      return boolean ;
    procedure Matches( pattern : String ; filename : String ;
                      glob : boolean := false ; caseinsensitive : boolean := false);
end impl ;