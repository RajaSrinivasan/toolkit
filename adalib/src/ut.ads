with Ada.Finalization ;
with GNAT.Source_Info ; 
with GNAT.Strings ;

package ut is

   package SI renames GNAT.Source_Info ;
   procedure Trace( entity : String := SI.Enclosing_Entity; 
                    loc : String := SI.Source_Location );

   type Group is new Ada.Finalization.Controlled with
   record
      name : GNAT.Strings.String_Access ;
      successcount : Natural := 0;
      failedcount : Natural := 0 ;
   end record ;

   generic
      type T is private ;
      with function Compare( left, right: T) return boolean is "=" ;
   procedure Assert( expect , actual : T ;
                     explain : String := "" ;
                     entity : String := SI.Enclosing_Entity;
                     loc : String := SI.Source_Location );

   epsilon : Float := 0.1e-6;
   function Compare ( left, right : Float ) 
                  return boolean ;

end ut ;