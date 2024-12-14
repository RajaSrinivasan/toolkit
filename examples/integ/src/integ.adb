with Ada.Text_IO;      use Ada.Text_IO;
with Ada.Command_Line; use Ada.Command_Line;
with Ada.Streams;
with Interfaces;       use Interfaces;

with GNAT.Source_Info; use GNAT.Source_Info;
with GNAT.Random_Numbers;
with hex;
with parity;
with CRC16;
with GNAT.MD5;

procedure Integ is
   myname : constant String := Enclosing_Entity;

   Gen : GNAT.Random_Numbers.Generator;
   -- codemd: begin segment=Corrupt caption=Random bit in a random byte
   function Corrupt (b : Unsigned_8) return Unsigned_8 is
      mask : Unsigned_8 := 0;
      rv   : Float ;
   begin
      loop
         rv := GNAT.Random_Numbers.Random (Gen);
         mask := Shift_Left (2#1#, Natural (rv * Float (mask'Size)));
         if mask /= 0
         then
            exit ;
         end if ;
      end loop ;
      return mask xor b;
   end Corrupt;
   -- codemd: end

   function Corrupt (str : String) return String is
      result : String := str;
      char   : Natural;
      chosen : Unsigned_8;
   begin
      char :=
        1 + Natural (GNAT.Random_Numbers.Random (Gen) * Float (result'Length));
      if char >= str'Length then
         char := str'Length;
      end if;
      Put ("Corrupting char ");
      Put (char'Image);
      Put (" (");
      Put (result (char));
      Put (')');
      chosen        := Unsigned_8 (Character'Pos (result (char)));
      result (char) := Character'Val (Corrupt (chosen));
      Put (" to ");
      Put (result (char)'Image);
      New_Line;
      return result;
   end Corrupt;


   procedure ParityTest is
      myname : constant String := Enclosing_Entity;
      arg    : Unsigned_8;
      bc     : parity.BitCountType;
      reqpar : parity.ParityType;
      parbit : parity.ParityBitType;
   begin
      if Argument_Count < 2 then
         Put (myname);
         Put_Line (" requires a test candidate");
         return;
      end if;

      case Argument (1) (1) is
         when 'p' =>
            reqpar := parity.Odd;
         when 'P' =>
            reqpar := parity.Even;
         when others =>
            return;
      end case;
      for argn in 2 .. Argument_Count loop
         arg := Unsigned_8 (Character'Pos (Argument (argn) (1)));
         Put ("Argument : ");
         Put (Character'Val (arg));
         Put (" ");
         Put (hex.Image (arg));
         New_Line;
         bc     := parity.BitCount (arg);
         parbit := parity.ParityBit (arg, reqpar);
         Put ("BitCount ");
         Put (bc'Image);
         Put (" Required Parity Bit ");
         Put (parbit'Image);
         New_Line;
         arg := Corrupt (arg);
         Put ("Corrupted to ");
         Put (hex.Image (arg));
         parbit := parity.ParityBit (arg, reqpar);
         Put (" Required Parity Bit ");
         Put (parbit'Image);
         New_Line;
      end loop;
   end ParityTest;

   procedure CRCTest is
      myname : constant String := Enclosing_Entity;
      crc    : Unsigned_16;
   begin
      if Argument_Count < 2 then
         Put (myname);
         Put_Line (" requires a test candidate");
         return;
      end if;
      crc := crc16.Compute (Argument (2));
      Put ("CRC is ");
      Put (hex.Image (crc));
      New_Line;
      for i in 1 .. 8 loop
         Put ("With 1 bit corruption ");
         crc := crc16.Compute (Corrupt (Argument (2)));
         Put ("CRC is ");
         Put (hex.Image (crc));
         New_Line;
      end loop;
   end CRCTest;

   function digest (s : String) return String is
      Ctx    : GNAT.MD5.Context := GNAT.MD5.Initial_Context;
      buffer : Ada.Streams.Stream_Element_Array (1 .. s'Length);
      for buffer'Address use s'Address;
      bufbytes : Ada.Streams.Stream_Element_Count;

   begin
      GNAT.MD5.Update (Ctx, buffer (1 .. bufbytes));
      bufbytes := Ada.Streams.Stream_Element_Count (s'Length);
      GNAT.MD5.Update (Ctx, buffer (1 .. bufbytes));
      return GNAT.MD5.Digest (Ctx);
   end digest;

   procedure HashTest is
      myname : constant String := Enclosing_Entity;
      crc    : Unsigned_16;
   begin
      if Argument_Count < 2 then
         Put (myname);
         Put_Line (" requires a test candidate");
         return;
      end if;
      Put ("Digest : ");
      Put_Line (digest (Argument (2)));
      for i in 1 .. 8 loop
         Put ("With 1 bit corruption ");
         declare
            cstr : String := Corrupt (Argument (2));
         begin
            Put ("Digest : ");
            Put_Line (digest (cstr));
         end;
      end loop;

   end HashTest;

begin
   if Argument_Count < 1 then
      Put ("usage : ");
      Put (myname);
      Put_Line (" [p|P|c|h] arg1 ...");
      return;
   end if;
   GNAT.Random_Numbers.Reset (Gen);
   if Argument (1) = "p" or Argument (1) = "P" then
      ParityTest;
   elsif Argument (1) = "c" then
      CRCTest;
   elsif Argument (1) = "h" then
      HashTest;
   end if;

end Integ;
