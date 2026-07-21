with Interfaces.C ; use Interfaces.C ;
with nanopblib ;
procedure Pbtemp is
   buffer : Integer ;
   Status : Int ;
begin
   Status := nanopblib.Set( buffer'Address , buffer'Size/8 , 1 , 1 );
end Pbtemp;
