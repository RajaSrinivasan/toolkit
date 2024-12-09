pragma Ada_2012;
with Ada.Text_Io; use Ada.Text_Io ;
with Ada.Numerics.Elementary_Functions ; use Ada.Numerics.Elementary_Functions ;

package body numbers is



   -------------
   -- Convert --
   -------------

   function Convert (value : Natural) return OctalVector_Pkg.Vector is
      result : OctalVector_Pkg.Vector ;
      valnow : Natural := value ;
   begin
      if valnow < 8
      then
         result.Append(valnow);
         return result ;
      end if;
      loop
         result.Prepend(valnow mod 8 );
         valnow := valnow / 8 ;
         if valnow < 1
         then
            exit ;
         end if ;
      end loop ;
      return result ;
   end Convert;

   -------------
   -- Convert --
   -------------
   --codemd: begin segment=Convert caption=From number to digits
   function Convert (value : Natural) return DecimalVector_Pkg.Vector is
      result : DecimalVector_Pkg.Vector ;
      valnow : Natural := value ;
   begin
      if valnow < 10
      then
         result.Append(valnow);
         return result ;
      end if;
      loop
         result.Prepend( valnow mod 10 );
         valnow := valnow / 10 ;
         if valnow < 1
         then
            exit ;
         end if ;
      end loop ;
      return result ;
   end Convert;
   -- codemd: end

   -------------
   -- Convert --
   -------------

   function Convert (value : Natural) return HexadecimalVector_Pkg.Vector is
      result : HexaDecimalVector_Pkg.Vector ;
      valnow : Natural := value ;
   begin
      if valnow < 16
      then
         result.Append(valnow);
         return result ;
      end if;
      loop
         result.Prepend( valnow mod 16 );
         valnow := valnow / 16 ;
         if valnow < 1
         then
            exit ;
         end if ;
      end loop ;
      return result ;
   end Convert;

   -----------
   -- Value --
   -----------

   function Value (digs : OctalVector_Pkg.Vector) return Natural is
      use OctalVector_Pkg ;
      result : Natural := 0 ;
      curs : Cursor := digs.First ;
   begin
      loop
         result := result * 8 + Element(curs);
         if curs = Last(digs)
         then
            exit ;
         end if ;
         curs := Next(curs);
      end loop ;
      return result ;
   end Value;

   -----------
   -- Value --
   -----------
   --codemd: begin segment=Value caption=Compute the inverse. 
   function Value (digs : DecimalVector_Pkg.Vector) return Natural is
      use DecimalVector_Pkg ;
      result : Natural := 0 ;
      curs : Cursor := digs.First ;
   begin
      loop
         result := result * 10 + Element(curs);
         if curs = Last(digs)
         then
            exit ;
         end if ;
         curs := Next(curs);
      end loop ;
      return result ;
   end Value;
   --codemd: end

   -----------
   -- Value --
   -----------

   function Value (digs : HexadecimalVector_Pkg.Vector) return Natural is
      use HexaDecimalVector_Pkg ;
      result : Natural := 0 ;
      curs : Cursor := digs.First ;
   begin
      loop
         result := result * 16 + Element(curs);
         if curs = Last(digs)
         then
            exit ;
         end if ;
         curs := Next(curs);
      end loop ;
      return result ;
   end Value;

   -----------
   -- Image --
   -----------
   octalChars : constant String := "01234567";
   function Image (digs : OctalVector_Pkg.Vector) return String is
      use OctalVector_Pkg ;
      result : String( 1..Integer(Length(digs)) );
      curs : Cursor ;
      i : integer := 0 ;
   begin
      curs := First(digs);
      loop
         i := i + 1 ;
         result(i) := octalChars(1+Integer(Element(curs)));
         if curs = Last(digs)
         then
            exit ;
         end if ;
         curs := Next(curs);
      end loop ;
      return result ;
   end Image;

   -----------
   -- Image --
   -----------
   decimalChars : constant String := "0123456789" ;
   function Image (digs : DecimalVector_Pkg.Vector) return String is
      use DecimalVector_Pkg ;
      result : String( 1..Integer(Length(digs)) );
      curs : Cursor ;
      i : integer := 0 ;
   begin
      curs := First(digs);
      loop
         i := i + 1 ;
         result(i) := decimalChars(1+Integer(Element(curs)));
         if curs = Last(digs)
         then
            exit ;
         end if ;
         curs := Next(curs);
      end loop ;
      return result ;
   end Image;

   -----------
   -- Image --
   -----------
   hexChars : constant String := "0123456789abcdef" ;
   function Image (digs : HexadecimalVector_Pkg.Vector) return String is
      use HexadecimalVector_Pkg ;
      result : String( 1..Integer(Length(digs)) );
      curs : Cursor ;
      i : integer := 0 ;
   begin
      curs := First(digs);
      loop
         i := i + 1 ;
         result(i) := hexChars(1+Integer(Element(curs)));
         if curs = Last(digs)
         then
            exit ;
         end if ;
         curs := Next(curs);
      end loop ;
      return result ;
   end Image;

   --codemd: begin segment=Iterate caption=Iteration over the vector
   procedure ShowNumber( cursor : NumbersVector_Pkg.cursor ) is
   begin
      Put( NumbersVector_PKg.Element(cursor)'Image );  Put(", ");
   end ShowNumber ;

    procedure Show( num : NumbersVector_Pkg.Vector ) is
    begin
      num.Iterate( ShowNumber'access );
    end Show ;
   --codemd: end

    function Divisors( num : Natural ) return NumbersVector_Pkg.Vector is
      result : NumbersVector_Pkg.Vector ;
      sqrtnum : Float ;
    begin
      sqrtnum := sqrt( Float(num) );
      for d in 2..num/2
      loop
         if num mod d = 0
         then
            result.Append(d);
         end if ;
      end loop ;
      result.Append( 1 );
      result.Append( num );
      Sorter_Pkg.Sort(result);
      return result ;
    end Divisors ;
   --codemd: begin segment=Factors caption=Prime factorization

   function DivisorSum( num : Natural ) return Natural is
      use NumbersVector_Pkg ;
      divs : Vector := Divisors(num);
      result : Natural := 0 ;
      procedure Summer( cur : cursor ) is
      begin
         result := result + Element(cur);
      end Summer ;
   begin
      divs.Iterate(Summer'access);
      return result ;
   end DivisorSum;
 

   function Abundance( num : Natural ) return AbundancyRatio is
      result : AbundancyRatio ;
      divsum : Natural := DivisorSum(num);
   begin
      result := AbundancyRatio(Float(divsum) / Float(num)) ;
      return result ;
   end Abundance;

    function Factors( num : Natural) return NumbersVector_Pkg.Vector is
      result : NumbersVector_Pkg.Vector ;
      curfac : Natural := 2 ;
      curnum : Natural := num ;
      sqrtnum : Natural ;
    begin
      sqrtnum := 1 + Natural( sqrt( Float( num )) );
      if curfac > sqrtnum
      then
         result.Append( num );
         return result ;
      end if ;
      loop
         if curnum mod curfac = 0
         then
            result.Append( curfac );
            curnum := curnum / curfac ;
            if curnum <= 1
            then
               exit ;
            end if ;
         else
            curfac := curfac + 1 ;   
         end if ;
      end loop ;
      return result ;
    end Factors ;
   --codemd: end

    function Value( factors : NumbersVector_Pkg.Vector ) return Natural is
      result : Natural := 1 ;
      procedure Value ( cursor : NumbersVector_Pkg.cursor ) is
      begin
         result := result * NumbersVector_Pkg.Element(cursor) ;
      end Value ;
    begin
      factors.Iterate( Value'access );
      return result ;
    end Value ;
 
   -- codemd: begin segment=Prime caption=Is a number prime
    function IsPrime( num : Natural ) return boolean is
      use Ada.Containers, NumbersVector_Pkg ;
      facs : Vector := Factors( num );
    begin
      if facs.Length > 1
      then
         return false;
      end if ;
      return true ;
    end IsPrime ;
   -- codemd: end

    function IsPerfect( num : Natural ) return boolean is
      use Ada.Containers, NumbersVector_Pkg ;
      divs : Vector := Divisors( num );
      sum : Natural := 0 ;
      procedure Summer( cur : cursor ) is
      begin
         sum := sum + Element(cur);
         --Put("Item "); Put( To_Index(cur)'Image ); New_Line;
      end Summer ;
    begin
      divs.Iterate( Summer'access );
      if sum = num * 2
      then
         return true ;
      end if ;
      return false ;
    end IsPerfect ;
      
   function IsMultiperfect( num : Natural ) return boolean is
      divsum : Natural := DivisorSum(num);
   begin
      if divsum mod num = 0
      then
         return true ;
      end if ;
      return false ;
   end IsMultiperfect;

   --codemd: begin segment=Kaprekar caption=Kaprekar numbers
    function IsKaprekar( num : Natural ) return boolean is
      use Ada.Containers, DecimalVector_Pkg ;
      numsq : Natural := num * num ;
      digs : DecimalVector_Pkg.Vector := Convert(numsq) ;
      total : Natural := Natural(digs.Length) ;
      left, right : Natural := 0 ;
      procedure Summer( cur : cursor ) is
         idx : Natural := To_Index(cur);
      begin
         -- Put("Item "); Put( To_Index(cur)'Image ); New_Line;
         if idx < total / 2
         then
            left := left*10 + Element(cur);
         else
            right := right*10 + Element(cur);
         end if ;
      end Summer ;
    begin
      digs.Iterate( Summer'access );
      if left = 0 or right = 0
      then
         return false ;
      end if ;
      if left + right = num
      then
         return true ;
      end if;
      return false ;
    end IsKaprekar ;
   --codemd: end

    function gcd(left,right : Natural) return Natural is
      result : Natural ;
      temp : Natural ;
    begin
      if left > right
      then
         if left mod right = 0
         then
            return right ;
         end if ;
         return gcd( left mod right , right );
      end if ;
      if left < right
      then
         if right mod left = 0
         then
            return left ;
         end if ;
         return gcd( right mod left , left );
      end if ;
      return left ;
    end gcd ;

    function AreFriendly( left, right : Natural ) return boolean is
      lab, rab : AbundancyRatio ;
    begin
      lab := Abundance(left);
      rab := Abundance(right);
      return lab = rab ;
    end AreFriendly;
end numbers;
