with Ada.Text_IO;       use Ada.Text_IO;
with Ada.Float_Text_IO; use Ada.Float_Text_IO;

package body controls is

   procedure Cycle (c : in out PIDController) is
      error : constant Float := c.Setpoint - c.p.Value;
      tweak : Float;
   begin
      tweak := error * (c.proportional + c.integral + c.derivative);
      c.p.Cycle (tweak);
   end Cycle;

   procedure Report (c : PIDController) is
   begin
      Put (",");
      Put (c.p.Value);
      New_Line;
   end Report;

end controls;
