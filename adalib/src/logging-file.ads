with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Calendar;          use Ada.Calendar;
package logging.file is

   type FileDestination_Type is new Destination_Type with record
      basename    : Unbounded_String := Null_Unbounded_String;
      basetype    : Unbounded_String := To_Unbounded_String (".log");
      filenumber  : Integer          := 0;
      cadence     : Duration;
      filestarted : Time;
      f           : access File_Type;
   end record;
   type FileDestinationPtr_Type is access all FileDestination_Type;

   function Create
     (name   : String; filetype : String := ".log"; number : Integer := 0;
      rotate : Duration := 0.0) return FileDestinationPtr_Type;

   overriding procedure SendMessage
     (dest   : in out FileDestination_Type; message : String;
      level  :        message_level_type := INFORMATIONAL;
      source :        String             := Default_Source_Name;
      class  :        String             := Default_Message_Class);

   procedure SendMessage
     (dest : in out FileDestination_Type; prefix : String; message : String);

   overriding procedure Close (dest : FileDestination_Type);

end logging.file;
