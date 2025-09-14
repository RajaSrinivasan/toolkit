with Ada.Text_Io; use Ada.Text_Io;
with npy.dict ;
with server;
package body npy is 

   function Open( name : String ) return File_Type is
      result : File_Type ;
      hdr : header ;
      hdr_length : Integer ;
      lenlow, lenhigh : Stream_Element ;
   begin
      result.stream := new Ada.Streams.Stream_Io.File_Type ;
      Open( result.stream.all  , In_FIle , name );

      header'Read( stream( result.stream.all ) , hdr );
      if hdr.m /= magic
      then
         raise FORMAT_ERROR ;
      end if ;
      Stream_Element'Read( stream(result.stream.all) , lenlow );
      Stream_Element'Read( stream(result.stream.all) , lenhigh );

      hdr_length := Integer(lenlow + 16#ff# * lenhigh) ;
      if debug
      then
         Put( "Header length "); 
         Put(hdr_length'Image); 
         New_Line;
      end if ;
      result.header := new String( 1..hdr_length ) ;
      String'Read( stream( result.stream.all ) , result.header.all );
      result.major_v := hdr.major_v ;
      result.minor_v := hdr.minor_v ;

      --result.dict := npy.dict.Value( result.header.all );
      npy.dict.SetDict( result );
      --npy.dict.SetShape (result , npy.dict.Value( result.header.all ));
      return result ;
   end Open ;

   procedure Close( file : File_Type ) is
   begin
      Ada.Streams.Stream_Io.Close( file.stream.all );
   end Close ;

  procedure Show( file : File_Type ) is
  begin
   Put("Version :");
   Put(" Major "); Put( file.major_v'Image );
   Put(" Minor "); Put( file.minor_v'Image );
   New_Line ;
   Put_Line("Descriptors");
   Put_Line( file.header.all );

   Put(" descr "); Put_Line( file.descr.all );
   Put(" fortran_order "); Put_Line( file.fortran_order'Image );
   Put(" shape "); Put_Line( file.shapestr.all );
   --npy.dict.Show(file.dict);
   npy.dict.Show(file.shape);
  end Show ;

end npy;