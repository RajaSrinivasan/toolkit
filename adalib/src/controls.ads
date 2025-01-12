-- Good practical intro
-- https://www.youtube.com/watch?v=tFVAaUcOm4I
--
package controls is

   type Plant is abstract tagged record
      Value : Float := 0.0;
   end record;

   procedure Cycle (p : in out Plant; input : Float) is abstract;

   type Controller is abstract tagged record
      p        : access Plant'Class;
      Setpoint : Float := 0.0;
   end record;

   procedure Cycle (c : in out Controller) is abstract;
   procedure Report (c : Controller) is abstract;

   type PIDController is new Controller with record
      proportional : Float := 0.0;
      integral     : Float := 0.0;
      derivative   : Float := 0.0;
   end record;
   procedure Cycle (c : in out PIDController);
   procedure Report (c : PIDController);

end controls;
