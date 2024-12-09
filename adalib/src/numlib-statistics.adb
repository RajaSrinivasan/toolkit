with Ada.Numerics.Elementary_Functions;

with GNAT.Random_Numbers;

package body numlib.statistics is

   Gen  : GNAT.Random_Numbers.Generator;
   Seed : constant Integer := 16#05_22_10_07#;
   function Uniform
     (length : Natural; low : RealType := 0.0; high : RealType := 1.0)
      return Vector
   is

      result : Vector;
      span   : constant RealType := high - low;
      procedure Uniform (c : Cursor) is
         r : constant Float := GNAT.Random_Numbers.Random (Gen);
      begin
         Replace_Element (result, To_Index (c), low + span * r);
      end Uniform;
   begin
      result.Set_Length (Ada.Containers.Count_Type (length));
      result.Iterate (Uniform'Access);
      return result;
   end Uniform;
   -- codemd: begin segment=Normal caption=Normally distributed variables
   function Normal
     (length : Natural; mean : RealType := 0.0; stdev : RealType := 1.0)
      return Vector
   is
      result : Vector;
      procedure Normal (c : Cursor) is
         g : constant RealType := GNAT.Random_Numbers.Random_Gaussian (Gen);
      begin
         Replace_Element (result, To_Index (c), g * stdev + mean);
      end Normal;
   begin
      result.Set_Length (Ada.Containers.Count_Type (length));
      result.Iterate (Normal'Access);
      return result;
   end Normal;
   -- codemd: end

   function min (v : Vector) return RealType is
      result : RealType := RealType'Last;
      procedure min (c : Cursor) is
      begin
         if result > Element (c) then
            result := Element (c);
         end if;
      end min;
   begin
      v.Iterate (min'Access);
      return result;
   end min;

   function max (v : Vector) return RealType is
      result : RealType := RealType'First;
      procedure max (c : Cursor) is
      begin
         if result < Element (c) then
            result := Element (c);
         end if;
      end max;
   begin
      v.Iterate (max'Access);
      return result;
   end max;

   function sum (v : Vector) return RealType is
      result : RealType := 0.0;
      procedure sum (c : Cursor) is
      begin
         result := result + Element (c);
      end sum;
   begin
      v.Iterate (sum'Access);
      return result;
   end sum;

   function mean (v : Vector) return RealType is
      result : constant RealType := sum (v);
   begin
      return result / RealType (v.Length);
   end mean;

   -- codemd: begin segment=Variance caption=distributed variables
   function variance (v : Vector) return RealType is
      use type Ada.Containers.Count_Type;
      result : RealType;
      avg    : constant RealType := mean (v);
      procedure sumsq (c : Cursor) is
      begin
         result := result + (Element (c) - avg)**2;
      end sumsq;
   begin
      v.Iterate (sumsq'Access);
      return result / RealType (v.Length - 1);
   end variance;
   -- codemd: end
   function stdev (v : Vector) return RealType is
      use Ada.Numerics.Elementary_Functions;
      result : constant RealType := variance (v);
   begin
      return Sqrt (result);
   end stdev;

   function Cor (v1, v2 : Vector) return CorrelationCoefficientType is
      use type Ada.Containers.Count_Type;
      v1mean, v2mean   : RealType;
      v1stdev, v2stdev : RealType;
      result           : RealType := 0.0;
   begin
      if v1.Length /= v2.Length then
         raise DATA_CONSISTENCY with "Unequal Lengths";
      end if;
      v1mean := mean (v1);
      v2mean := mean (v2);

      v1stdev := stdev (v1);
      v2stdev := stdev (v2);

      for idx in 0 .. v1.Length - 1 loop
         Put (v1.Element (Integer (idx))'Image);
         Put (" ");
         Put (v2.Element (Integer (idx))'Image);
         Put (" ");
         result :=
           result +
           (v1.Element (Integer (idx)) - v1mean) *
             (v2.Element (Integer (idx)) - v2mean);
         Put (result'Image);
         New_Line;
      end loop;

      if abs (v1stdev * v2stdev) < eps then
         return 1.0;
      end if;

      if abs (result) < eps then
         return 1.0;
      end if;
      if result < CorrelationCoefficientType'First then
         return CorrelationCoefficientType'First;
      elsif result > CorrelationCoefficientType'Last then
         return CorrelationCoefficientType'Last;
      end if;
      return result / (v1stdev * v2stdev);
   end Cor;
begin
   GNAT.Random_Numbers.Reset (Gen, Seed);
end numlib.statistics;
