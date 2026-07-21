with System ;
with Interfaces.C ; use Interfaces.C ;
package nanopblib is
   function Set(buffer : System.Address ;
                buflen : Int ;
                seq : Int ;
                now : Int )
            return Int ;
   pragma Import(C,Set,"set");

end nanopblib ;