with Ada.Containers.Vectors ;

package fields is
    subtype Capacity is Integer range 1..1024 ;
    package IntFieldsPkg is new 
            Ada.Containers.Vectors (Capacity , Integer );
    function Split( full : String ;
                    separator : String := "," ;
                    fmt : String := "" )
                    return IntFieldsPkg.Vector ;

end fields ;