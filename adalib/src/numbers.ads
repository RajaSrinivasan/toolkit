with Ada.Containers.Vectors ;
package numbers is

    subtype OctalDigit_Type is Natural range 0..7 ;
    subtype DecimalDigit_Type is Natural range 0..9 ;
    subtype HexadecimalDigit_Type is Natural range 0..15 ;

    package OctalVector_Pkg is new Ada.Containers.Vectors( Natural , OctalDigit_Type );
    subtype OctalDigits_Type is OctalVector_Pkg.Vector ;

    package DecimalVector_Pkg is new Ada.Containers.Vectors( Natural , DecimalDigit_Type );
    subtype DecimalDigits_Type is DecimalVector_Pkg.Vector ;

    package HexadecimalVector_Pkg is new Ada.Containers.Vectors( Natural , HexadecimalDigit_Type );
    subtype HexadecimalDigits_Type is HexadecimalVector_Pkg.Vector ;

    package NumbersVector_Pkgs is new Ada.Containers.Vectors( Natural , Natural );
    function Convert( value : Natural ) return OctalVector_Pkg.Vector; 
    function Convert( value : Natural ) return DecimalVector_Pkg.Vector ;
    function Convert( value : Natural ) return HexadecimalVector_Pkg.Vector ;
    function Value( digs : OctalVector_Pkg.Vector ) return Natural ;
    function Value( digs : DecimalVector_Pkg.Vector ) return Natural ;
    function Value( digs : HexadecimalVector_Pkg.Vector ) return Natural ;
    function Image( digs : OctalVector_Pkg.Vector ) return String ;
    function Image( digs : DecimalVector_Pkg.Vector ) return String ;
    function Image( digs : HexadecimalVector_Pkg.Vector ) return String ;
end numbers ;