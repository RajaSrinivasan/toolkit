package impl is

   procedure Search (filename : String; candidate : String);
   procedure Replace
     (filename  : String; candidate : String; replacement : String;
      outputdir : String);

   procedure SearchRegEx (filename : String; candidate : String);
   procedure ReplaceRegEx
     (filename  : String; candidate : String; replacement : String;
      outputdir : String);

end impl;
