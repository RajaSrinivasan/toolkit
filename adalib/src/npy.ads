with System ;
with Ada.Streams ; use Ada.Streams;
with Ada.Streams.Stream_Io ; use Ada.Streams.Stream_Io;
with Ada.Strings.Unbounded ; use Ada.Strings.Unbounded;
with Ada.Containers.Vectors; 

with GNAT.Strings ;

package npy is

   magic : constant String :=
      character'val( 16#93# ) &
      "NUMPY" ;

   function ntoh( v : Short_Integer ) return Short_Integer ;
   Pragma Import(C,ntoh) ;

   type header is
   record
      m : String( magic'range ) ;
      major_v : Stream_Element ;
      minor_v : Stream_Element ;
   end record ;
   pragma convention(C,header);

   type endian_tag is
   (
      little ,
      big ,
      native ,
      irrelevant
   ) ;

   type endian_tag_codes is 
      ('<' ,
       '>' ,
       '=' ,
       '|' 
   ) ;

   type data_type is
   (
      bool ,
      signed_integer ,
      unsigned_integer ,
      floating ,
      complex_floating ,
      timedelta ,
      datetime ,
      object ,
      byte_string ,
      unicode_string ,
      raw_data
   ) ;

   type data_type_codes is
   (
      'b', 
      'i', 
      'u', 
      'f', 
      'c', 
      'm', 
      'M', 
      'O', 
      'S', 
      'U', 
      'V' );

   type File_Type is private ;

   FORMAT_ERROR : exception ;
   function Open( name : String ) return File_Type;
   procedure Close( file : File_Type );
   procedure Show( file : File_Type );

   type dictentry is
   record
      name : Unbounded_String ;
      value : Unbounded_String ;
   end record ;

   package dict_pkg is new Ada.Containers.Vectors( Natural , dictentry );
   subtype Dictionary is dict_pkg.Vector ;

   package shape_pkg is new Ada.Containers.Vectors( Natural , Integer);
   subtype Shape is shape_pkg.Vector ;

   private 
      type File_Type is
      record
         stream : access Ada.Streams.Stream_Io.File_Type ;
         major_v : Stream_Element ;
         minor_v : Stream_Element ;
         header : GNAT.Strings.String_Access ;
         dict : Dictionary ;
         DataShape : Shape ;
      end record ;

end npy ;