with Ada.Text_Io; use Ada.Text_Io ;
with Ada.Command_Line; use Ada.Command_Line ;
with Ada.Streams ;
with Interfaces ; use Interfaces ;

with GNAT.Source_Info ; use GNAT.Source_Info ;
with GNAT.Random_Numbers ; 
with hex ;
with parity ;
with CRC16 ;
with GNAT.MD5 ;

procedure Integ is
   myname : constant String := Enclosing_Entity ;
   procedure ParityTest is
      myname : constant String := Enclosing_Entity ;
      arg : Unsigned_8;
      bc : parity.BitCountType ;
      reqpar : parity.ParityType ;
      parbit : parity.ParityBitType ;
   begin
      if Argument_Count < 2
      then
         Put(myname);
         Put_Line(" requires a test candidate");
         return ;
      end if;
      arg := Unsigned_8'Value(Argument(2));
      case Argument(1)(1) is
         when 'p' => reqpar := parity.Odd; 
         when 'P' => reqpar := parity.Even;
         when others => return ;
      end case ;
      bc := parity.BitCount( arg  );
      parbit := parity.ParityBit( arg , reqpar );
      Put("BitCount "); Put( bc'Image );
      Put(" Required Parity Bit "); Put(parbit'Image);
      New_Line ;
   end ParityTest ;

   Gen : GNAT.Random_Numbers.Generator ;

   function Corrupt( str : String ) return String is
      result : String := str ;
      char : Natural ;
      charbit : Integer ;
      mask : Unsigned_8 := 0 ;
   begin
      GNAT.Random_Numbers.Reset (Gen) ;
      Char := Natural(GNAT.Random_Numbers.Random(Gen) * Float(result'Length));
      if Char < result'First
      then
         Char := result'First ;
      end if ;
      Put("Corrupting char ") ; Put(char'Image); Put('('); Put(result(char)); Put(')'); New_Line ;

      loop
         charbit := 1 + Integer(GNAT.Random_Numbers.Random(Gen) * Float(char'Size)) ;
         if charbit > char'Size
         then
            charbit := char'Size ;
         end if ;
         mask := Shift_Left( 2#1# , charbit );
         if mask /= 0
         then
            exit ;
         end if ;
      end loop ;

      Put("Corrupting mask ") ; Put(hex.Image(mask)); New_Line ;
      result( char ) := Character'Val((Unsigned_8(Character'Pos(result(char))) xor mask) ) ;
      return result ;
   end Corrupt ;

   procedure CRCTest is
      myname : constant String := Enclosing_Entity ;
      crc : Unsigned_16 ;
   begin
      if Argument_Count < 2
      then
         Put(myname);
         Put_Line(" requires a test candidate");
         return ;
      end if;
      crc := crc16.Compute( Argument(2) );
      Put("CRC is "); Put(hex.Image(crc)); New_Line ;
      Put("With 1 bit corruption ");
      crc := crc16.Compute(Corrupt(Argument(2)));
      Put(hex.Image(crc)); New_Line ;
   end CRCTest;

   function digest( s : String ) return String is
      Ctx : Gnat.MD5.Context := Gnat.Md5.Initial_Context ;
      buffer : ada.Streams.Stream_Element_Array(1..s'length) ;
      for buffer'Address use s'Address ;
      bufbytes : ada.Streams.Stream_Element_Count ;
  
   begin
      Gnat.MD5.Update(Ctx,Buffer(1..Bufbytes)) ;
      bufbytes := Ada.Streams.Stream_Element_Count(s'Length) ;
      Gnat.MD5.Update(Ctx,Buffer(1..Bufbytes)) ;
      return GNAT.MD5.Digest(Ctx);
   end digest ;

   procedure HashTest is
      myname : constant String := Enclosing_Entity ;
      crc : Unsigned_16 ;
   begin
      if Argument_Count < 2
      then
         Put(myname);
         Put_Line(" requires a test candidate");
         return ;
      end if;
      Put("Digest : "); Put_Line(Digest(Argument(2)));
      Put("With 1 bit corruption ");
      declare
         cstr : String := Corrupt(Argument(2));
      begin
         Put("Digest : "); Put_Line(Digest(cstr));
      end ;
   end HashTest;

begin
   if Argument_Count < 1 
   then
      Put("usage : ");
      Put(myname);
      Put_Line(" [p|P|c|h] arg1 ...");
      return ;
   end if ;
   if Argument(1) = "p" or Argument(1) = "P"
   then
      ParityTest ;
   elsif Argument(1) = "c" 
   then
      CRCTest ;
   elsif Argument(1) = "h" 
   then
      HashTest ;
   end if ;

end Integ;
