package ut.assertions is

   procedure Assert is new ut.Assert( Integer ) ;
   procedure Assert_GT is new ut.Assert( Integer , ">" );
   procedure Assert_GE is new ut.Assert( Integer , ">=" );
   procedure Assert_LT is new ut.Assert( Integer , "<" );
   procedure Assert_LE is new ut.Assert( Integer , "<=" );
   procedure Assert_NE is new ut.Assert( Integer , "/=" );


   procedure Assert is new ut.Assert( Float , Compare ) ;
   procedure Assert_GT is new ut.Assert( Float , ">" );
   procedure Assert_GE is new ut.Assert( Float , ">=" );
   procedure Assert_LT is new ut.Assert( Float , "<" );
   procedure Assert_LE is new ut.Assert( Float , "<=" );
   procedure Assert_NE is new ut.Assert( Float , "/=" );

end ut.assertions ;