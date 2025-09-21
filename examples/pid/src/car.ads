with controls;
package car is
   type Car_T is new controls.Plant with null record;
   procedure Cycle( p : in out Car_T ;
                     input : float ) ;
end car ;