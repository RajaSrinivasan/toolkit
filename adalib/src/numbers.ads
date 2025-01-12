with Ada.Containers.Vectors;

package numbers is

   --codemd: begin segment=Define caption=Define basic packages
   subtype OctalDigit_Type is Natural range 0 .. 7;
   subtype DecimalDigit_Type is Natural range 0 .. 9;
   subtype HexadecimalDigit_Type is Natural range 0 .. 15;

   package OctalVector_Pkg is new Ada.Containers.Vectors
     (Natural, OctalDigit_Type);
   subtype OctalDigits_Type is OctalVector_Pkg.Vector;

   package DecimalVector_Pkg is new Ada.Containers.Vectors
     (Natural, DecimalDigit_Type);
   subtype DecimalDigits_Type is DecimalVector_Pkg.Vector;

   package HexadecimalVector_Pkg is new Ada.Containers.Vectors
     (Natural, HexadecimalDigit_Type);
   subtype HexadecimalDigits_Type is HexadecimalVector_Pkg.Vector;
   --codemd: end

   --codemd: begin segment=Basics caption=Basic usage
   function Convert (value : Natural) return OctalVector_Pkg.Vector;
   function Convert (value : Natural) return DecimalVector_Pkg.Vector;
   function Convert (value : Natural) return HexadecimalVector_Pkg.Vector;
   function Value (digs : OctalVector_Pkg.Vector) return Natural;
   function Value (digs : DecimalVector_Pkg.Vector) return Natural;
   function Value (digs : HexadecimalVector_Pkg.Vector) return Natural;
   function Image (digs : OctalVector_Pkg.Vector) return String;
   function Image (digs : DecimalVector_Pkg.Vector) return String;
   function Image (digs : HexadecimalVector_Pkg.Vector) return String;
   --codemd: end

   package NumbersVector_Pkg is new Ada.Containers.Vectors (Natural, Natural);
   package Sorter_Pkg is new NumbersVector_Pkg.Generic_Sorting ("<");

   procedure Show (num : NumbersVector_Pkg.Vector);
   function Divisors (num : Natural) return NumbersVector_Pkg.Vector;

   -- Ref: https://reference.wolfram.com/language/ref/DivisorSigma.html
   -- Ref: https://reference.wolfram.com/language/ref/DivisorSum.html?q=DivisorSum
   function DivisorSum (num : Natural) return Natural;

   --codemd: begin segment=Abundance caption=Abundancy ratio
   -- Ref: https://mathworld.wolfram.com/Abundancy.html
   type AbundancyRatio is delta 0.01 digits 6;
   function Abundance (num : Natural) return AbundancyRatio;
   --codemd: end

   function Factors (num : Natural) return NumbersVector_Pkg.Vector;
   function Value (factors : NumbersVector_Pkg.Vector) return Natural;

   -- Unary Algorithms
   function IsPrime (num : Natural) return Boolean;
   function IsPerfect (num : Natural) return Boolean;
   -- Ref: https://en.wikipedia.org/wiki/Multiply_perfect_number
   -- Ref: https://mathworld.wolfram.com/MultiperfectNumber.html
   function IsMultiperfect (num : Natural) return Boolean;
   -- Ref: https://en.wikipedia.org/wiki/Kaprekar_number
   function IsKaprekar (num : Natural) return Boolean;

   -- Binary Algorithms
   function gcd (left, right : Natural) return Natural;
   -- Ref: https://en.wikipedia.org/wiki/Friendly_number
   function AreFriendly (left, right : Natural) return Boolean;

end numbers;
