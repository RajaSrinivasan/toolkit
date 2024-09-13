with Ada.Text_Io; use Ada.Text_Io;
with Ada.Float_Text_Io; use Ada.Float_Text_Io;

package body controls is


    procedure Cycle( c : in out PIDController ) is
        error : constant float := c.Setpoint - c.p.Value ;
        tweak : float ;
    begin
        tweak := error * (c.proportional + c.integral + c.derivative);
        c.p.Cycle(tweak); 
    end Cycle ;

   procedure Report( c : PIDController ) is
   begin
    Put(","); Put(c.p.Value); New_Line;
   end Report ;
 
end controls ;