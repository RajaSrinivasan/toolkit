package logging is

   subtype message_level_type is Natural;

   CRITICAL      : constant message_level_type := 10;
   ERROR         : constant message_level_type := 20;
   WARNING       : constant message_level_type := 30;
   INFORMATIONAL : constant message_level_type := 40;
   function Image (level : message_level_type) return String;

   subtype Source_Name_Type is String(1..6) ;
   Default_Source_Name : Source_Name_Type := (others => '.');

   subtype Message_Class_Type is String (1 .. 6);
   Default_Message_Class : Message_Class_Type := (others => '.');

   function Time_Stamp return String;
 
   procedure SendMessage
     ( message : String ;
       level : message_level_type := INFORMATIONAL;
       source : String := Default_Source_Name ;
       class : String := Default_Message_Class );
   
   function Image
        ( message : String ;
          level : message_level_type := INFORMATIONAL;
          source : String := Default_Source_Name ;
          class : String := Default_Message_Class ) return String ;
   
  type Destination_Type is abstract tagged record
      null ;
   end record;
   procedure SetDestination (destination : access Destination_Type'Class);
   procedure SendMessage
     ( dest : in out Destination_Type ;
       message : String  ;
       level : message_level_type := INFORMATIONAL;
       source : String := Default_Source_Name ;
       class : String := Default_Message_Class ) is abstract ;
   procedure Close(desg : Destination_Type) is abstract ;
   
   type StdOutDestination_Type is new Destination_Type with record
      null;
   end record;

  overriding
  procedure SendMessage
     ( dest : in out StdOutDestination_Type ;
       message : String ;
       level : message_level_type := INFORMATIONAL ;
       source : String := Default_Source_Name ;
       class : String := Default_Message_Class ) ;
   overriding
   procedure Close(desg : StdOutDestination_Type) ;
   
   procedure SelfTest;

private
   Current_Destination : access Destination_Type'Class ;


end logging;
