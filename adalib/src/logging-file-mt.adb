package body logging.file.mt is

   protected body MTFileDestination is
      procedure Create
        (name   : String; filetype : String := ".log"; number : Integer := 0;
         rotate : Duration := 0.0)
      is
      begin
         if fdest = null then
            fdest := Create (name, filetype, number, rotate);
            SetDestination (fdest);
         end if;
      end Create;

      procedure SendMessage
        (message : String; level : message_level_type := INFORMATIONAL;
         source  : String := Default_Source_Name;
         class   : String := Default_Message_Class)
      is
      begin
         fdest.SendMessage (message, level, source, class);
      end SendMessage;

   end MTFileDestination;

end logging.file.mt;
