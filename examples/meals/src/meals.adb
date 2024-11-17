with Ada.Command_Line;    use Ada.Command_Line;
with Ada.Text_IO;         use Ada.Text_IO;

with GNAT.Source_Info; use GNAT.Source_Info;

with foods;

procedure meals is
   verbose : Boolean := True;
   pgm     : constant String  := GNAT.Source_Info.Enclosing_Entity;
   meal : foods.Meal_Type ;
begin
   if verbose
   then
      Put_Line (pgm);
   end if ;
   if Argument_Count < 1
   then
      Put_Line("usage: meals mealfilename [foodsdb=foods.csv]");
      return ;
   end if ;
   meal := foods.Load( Argument(1) );
   if verbose
   then
      Put_Line("The meal is");
      foods.Show(meal);
   end if ;
end meals;
