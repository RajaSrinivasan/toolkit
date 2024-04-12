package images is
   function Image( format : String ; value : Integer ) return String;
   function Image( format : String ; value : float ) return String;
   function Image( format : String ; value : Long_Float ) return String ;
end images ;
