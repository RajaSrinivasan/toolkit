package p is

   type T1 is tagged 
   record
      field1 : Integer ;
   end record ;

   package s is
      type ST1 is tagged null record ;
   end s ;
end p;