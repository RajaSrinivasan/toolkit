with System ;
with Interfaces.C ; use Interfaces.C ;
package nanopblib is
   function Set(buffer : System.Address ;
                buflen : Int ;
                seq : Int ;
                now : Int )
            return Int ;
   pragma Import(C,Set,"set");

   function Get( buffer : System.address ;
                 buflen : Int ;
                 seq : out int ;
                 now : out int )
   return Int ;
   pragma Import(C,Get,"get");
end nanopblib ;