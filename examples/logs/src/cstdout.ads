with logging ;
package cstdout is
    type cStdoutDestinationType is new logging.Destination_Type with
    null record;


    overriding
    procedure SendMessage
     ( dest : in out cStdOutDestinationType ;
       message : String ;
       level : logging.message_level_type := logging.INFORMATIONAL ;
       source : String := logging.Default_Source_Name ;
       class : String := logging.Default_Message_Class ) ;

    overriding
    procedure Close(dest : cStdoutDestinationType);
    
    handle : aliased cStdoutDestinationType ;

end cstdout ;
