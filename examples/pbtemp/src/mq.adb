with System.Storage_Elements; use System.Storage_Elements;
package body mq is
   protected body Queue is
      Entry Enqueue (buffer : System.Storage_Elements.Storage_Array) 
         when StoredLength = 0 
      is
      begin
         if buffer'Length > Storage'Length then
            raise Constraint_Error with "Queue overflow";
         end if;
         Storage(1 .. buffer'Length) := buffer;
         StoredLength := buffer'Length;
      end Enqueue;
      Entry Dequeue (outbuf : out System.Storage_Elements.Storage_Array) 
         when StoredLength > 0
      is
      begin
         if StoredLength > outbuf'Length then
            raise Constraint_Error with "Buffer overflow";
         end if;
         outbuf (1..StoredLength) := Storage(1..StoredLength);
      end Dequeue;

      function Is_Empty return Boolean is
      begin
         return StoredLength = 0 ;
      end Is_Empty;
   end Queue ;
end mq ;