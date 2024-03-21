with Ada.Text_IO;               use Ada.Text_IO;
with Ada.Short_Integer_Text_IO; use Ada.Short_Integer_Text_IO;
with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;
with Ada.Containers.Vectors;
with Ada.Text_IO.Text_Streams;  use Ada.Text_IO.Text_Streams;
with Ada.Strings.Fixed;
with Ada.Strings.Maps;
with Ada.Directories;

with Ada.Streams;             use Ada.Streams;
with Ada.Calendar;            use Ada.Calendar;
with Ada.Calendar.Formatting; use Ada.Calendar.Formatting;

with GNAT.Time_Stamp;

with Hex;

package body logging is

  function Image (level : message_level_type) return String is
   begin
      case level is
         when CRITICAL =>
            return "[C]";
         when ERROR =>
            return "[E]";
         when WARNING =>
            return "[W]";
         when INFORMATIONAL =>
            return "[I]";
         when others =>
            return "[" & message_level_type'Image (level) & "]";
      end case;
   end Image;

   function Time_Stamp return String is
      ts : Unbounded_String :=
        To_Unbounded_String (GNAT.Time_Stamp.Current_Time);
      pos       : Natural := 0;
      removeset : Ada.Strings.Maps.Character_Set;
   begin
      removeset := Ada.Strings.Maps.To_Set ("-:. ");
      loop
         pos := Ada.Strings.Unbounded.Index (ts, removeset);
         if pos = 0 then
            exit;
         end if;
         Ada.Strings.Unbounded.Delete (ts, pos, pos);
      end loop;
      return To_String (ts);
   end Time_Stamp;

   procedure SetDestination (destination : access Destination_Type'Class) is
   begin
      Current_Destination := destination;
   end SetDestination;

   procedure SendMessage
     ( message : String ;
       source : String := Default_Source_Name ;
       class : String := Default_Message_Class ) is
   begin
      SendMessage(Current_Destination.all,message,source,class);
   end SendMessage;

  procedure SendMessage
     ( dest : StdOutDestination_Type ;
       message : String ;
       source : String := Default_Source_Name ;
       class : String := Default_Message_Class ) is
   begin
      Put(message);
      New_Line;
   end SendMessage;


   procedure SelfTest is
   begin
      for i in 1 .. 10 loop
         SendMessage (Ada.Calendar.Formatting.Image (Ada.Calendar.Clock));
         delay 0.5;
      end loop;
   end SelfTest;
begin
   Current_Destination := new StdOutDestination_Type ;
end logging;
