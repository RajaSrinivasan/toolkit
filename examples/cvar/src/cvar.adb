with Ada.Text_Io; use Ada.Text_Io;
--codemd: begin segment=Application caption=Application
with critical_float ;
with cvars ;

procedure Cvar is
begin
   critical_float.Set(cvars.tempSetpoint, 98.0) ;
   critical_float.Set(cvars.pressureSetpoint, 20.0) ;
   Put(critical_float.Get(cvars.tempSetpoint)'Image); Put(" ");
   Put(critical_float.Get(cvars.pressureSetpoint)'Image); New_Line ;
end Cvar;
--codemd: end

