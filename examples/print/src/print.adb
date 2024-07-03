with Ada.Command_Line; use Ada.Command_Line ;
with Ada.Text_Io; use Ada.Text_Io;
with Ada.Integer_Text_Io; use Ada.Integer_Text_Io;
with Ada.Float_Text_Io; use Ada.Float_Text_Io;
with Ada.Long_Float_Text_Io; use Ada.Long_Float_Text_Io;
with Interfaces; use Interfaces;
with Interfaces.C; use Interfaces.C;

with images ;
with values ;

procedure Print is
   
   procedure T1 is
      v : Integer := Integer'Value(Argument(2));
   begin
      Put( images.Image(Argument(3) , v ));
      New_Line;
   end T1 ;
   procedure T2 is
      v : Float := Float'Value(Argument(2));
   begin
      Put( images.Image(Argument(3) , v ));
      New_Line;
   end T2 ;
   procedure T3 is
      v : Long_Float := Long_Float'Value(Argument(2));
   begin
      Put( images.Image(Argument(3) , v ));
      New_Line;
   end T3 ;
   procedure T4 is
   begin
      Put( images.Image(Argument(3) , Argument(2) ));
      New_Line;
   end T4 ;   

   procedure T5 is
      val : String := Argument(2) ;
      fmt : String := Argument(3) ;
      int : Integer ;
   begin
      int := values.Value(fmt,val);
      Put("Integer Value "); Put(int); New_Line ;
   end T5 ;

   procedure T6 is
      val : String := Argument(2) ;
      fmt : String := Argument(3) ;
      f : Float ;
   begin
      f := values.Value(fmt,val);
      Put("Float Value "); Put(f); New_Line ;
   end T6 ;

   procedure T7 is
      val : String := Argument(2) ;
      fmt : String := Argument(3) ;
      f : Interfaces.C.double ;
   begin
      f := values.Value(fmt,val);
      Put("Long_Float Value "); Put(Long_Float(f)); New_Line ;
   end T7 ;


   procedure T8 is
      val : String := Argument(2) ;
      fmt : String := Argument(3) ;
      u : Unsigned_32 ;
   begin
      u := values.Value(fmt,val);
      Put("Unsigned_32 Value "); Put(u'Image); New_Line ;
   end T8 ;

begin
   if Argument(1) = "t1"
   then
      T1 ;
   elsif Argument(1) = "t2"
   then
      T2 ;
   elsif Argument(1) = "t3"
   then
      T3 ;
   elsif Argument(1) = "t4"
   then
      T4 ;
   elsif Argument(1) = "t5"
   then
      T5 ;
   elsif Argument(1) = "t6"
   then
      T6 ;
   elsif Argument(1) = "t7"
   then
      T7 ;
   elsif Argument(1) = "t8"
   then
      T8 ;
   else
      Put_Line("?");
   end if ;
end Print;
