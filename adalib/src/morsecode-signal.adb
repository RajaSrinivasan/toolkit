with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Text_IO;           use Ada.Text_IO;
with realtime;              use realtime;

package body Morsecode.signal is

   procedure Generate (C : Character; led : realtime.LED_Type'Class := simled)
   is
      code : Letter_Representation := Translate (C);
   begin
      Put (C);
      New_Line;
      for a in code'Range loop
         case code (a) is
            when Dot =>
               realtime.Set (led, True);
               delay Span (Dot);
               About (led, " ");
               realtime.Set (led, False);
               About (led, " .");
               delay Span (minigap);

            when Dash =>
               realtime.Set (led, True);
               delay Span (Dash);
               About (led, " ");
               realtime.Set (led, False);
               About (led, " -");
               delay Span (minigap);
            when others =>
               null;
         end case;
      end loop;
      delay Span (gap);
   end Generate;

   procedure Generate (S : String; led : realtime.LED_Type'Class := simled) is
   begin
      for c in S'Range loop
         Generate (S (c), led);
         delay Span (gap);
         New_Line;
      end loop;
      delay Span (macrogap);
   end Generate;

begin
   simled.name := To_Unbounded_String ("Sim");
end Morsecode.signal;
