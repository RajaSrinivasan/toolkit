with Ada.Text_Io; use Ada.Text_Io;
with realtime ;
with simbutton ;
procedure Button is
   mybutton : realtime.Button_Type ;
   state : boolean ;
begin
   mybutton.Monitor("mybutton" , 0.2 , 0 , simbutton.acquire'Access);
   Put_Line("Created my button and started monitoring");
   loop
      mybutton.Last( state );
      Put_Line(state'Image);
      delay 3.0 ;
   end loop ;
end Button;
