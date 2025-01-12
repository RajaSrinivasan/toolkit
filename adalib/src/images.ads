package images is
   function Image (format : String; value : Integer) return String;
   function Image (format : String; value : Float) return String;
   function Image (format : String; value : Long_Float) return String;
   function Image (format : String; value : String) return String;
end images;
