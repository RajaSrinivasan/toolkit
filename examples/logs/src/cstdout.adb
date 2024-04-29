with Ada.Text_Io; use Ada.Text_Io;
with Ada.Calendar; 
with Ada.Calendar.Formatting;
with AnsiAda ;

package body cstdout is
use logging;
  overriding
  procedure SendMessage
     ( dest : in out cStdOutDestinationType ;
       message : String ;
       level : message_level_type := INFORMATIONAL ;
       source : String := Default_Source_Name ;
       class : String := Default_Message_Class ) is
   begin
      --Put(Ada.Calendar.Formatting.Image (Ada.Calendar.Clock)); Put(" ");
      Put(logging.Time_Stamp); Put(" ");
      Put(source); Put(" ");
      Put(class); Put(" ");
      Put(Image(level)); Put(" ");
      case level is
        when CRITICAL => Put(AnsiAda.Color_Wrap(message,foreground=>ansiada.Foreground(ansiada.Red)));
        when ERROR => Put(AnsiAda.Color_Wrap(message,foreground=>ansiada.Foreground(ansiada.Cyan)));
        when WARNING => Put(AnsiAda.Color_Wrap(message,foreground=>ansiada.Foreground(ansiada.Yellow)));
        when INFORMATIONAL => Put(AnsiAda.Color_Wrap(message,foreground=>ansiada.Foreground(ansiada.Grey)));
        when others => Put(message);
      end case ;
      New_Line;
   end SendMessage;

    overriding
    procedure Close(dest : cStdoutDestinationType) is
    begin
        null ;
    end Close ;

end cstdout;
