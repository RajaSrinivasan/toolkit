with Ada.Text_IO; use Ada.Text_IO;

package body realtime is

   overriding procedure Set (led : SimLED_Type; state : Boolean) is
   begin
      Put (To_String (led.name));
      Put (" : ");
      if state then
         Put ("On");
      else
         Put ("Off");
      end if;
   end Set;
   overriding procedure About (led : SimLED_Type; s : String) is
   begin
      Put (To_String (led.name));
      Put (" ");
      Put (s);
      Flush;
   end About;

   task body Button_Type is
      laststate : Boolean;
      d         : Duration;
      h         : Integer;
      a         : acquire;
      s         : statechange;
      me        : Unbounded_String;
   begin
      accept Monitor
        (name : String; cadence : Duration; handle : Integer;
         acq  : not null acquire; st : not null statechange)
      do
         d         := cadence;
         h         := handle;
         a         := acq;
         s         := st;
         me        := To_Unbounded_String (name);
         laststate := a.all (h);
      end Monitor;
      Put ("Started monitoring button ");
      Put_Line (To_String (me));
      loop
         select
            accept Last (last : out Boolean) do
               last := laststate;
            end Last;
         or
            delay d;
         end select;
         if laststate /= a.all (h) then
            laststate := not laststate;
            s.all (h, laststate);
         end if;
      end loop;
   end Button_Type;

end realtime;
