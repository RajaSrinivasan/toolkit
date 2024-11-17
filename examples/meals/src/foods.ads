with Ada.Strings.Unbounded;
with Ada.Containers.Vectors;
package foods is

   type CaloriesType is range 1 .. 10_000;
   type ProteinsType is range 0 .. 100;       -- Grams

   type GlycemicIndexType is range 0 .. 100;
   type GlycemicLoadType is range 0 .. 100;

   -- codemd: begin segment=StrongType caption=Defining some strong types
   -- Ref: https://en.wikipedia.org/wiki/Glycemic_index
   type Glycemic_Index is range 0 .. 100;
   subtype Low_GI is Glycemic_Index range 0 .. 55;
   subtype Medium_GI is Glycemic_Index range 56 .. 69;
   subtype High_GI is Glycemic_Index range 70 .. 100;
   -- codemd: end

   -- codemd: begin segment=StrongType2 caption=Another
   type Glycemic_Load is range 0 .. 100;
   subtype Low_GL is Glycemic_Load range 0 .. 10;
   subtype Medium_GL is Glycemic_Load range 11 .. 19;
   subtype High_GL is Glycemic_Load range 20 .. 100;
   -- codemd: end

   subtype CarbohydratesPerServing is
     Short_Short_Integer range 0 .. 100; -- Grams per serving
   function Load
     (gi : Glycemic_Index; cs : CarbohydratesPerServing) return Glycemic_Load;

   type Food_Item_Type is record
      Name        : Ada.Strings.Unbounded.Unbounded_String;
      ServingSize : Ada.Strings.Unbounded.Unbounded_String :=
        Ada.Strings.Unbounded.Null_Unbounded_String;
      Calories    : CaloriesType := CaloriesType'First;
      Proteins    : ProteinsType := ProteinsType'First;
      gi          : Glycemic_Index;
      gl          : Glycemic_Load;
      carbs       : CarbohydratesPerServing;
   end record;

   package FoodsDatabase_Pkg is new Ada.Containers.Vectors
     (Index_Type => Natural, Element_Type => Food_Item_Type);
   subtype FoodsDatabase_Type is FoodsDatabase_Pkg.Vector ;
   function Load (filename : String) return FoodsDatabase_Type ;
   procedure Show( db : FoodsDatabase_Type );

   DatabaseError : exception;

   type Servings_Type is range 0 .. 8;
   type Dish_Type is record
      Name     : Ada.Strings.Unbounded.Unbounded_String;
      Servings : Servings_Type;
   end record;

   package Dishes_Pkg is new Ada.Containers.Vectors
     (Index_Type => Natural, Element_Type => Dish_Type);
   subtype Meal_Type is Dishes_Pkg.Vector;
   function Load( mfn : String ) return Meal_Type ;
   procedure Add
     (meal : in out Meal_Type; item : String; servings : Servings_Type);
   procedure Show( meal : Meal_Type );
   function Calories (meal : Meal_Type) return CaloriesType;
 

end foods;
