with Ada.Text_IO; use Ada.Text_IO;
with csv;
package body foods is

   function Load
     (gi : Glycemic_Index; cs : CarbohydratesPerServing) return Glycemic_Load
   is
   begin
      return Glycemic_Load (Float (gi) * Float (cs) / 100.0);
   end Load;

   function Equal( Left, Right : Food_Item_Type ) return boolean is
      use Ada.Strings.Unbounded ;
   begin
      if Left.Name = Right.Name
      then
         return true ;
      end if;
      return false ;
   end Equal ;

   function Load (filename : String) return FoodsDatabase_Type is
      use Ada.Strings.Unbounded;
      result : FoodsDatabase_Pkg.Vector;
      item   : Food_Item_Type;
      fdbf   : csv.File_Type;
   begin
      fdbf := csv.Open (filename, ";");
      while not csv.End_Of_File (fdbf) loop
         csv.Get_Line (fdbf);
         item.Name        := To_Unbounded_String (csv.Field (fdbf, "Name"));
         item.ServingSize :=
           To_Unbounded_String (csv.Field (fdbf, "Servings"));
         item.Calories    := CaloriesType'Value (csv.Field (fdbf, "Calories"));
         item.carbs       :=
           CarbohydratesPerServing'Value (csv.Field (fdbf, "Carbs"));
         result.Append (item);
      end loop;
      csv.Close (fdbf);
      return FoodsDatabase_Type (result);
   end Load;

   procedure Show (fi : Food_Item_Type) is
      use Ada.Strings.Unbounded;
   begin
      Put (Unbounded_String'Image (fi.Name));
      Set_Col (24);
      Put (Unbounded_String'Image (fi.ServingSize));
      Set_Col (34);
      Put (CaloriesType'Image (fi.Calories));
      New_Line;
   end Show;

   procedure Show (position : FoodsDatabase_Pkg.cursor) is
   begin
      Show (FoodsDatabase_Pkg.Element (position));
   end Show;

   procedure Show (db : FoodsDatabase_Type) is
      vector : FoodsDatabase_Pkg.Vector := FoodsDatabase_Pkg.Vector (db);
   begin
      Put_Line ("Food Database");
      Put ("Name");
      Set_Col (24);
      Put ("ServingSize");
      Set_Col (34);
      Put ("Calories");
      New_Line;
      FoodsDatabase_Pkg.Iterate (vector, Show'Access);
   end Show;

   function Find(db : FoodsDatabase_Type ; item : String ) return Food_Item_Type is
      use Ada.Strings.Unbounded , FoodsDatabase_Pkg;
      fi : Food_Item_Type ;
      found : FoodsDatabase_Pkg.Cursor ;
   begin
      fi.Name := To_Unbounded_String(item);
      found := FoodsDatabase_Pkg.Find(db,fi);
      if found = FoodsDatabase_Pkg.No_Element
      then
         raise DatabaseError ;
      end if;
      return FoodsDatabase_Pkg.Element(found) ;
   end Find ;

   function Load (mfn : String) return Meal_Type is
      use Ada.Strings.Unbounded;
      result   : Meal_TYpe;
      mealfile : csv.File_Type;
      dish     : Dish_Type;
   begin
      mealfile := csv.Open (mfn, ";");
      while not csv.End_Of_File (mealfile) loop
         csv.Get_Line (mealfile);
         dish.Name     := To_Unbounded_String (csv.Field (mealfile, 1));
         dish.Servings := Servings_Type'Value (csv.Field (mealfile, 2));
         result.Append (dish);
      end loop;
      csv.close (mealfile);
      return result;
   end Load;

   procedure Add
     (meal : in out Meal_Type; item : String; servings : Servings_Type)
   is
      use Ada.Strings.Unbounded;
      dish : Dish_Type;
   begin
      dish.Name     := To_Unbounded_String (item);
      dish.Servings := servings;
      meal.Append (dish);
   end Add;

   procedure Show (meal : Meal_Type) is
      use Ada.Strings.Unbounded, Dishes_Pkg;
      ptr  : Dishes_Pkg.Cursor;
      dish : Dish_Type;
   begin
      ptr := meal.First;
      while ptr /= Dishes_Pkg.No_Element loop
         dish := Element (ptr);
         Put ("Item ");
         Put (To_String (dish.Name));
         Put (" ");
         Put (Servings_Type'Image (dish.servings));
         Put_Line (" servings");
         ptr := Dishes_Pkg.Next (ptr);
      end loop;
   end Show;

  function Calories (db : FoodsDatabase_Type ; dish : Dish_TYpe) return CaloriesType is
   use FoodsDatabase_Pkg;
   fi : Food_Item_Type ;
   found : FoodsDatabase_Pkg.Cursor ;
  begin
   fi.Name := dish.Name ;
   found := FoodsDatabase_Pkg.Find(db,fi);
   if found = FoodsDatabase_Pkg.No_Element
   then
      raise DatabaseError ;
   end if;
   return FoodsDatabase_Pkg.Element(found).Calories ;
  end Calories ;

   function Calories (db : FoodsDatabase_Type ; meal : Meal_TYpe) return CaloriesType is
      use Dishes_Pkg ;
      result : CaloriesType := 0 ;
      ptr  : Dishes_Pkg.Cursor;
   begin
      ptr := meal.First;
      while ptr /= Dishes_Pkg.No_Element loop
         result := result + CaloriesType( Float(Dishes_pkg.Element(ptr).Servings) * 
                                          Float(Calories(db,Dishes_Pkg.Element(ptr))));
         ptr := Dishes_Pkg.Next(ptr);
      end loop ;
      return result ;
   end Calories;

end foods;
