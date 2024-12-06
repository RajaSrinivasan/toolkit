package numlib.statistics is

   -- Descriptive Statistics
   function min( v : Vector ) return RealType ;
   function max( v : Vector ) return RealType ;
   function sum( v : Vector ) return RealType ;
   function mean( v : Vector ) return RealType ;
   function variance( v : Vector ) return RealType ;
   function stdev( v : Vector ) return RealType ;

   DATA_CONSISTENCY : exception ;
   -- Ref: https://en.wikipedia.org/wiki/Pearson_correlation_coefficient
   subtype CorrelationCoefficientType is RealType range -1.0 .. 1.0 ;
   function Cor( v1, v2 : Vector ) return CorrelationCoefficientType ;


end numlib.statistics ;