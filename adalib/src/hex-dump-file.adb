with Ada.Streams.Stream_IO;
with Ada.Directories ;

package body Hex.dump.file is
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
      Ada.Text_Io.Put("Dumping "); Ada.Text_Io.Put_Line(filename);
      filesize := Ada.Directories.Size( filename );
      if not bare
      then
         Ada.Text_IO.Put (Outfile, "* Dump of *********");
         Ada.Text_IO.Put (Outfile, filename);
         Ada.Text_Io.Put (Outfile," Size : ") ;
         Ada.Text_Io.Put (Outfile,Integer'Image(Integer(filesize))) ;
         Ada.Text_IO.Put_Line (Outfile, " *********************************");
      end if ;

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
                 bare,
                 show_offset ,
                 Blocklen ,
                 Outfile );
          end if ;
      end ;
      Ada.Streams.Stream_IO.Close (file);
   exception
      when others =>
         Ada.Text_Io.Put_Line("Exception");
         raise;
   end Dump;
end Hex.dump.file;
