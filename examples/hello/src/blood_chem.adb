---------------------------------------
--      Program: blood_chem          --
--      Author: RajaSrinivasan       --
---------------------------------------
--      Synopsis:
--        an example from diabetes
--        exploring blood glucose
--        levels
---------------------------------------

with Text_IO;           use Text_IO;
with Ada.Float_Text_IO; use Ada.Float_Text_IO;
with Ada.Exceptions;

procedure blood_chem is

   -- codemd: begin segment=Dtype caption=Richer data types
   type Glucose_Concentration_Type is new Float range 0.0 .. 1_000.0;
   subtype Hyperglycemic_Glucose_Type is
     Glucose_Concentration_Type range 140.0 .. 1_000.0;
   subtype Hypoglycemic_Glucose_Type is
     Glucose_Concentration_Type range 0.0 .. 70.0;
   subtype Euglycemic_Glucose_Type is
     Glucose_Concentration_Type range 70.0 .. 140.0;

   my_glucose         : Glucose_Concentration_Type := 139.999_991;
   good_glucose_value : Euglycemic_Glucose_Type;
   hypo_value         : Hypoglycemic_Glucose_Type;
   Hyper_value        : Hyperglycemic_Glucose_Type;
   -- codemd: end

begin

   Put ("Hypoglycemia Range is glucose levels below ");
   Put (Float (Hypoglycemic_Glucose_Type'Last));
   New_Line;
   Put ("Hyperglycemia Range is glucose levels above ");
   Put (Float (Hyperglycemic_Glucose_Type'First));
   New_Line;

   Put ("My Glucose Level is ");
   Put (Float (my_glucose));
   New_Line;
   -- codemd: begin segment=RangeCheck caption=Query the type
   if my_glucose in Hypoglycemic_Glucose_Type'Range then
      Put_Line ("I am hypoglycemic");
   elsif my_glucose in Hyperglycemic_Glucose_Type'Range then
      Put_Line ("I am hyperglycemic");
   elsif my_glucose in Euglycemic_Glucose_Type'Range then
      Put_Line ("My Glucose levels are good");
   else
      Put_Line ("Cannot classify my glucose level");
   end if;
   -- codemd: end

   -- codemd: begin segment=Exception caption=Assertion that value range holds
   good_glucose_value := my_glucose;
   begin
      hypo_value := good_glucose_value;
   exception
      when Event : others =>
         Put_Line ("Assigning good_glucose_value to hypo_value");
         Put_Line (Ada.Exceptions.Exception_Message (Event));
   end;
   -- codemd: end

   begin
      Hyper_value := hypo_value;
   exception
      when Event : others =>
         Put_Line ("Assigning hypo_value to hyper_value");
         Put_Line (Ada.Exceptions.Exception_Message (Event));
   end;

end blood_chem;
