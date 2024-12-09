package numlib.statistics is

   function Uniform
     (length : Natural; low : RealType := 0.0; high : RealType := 1.0)
      return Vector;
   function Normal
     (length : Natural; mean : RealType := 0.0; stdev : RealType := 1.0)
      return Vector;
   -- Descriptive Statistics
   function min (v : Vector) return RealType;
   function max (v : Vector) return RealType;
   function sum (v : Vector) return RealType;
   function mean (v : Vector) return RealType;
   function variance (v : Vector) return RealType;
   function stdev (v : Vector) return RealType;

   DATA_CONSISTENCY : exception;
   -- Ref: https://en.wikipedia.org/wiki/Pearson_correlation_coefficient
   subtype CorrelationCoefficientType is RealType range -1.0 .. 1.0;
   function Cor (v1, v2 : Vector) return CorrelationCoefficientType;

end numlib.statistics;
