with Ada.Text_Io; use Ada.Text_Io;
with critical_float ;
with cvars ;

procedure Cvar is
begin
   critical_float.Set(cvars.var1, 1.0) ;
   critical_float.Set(cvars.var2, 2.0) ;
   Put(critical_float.Get(cvars.var1)'Image); Put(" ");
   Put(critical_float.Get(cvars.var2)'Image); New_Line ;
end Cvar;
