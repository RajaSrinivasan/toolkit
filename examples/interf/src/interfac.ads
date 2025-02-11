package interfac is
   type Command_Processor is interface ;
   function create return Command_Processor is abstract ;
   type list is new Command_Processor ;
   type read is new Command_Processor ;
end interfac ;