pragma Ada_2020;

package body fifo is

   function Create( cap : Integer := 64 ) return Buffer_Type is
   	result : Buffer_Type(cap);
   begin
   	return result ;
   end Create ;

   procedure Push( buf : in out Buffer_Type; item : Item_Type ) is
   begin

      if Full(buf)
      then
         raise Overflow_Error ;
      end if ;

      buf.Contents(buf.push_to) := item ;
      buf.count := @ + 1 ;
      if buf.pull_from < buf.Contents'First
      then
         buf.pull_from := buf.push_to ;
      end if ;

      if buf.push_to = buf.Contents'last
      then
         buf.push_to := buf.Contents'First ;
      else
         buf.push_to := @ + 1 ;
      end if ;

   end Push ;

   procedure Get( buf : in out Buffer_Type; item : out Item_Type ) is
   begin

      if Empty(buf)
      then
         raise Empty_Error ;
      end if ;

      item := buf.Contents( buf.pull_from );
      buf.count := @ - 1 ;
      if buf.pull_from = buf.contents'Last
      then
         buf.pull_from := buf.Contents'First ;
      else
         buf.pull_from := @ + 1;
      end if ;

   end Get ;

   function Empty( buf : Buffer_Type ) return Boolean is
   begin
      return buf.count = 0 ;
   end Empty ;

   function Full( buf : Buffer_Type ) return Boolean is
   begin
      return buf.count = buf.Contents'Last ;
   end Full ;


end fifo ;
