with Ada.Text_Io; use Ada.Text_Io;
with Ada.Command_Line; use Ada.Command_Line;
with Ada.Numerics.Elementary_Functions ;
with Ada.Containers ;
with GNAT.Source_Info ; use GNAT.Source_Info ;

with numlib.statistics ;

procedure Stats is
   use type Ada.Containers.Count_Type ;
   verbose : boolean := true ;
   myname : constant String := Enclosing_Entity ;
   procedure basics is
      use numlib.RealVectors_Pkg ;
      unit : constant String := Enclosing_Entity ;
      v1,v2, v3 : Vector; 
      vcor : Float ;
      procedure show( nm : String ; v : Vector ) is
      begin
         Put("Vector "); Put_Line(nm);
         Put("Length "); Put_Line(v.Length'Image);
         put("Mean "); Put_Line(numlib.statistics.mean(v)'Image);
         Put("Stdev "); Put_Line(numlib.statistics.stdev(v)'Image);
         for n in 0..v.Length-1
         loop
            Put(n'Image); Put(" ");
            Put(v.Element(Integer(n))'Image);
            New_Line ;
         end loop ;
      end show ;
   begin
      if verbose
      then
         Put_Line(myname);
      end if;
      v1 := numlib.Create(16, 1.0) ; 
      v2 := numlib.Create(v1) ;
      v3 := numlib.Create(16, 0.0 , 1.0 ) ;

      numlib.Mult( v2 , 3.0 );
      --show("V1" , v1);
      --show("V2" , v2);
      vcor := numlib.statistics.cor( v1 , v2 );
      Put_Line("Correlation Coefficient "); Put(vcor'Image); New_Line ;
      numlib.Apply( V3 , Ada.numerics.elementary_functions.sqrt'access );
      show("V3",v3);
      vcor := numlib.statistics.cor( v3 , v2 );
      Put("Correlation "); Put( vcor'Image); New_Line ;
   end basics ;
begin
   if Argument_Count < 1
   then
      basics ;
   elsif Argument(1) = "b"
   then
      basics ;
   end if ;
end Stats;
