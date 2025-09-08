with logging ;

package body ut is

   procedure Trace( entity : String := SI.Enclosing_Entity; 
                    loc : String := SI.Source_Location ) is
   begin
      logging.SendMessage( message => "Trace" ,
                           source => loc ,
                           class => entity );
   end Trace ;


  procedure Assert( expect , actual : T ;
                     explain : String := "" ;
                     entity : String := SI.Enclosing_Entity;
                     loc : String := SI.Source_Location ) is
   begin
      if Compare( expect , actual )
      then
         logging.SendMessage( message => "Success " & explain ,
                              level => logging.INFORMATIONAL ,
                              source => loc ,
                              class => entity );
      else
         logging.SendMessage( message => "Failed " & explain ,
                              level => logging.ERROR ,
                              source => loc ,
                              class => entity );
      end if ;
   end Assert ;


   function Compare ( left, right : Float  ) 
                  return boolean is
   begin
      if abs( left - right ) <= epsilon
      then
         return true ;
      end if ;
      return false ;
   end Compare ;
end ut ;