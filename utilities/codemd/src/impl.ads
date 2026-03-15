with GNAT.Strings;

package impl is
   verbose : Boolean := True;
   procedure Extract
     (inputfilename : String;
      segment       : String := "*";
      caption       : GNAT.Strings.String_Access := null);

   procedure Extract
     (inputfilename : String;
      lineno_from   : Integer;
      linecount     : Integer;
      caption       : GNAT.Strings.String_Access := null);

   procedure Execute
     (command : String; lineno_from : Integer := 0; linecount : Integer := 0);

end impl;
