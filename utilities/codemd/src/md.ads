with Interfaces;
package md is
   type Markup is private;
   Bold : constant Markup;
   function Transform (t : String; m : Markup) return String;
private
   type Markup is new Interfaces.Unsigned_32;
   No_Markup : constant Markup := 0;
   Bold      : constant Markup := 16#00_00_00_01#;
end md;
