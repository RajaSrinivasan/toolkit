with Ada.Text_Io; use Ada.Text_Io;
with controls ;
with car;
with GNAT.Source_Info ;
procedure Pid is

   procedure T1 is
      myname : constant String := gnat.Source_Info.enclosing_entity ;
      c : controls.PIDController ;
   begin
      Put_Line(myname);
      c.p := new Car.Car_T;
      c.Setpoint := 100.0 ;
      c.proportional := 0.2;
      c.integral := 0.5;
      c.derivative := 0.5;
      for i in 1..16
      loop
         c.Cycle;
         c.Report;
      end loop ;
   end T1;

begin
   T1 ;
end Pid;
