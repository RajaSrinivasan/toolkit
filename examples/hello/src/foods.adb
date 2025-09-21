with Interfaces;  use Interfaces;
with Ada.Text_IO; use Ada.Text_IO;

with Ada.Command_Line; use Ada.Command_Line;

with GNAT.Source_Info; use GNAT.Source_Info;

procedure foods is
   verbose : constant Boolean := True;
   myname  : constant String  := Enclosing_Entity;
   marker  : constant String  := "--------- ";

   -- codemd: begin segment=StrongType caption=Defining some strong types
   -- Ref: https://en.wikipedia.org/wiki/Glycemic_index
   type Glycemic_Index is range 0 .. 100;
   subtype Low_GI is Glycemic_Index range 0 .. 55;
   subtype Medium_GI is Glycemic_Index range 56 .. 69;
   subtype High_GI is Glycemic_Index range 70 .. 100;

   -- https://www.verywellhealth.com/glycemic-index-chart-for-common-foods-1087476
   Apple_GI      : constant Glycemic_Index := 36;
   Banana_GI     : constant Glycemic_Index := 51;
   Chocolate_GI  : constant Glycemic_Index := 40;
   SoyaBeans_GI  : constant Glycemic_Index := 16;
   Muesli_GI     : constant Glycemic_Index := 57;
   WheatRoti_GI  : constant Glycemic_Index := 62;
   Watermelon_GI : constant Glycemic_Index := 76;
   Cornflakes_GI : constant Glycemic_Index := 81;
   -- codemd: end

   -- codemd: begin segment=StrongType2 caption=Another
   type Glycemic_Load is range 0 .. 100;
   subtype Low_GL is Glycemic_Load range 0 .. 10;
   subtype Medium_GL is Glycemic_Load range 11 .. 19;
   subtype High_GL is Glycemic_Load range 20 .. 100;
   -- codemd: end

   Orange_GL     : constant Glycemic_Load := 5;
   WhiteBread_GL : constant Glycemic_Load := 10;
   Banana_GL     : constant Glycemic_Load := 13;
   Dates_GL      : constant Glycemic_Load := 24;
   Spaghetti_GL  : constant Glycemic_Load := 20;

   subtype Carbohydrate_Serving is Float; -- Grams per serving

   function Load
     (gi : Glycemic_Index; cs : Carbohydrate_Serving) return Glycemic_Load
   is
   begin
      return Glycemic_Load (Float (gi) * cs / 100.0);
   end Load;

   procedure Annotation (operation : String) is
   begin
      Put (operation);
      Set_Col (24);
      Put (": ");
   end Annotation;

   procedure Annotation (typename : String; attribute : String) is
   begin
      Put (typename);
      Set_Col (24);
      Put (attribute);
      Set_Col (40);
   end Annotation;

   -- codemd: begin segment=Classify caption=Runtime access
   procedure Classify (glname : String; gl : Glycemic_Load) is
   begin
      Annotation (glname);
      if gl in Low_GL'Range then
         Put_Line ("Low_GL");
      elsif gl in Medium_GL'Range then
         Put_Line ("Medium_GL");
      elsif gl in High_GL'Range then
         Put_Line ("High_GL");
      else
         Put_Line ("Unable to determine");
      end if;
   end Classify;
   -- codemd: end

   -- codemd: begin segment=Vars caption=Variables
   breakfast : Glycemic_Load;
   lunch     : Glycemic_Load;
   snack     : Glycemic_Load;
   dinner    : Glycemic_Load;
   -- codemd: end

begin
   if verbose then
      Put_Line (myname);
   end if;

   Put_Line ("Classification of Variable Values");
   Classify ("Orange", Orange_GL);
   Classify ("WhiteBread", WhiteBread_GL);
   Classify ("Spaghetti", Spaghetti_GL);
   New_Line;

   -- codemd: begin segment=Error1 caption=Compile Time Error detection

   -- error: invalid operand types for operator "+"
   -- error: left operand has type "Glycemic_Load" defined at line 30
   -- error: right operand has type "Glycemic_Index" defined at line 15
   -- lunch := Spaghetti_GL + Soyabeans_GI ;

   -- codemd: end

   -- codemd: begin segment=Error2 caption=Compile Time Error detection

   -- error: invalid operand types for operator "*"
   -- error: left operand has type "Glycemic_Load" defined at line 30
   -- error: right operand has type universal real
   -- lunch := breakfast * 2.0 ;

   -- codemd: end

   -- codemd: begin segment=Compute caption=Meal composition
   breakfast := Orange_GL + WhiteBread_GL;
   lunch     := breakfast + breakfast;
   snack     := Load (Watermelon_GI, 10.0);
   dinner    := Load (SoyaBeans_GI, 15.0);
   -- codemd: end

   Put_Line ("Variable Values");
   Annotation ("breakfast");
   Put_Line (breakfast'Image);
   Annotation ("lunch");
   Put_Line (lunch'Image);
   Annotation ("snack");
   Put_Line (snack'Image);
   Annotation ("dinner");
   Put_Line (dinner'Image);
   New_Line;

   Put_Line ("Implementation Details");
   -- codemd: begin segment=Attribs caption=Attributes
   Annotation ("Glycemic_Index", "Size");
   Put (Integer'(Glycemic_Index'Size)'Image);
   Put_Line (" bits");

   Annotation ("", "Machine_Size");
   Put (Integer'(Glycemic_Index'Machine_Size)'Image);
   Put_Line (" bits");

   Annotation ("", "Range");
   Put (Glycemic_Index'(Glycemic_Index'First)'Image);
   Put (" .. ");
   Put (Glycemic_Index'(Glycemic_Index'Last)'Image);
   New_Line;
   -- codemd: end

end foods;
