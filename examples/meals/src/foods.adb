with Ada.Text_Io; use Ada.Text_Io;
with CSV;
package body foods is

   function Load
     (gi : Glycemic_Index; cs : CarbohydratesPerServing) return Glycemic_Load
   is
   begin
      return Glycemic_Load'Last;
   end Load;

   function Load (filename : String) return FoodsDatabase_Type is
      result : FoodsDatabase_Pkg.Vector;
   begin
      return FoodsDatabase_Type(result) ;
   end Load;

   procedure Show( db : FoodsDatabase_Type ) is
      vector : FoodsDatabase_Pkg.Vector := FoodsDatabase_Pkg.Vector(db);
   begin
      null ;
   end Show ;

   function Load( mfn : String ) return Meal_Type is
      use Ada.Strings.Unbounded ;
      result : Meal_TYpe ;
      mealfile : csv.File_Type ;
      dish : Dish_Type ;
   begin
      mealfile := csv.Open(mfn,";");
      while not CSV.End_Of_File(mealfile)
      loop
         CSV.Get_Line(mealfile);
         dish.Name := To_Unbounded_String( CSV.Field(mealfile,1) );
         dish.Servings := Servings_Type'Value( CSV.Field(mealfile,2) );
         result.Append(dish);
      end loop ;
      CSV.close(mealfile);
      return result ;
   end Load ;

   procedure Add
     (meal : in out Meal_Type; item : String; servings : Servings_Type)
   is
   begin
      null;
   end Add;

   procedure Show( meal : Meal_Type ) is
      use Ada.Strings.Unbounded, Dishes_Pkg ;
      ptr : Dishes_Pkg.Cursor ;
      dish : Dish_Type ;
   begin
      ptr := meal.First ;
      while ptr /= meal.Last 
      loop
         dish := Element(ptr);
         Put("Item "); Put(To_String(dish.Name)); Put(" "); Put(Servings_Type'Image(dish.servings)); Put_Line(" servings");
         ptr := Dishes_Pkg.Next(ptr) ;
      end loop ;
   end Show ;

   function Calories (meal : Meal_TYpe) return CaloriesType is
   begin
      return CaloriesType'Last;
   end Calories;

end foods;
