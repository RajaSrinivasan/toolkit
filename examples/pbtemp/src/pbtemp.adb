with Interfaces.C ; use Interfaces.C ;
with Text_Io; use Text_Io ;
with System.Storage_Elements; use System.Storage_Elements;
with nanopblib ;
procedure Pbtemp is
   buffer : System.Storage_Elements.Storage_Array(1..512) ;
   buflen : System.Storage_Elements.Storage_Count ;

   Status : Int ;
   seq : aliased Int ;
   now : aliased C_Float ;
begin
   for i in 32000..32032
   loop
      Status := nanopblib.Set( buffer(buffer'first)'Address , Int( buffer'length ) , seq => Int(i) , now => C_Float(32032 - i)) ;
      if Status <= 0
      then
         Put_Line("Error packing");
         return ;
      end if ;
      Put("Packed length "); Put( Status'Image ); New_Line ;
      Status := nanopblib.Get( buffer(buffer'first)'Address , Status , seq , now );
      if Status < 0
      then
         Put_Line("Error unpacking");
         return ;
      end if ;
      Put("Seq " ); Put( Seq'Image ); Put(" Now "); Put( now'Image ); New_Line ;
   end loop ;

end Pbtemp;
