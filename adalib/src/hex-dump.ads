with System;
with Ada.Text_IO;

package Hex.dump is

   DEFAULT_BLOCK_LENGTH : constant Integer := 16;

   procedure Dump
     (Adr         : System.Address;
      Length      : Integer;
      show_offset : Boolean               := True;
      bare : Boolean := False;
      Blocklen    : Integer               := DEFAULT_BLOCK_LENGTH;
      Outfile     : Ada.Text_IO.File_Type := Ada.Text_IO.Standard_Output);


   procedure Dump
     (filename    : String;
      show_offset : Boolean               := True;
      bare : Boolean := False ;
      Blocklen    : Integer               := DEFAULT_BLOCK_LENGTH;
      Outfile     : Ada.Text_IO.File_Type := Ada.Text_IO.Standard_Output);
      
end Hex.dump;
