with Ada.Text_Io; use Ada.Text_Io;
with Ada.Numerics.Elementary_Functions ;

package body numlib.statistics is
   
   function min( v : Vector ) return RealType is
      result : RealType := RealType'Last ;
      procedure min( c : cursor ) is
      begin
         if result > Element(c)
         then
            result := Element(c) ;
         end if ;
      end min ;
   begin
      v.Iterate( min'access );
      return result ;
   end min ;

   function max( v : Vector ) return RealType is
      result : RealType := RealType'First ;
      procedure max( c : cursor ) is
      begin
         if result < Element(c)
         then
            result := Element(c) ;
         end if ;
      end max ;
   begin
      v.Iterate(max'access);
      return result ;
   end max ;

   function sum( v : Vector ) return RealType is
      result : RealType := 0.0 ;
      procedure sum( c : cursor ) is
      begin
         result := result + Element(c) ;
      end sum ;
   begin
      v.Iterate( sum'access) ;
      return result ;
   end sum ;

   function mean( v : Vector ) return RealType is
      result : constant RealType := sum(v);
   begin
      return result / RealType(v.Length) ;
   end mean ;

   function variance( v : Vector ) return RealType is
      use type Ada.Containers.Count_Type ;
      result : RealType ;
      avg : constant RealType := mean(v);
      procedure sumsq( c : cursor ) is
      begin
         result := result + (Element(c) - avg) ** 2 ;
      end sumsq ;
   begin
      v.Iterate(sumsq'access);
      return result/RealType(v.Length - 1 );
   end variance ;
   function stdev( v : Vector ) return RealType is
      use Ada.Numerics.Elementary_Functions ;
      result : constant RealType := variance(v) ;
   begin
      return sqrt(result) ;
   end stdev ;

  function Cor( v1, v2 : Vector ) return CorrelationCoefficientType is
   use type Ada.Containers.Count_Type ;
   v1mean, v2mean : RealType ;
   v1stdev, v2stdev : RealType ;
   result : RealType := 0.0 ;
  begin
   if v1.Length /= v2.Length
   then
      raise DATA_CONSISTENCY with "Unequal Lengths" ;
   end if ;
   v1mean := mean(v1);
   v2mean := mean(v2);

   v1stdev := stdev(v1);
   v2stdev := stdev(v2);

   for idx in 0..v1.Length-1
   loop
      Put("Idx "); Put(idx'Image); New_Line ;
      Put(v1.Element(Integer(idx))'Image); Put(" , ") ;
      Put(v2.Element(Integer(idx))'Image); New_Line ;
      result := result + 
                  (v1.Element(Integer(idx)) - v1mean) +
                  (v2.Element(Integer(idx)) - v2mean) ; 
   end loop ;

   if abs(result) < eps
   then
      if abs(v1stdev*v2stdev) < eps
      then
         return 1.0 ;
      end if ;
   end if ;

   return result / (v1stdev * v2stdev) ;
   end Cor ;

end numlib.statistics ;