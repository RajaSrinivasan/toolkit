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


   function ValueType( f : File_Type ) return data_type is
      dtypec : character := f.descr.all(4) ;
   begin
      case dtypec is
         when 'b' => return bool ; 
         when 'i' => return signed_integer ; 
         when 'u' => return unsigned_integer ; 
         when 'f' => return floating ; 
         when 'c' => return complex_floating ;
         when 'm' => return timedelta ;
         when 'M' => return datetime ;
         when 'O' => return object ;
         when 'S' => return byte_string ;
         when 'U' => return unicode_string ; 
         when 'V' => return raw_data ;
         when others => raise FORMAT_ERROR ;
      end case ;
   end ValueType ;


   function ElementSize( f : file_Type ) return Integer is
      esize : Integer ;
   begin
      esize := Integer'Value(f.descr.all(5..5)) ;
      return esize ;
   end ElementSize ;

   function ValueSize( f : File_Type )  return Stream_Element_Count is
      vsize : Stream_Element_Count ;
      procedure Count( c : Shape_Pkg.Cursor ) is
         n : Integer := Shape_Pkg.Element(c) ;
      begin
         vsize := vsize * Stream_Element_Count(n) ;
      end Count ;
   begin
      vsize := 1 ;
      f.shape.Iterate( Count'access );
      return vsize * Stream_Element_Count(ElementSize (f)) ;
   end ValueSize;
   
   function Values( f : File_Type ) return ValuesPtr_Type is
      result : ValuesPtr_Type := new Stream_Element_Array( 1..ValueSize(f) );
      count : Stream_Element_Count ;
   begin
      Read( f.stream.all , result.all , count );
      return result ;
   end Values ;

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