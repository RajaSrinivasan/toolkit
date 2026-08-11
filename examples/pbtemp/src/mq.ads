with System.Storage_Elements ;
package mq is
   protected type Queue is
      Entry Enqueue (buffer : System.Storage_Elements.Storage_Array) ;
      Entry Dequeue (outbuf : out System.Storage_Elements.Storage_Array) ;
      function Is_Empty return Boolean;
   private
      Storage : System.Storage_Elements.Storage_Array(1..1024) ;
      StoredLength : System.Storage_Elements.Storage_Count := 0 ;
   end Queue ;
end mq ;