pragma Ada_2012;
package body numbers is

   -------------
   -- Convert --
   -------------

   function Convert (value : Natural) return OctalVector_Pkg.Vector is
      result : OctalVector_Pkg.Vector ;
      valnow : Natural := value ;
   begin
      if valnow <= 8
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

   function Convert (value : Natural) return DecimalVector_Pkg.Vector is
      result : DecimalVector_Pkg.Vector ;
      valnow : Natural := value ;
   begin
      if valnow <= 10
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

   -------------
   -- Convert --
   -------------

   function Convert (value : Natural) return HexadecimalVector_Pkg.Vector is
      result : HexaDecimalVector_Pkg.Vector ;
      valnow : Natural := value ;
   begin
      if valnow <= 16
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

end numbers;
