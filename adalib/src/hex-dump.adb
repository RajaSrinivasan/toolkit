with System.Storage_Elements; use System.Storage_Elements;
with Ada.Characters.Handling;
with Ada.Text_IO;             use Ada.Text_IO;
with Ada.Integer_Text_IO;     use Ada.Integer_Text_IO;
with Ada.Streams.Stream_IO;
with Ada.Directories ;

with GNAT.Debug_Utilities;

package body Hex.dump is
   procedure Dump
     (Adr         : System.Address;
      Length      : Integer;
      show_offset : Boolean               := True;
      bare : Boolean := False;
      Blocklen    : Integer               := DEFAULT_BLOCK_LENGTH;
      Outfile     : Ada.Text_IO.File_Type := Ada.Text_IO.Standard_Output)
   is
      blockadr : System.Address := Adr;
      bigBlock : array (1 .. Length) of Interfaces.Unsigned_8;
      for bigBlock'Address use Adr;

      No_Blocks    : constant Integer := Length / Blocklen + 1;
      Blockstart   : Integer;
      Lengthleft   : Integer          := Length;
      Lengthtodump : Integer;

      adrcol : constant Integer := 1;
      piccol : constant Integer := GNAT.Debug_Utilities.Address_Image_Length + adrcol;

      function CharImage (ci : Interfaces.Unsigned_8) return Character is
         c : constant Character := Character'Val (Integer (ci));
      begin
         if not Ada.Characters.Handling.Is_ISO_646 (c) then
            return '.';
         end if;
         if Ada.Characters.Handling.Is_Alphanumeric (c) then
            return c;
         end if;

         return '.';
      end CharImage;

   begin

      for B in 1 .. No_Blocks loop
         Blockstart := (B - 1) * Blocklen + 1;
         if bare
         then
            null;
         else 
            if show_offset then
               Put (Outfile, Blockstart-1, Base => 16);
            else
               Put (Outfile, GNAT.Debug_Utilities.Image (blockadr));
            end if;
         end if;
         if Lengthleft >= Blocklen then
            Lengthtodump := Blocklen;
         else
            Lengthtodump := Lengthleft;
         end if;

         -- Set_Col (Outfile, Count (piccol));
         if bare
         then
            Put(OutFile,'"');
         else
            Put (" * ");
            for b in 1 .. Lengthtodump loop
               Put (CharImage (bigBlock (Blockstart + b - 1)));
            end loop;
            Set_Col (Outfile, Count (piccol + Blocklen + 3));
            Put (" * ");
         end if ;

         for b in 1 .. Lengthtodump loop
            Put (OutFile,Hex.Image (bigBlock (Blockstart + b - 1)));
         end loop;

         if bare
         then
            Put(OutFile,'"'); Put_Line(OutFile," &");
         else
            Set_Col (Outfile, Count (piccol + Blocklen + 3 + Blocklen * 2 + 3));
            Put_Line (" *");
         end if ;
         blockadr   := blockadr + Storage_Offset (Lengthtodump);
         Lengthleft := Lengthleft - Lengthtodump;
         exit when Lengthleft = 0;
      end loop;
   end Dump;



   procedure Dump
     (filename    : String;
      show_offset : Boolean               := True;
      bare : Boolean := False ;
      Blocklen    : Integer               := DEFAULT_BLOCK_LENGTH;
      Outfile     : Ada.Text_IO.File_Type := Ada.Text_IO.Standard_Output)
   is
      use Ada.Streams;
      file   : Ada.Streams.Stream_IO.File_Type;
      stream : Ada.Streams.Stream_IO.Stream_Access;
      filesize : Ada.Directories.File_Size ;
   begin
      
      filesize := Ada.Directories.Size( filename );
      if not bare
      then
         Ada.Text_IO.Put (Outfile, "Dump of ");
         Ada.Text_IO.Put (Outfile, filename);
         Ada.Text_Io.Put (Outfile," Size : ") ;
         Ada.Text_Io.Put (Outfile,Integer'Image(Integer(filesize))) ;
         Ada.Text_Io.New_Line;
         --Ada.Text_IO.Put_Line (Outfile, " *********************************");
      end if ;

      -- codemd: begin segment=DumpFile caption=Dump a file 
      Ada.Streams.Stream_IO.Open
        (file,
         Ada.Streams.Stream_IO.In_File,
         filename);
      stream := Ada.Streams.Stream_IO.Stream (file);
      declare
        buffer : Ada.Streams.Stream_Element_Array
                 (1 .. Ada.Streams.Stream_Element_Offset (filesize));
        bufferlen : Ada.Streams.Stream_Element_Offset;
      begin
          stream.Read (buffer, bufferlen);
          if bufferlen > 0 then
              Hex.dump.Dump
                (buffer'Address,
                 Integer (bufferlen),
                 bare => bare,
                 show_offset => show_offset ,
                 blocklen => Blocklen ,
                 outfile => Outfile );
          end if ;
      end ;
      -- codemd: end
      Ada.Streams.Stream_IO.Close (file);
   exception
      when others =>
         Ada.Text_Io.Put_Line("Exception");
         raise;
   end Dump;


end Hex.dump;
