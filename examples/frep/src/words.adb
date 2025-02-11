with Ada.Text_Io; use Ada.Text_Io;
with Ada.Command_Line; use Ada.Command_Line;
with GNAT.RegPat; use GNAT.RegPat;

procedure words is
   f : File_Type ;
   fn : constant String := Argument(1) ;
   line : String(1..512);
   linelen : Natural ;
   wordpat : constant Pattern_Matcher := Compile( "[a-zA-Z]+") ;
   keywordpat : constant Pattern_Matcher :=
      Compile(
         "procedure|" &
         "begin|" &
         "end|" &
         "function|" &
         "with|" &
         "use|" &
         "constant|" &
         "string|" &
         "loop"
         , Case_Insensitive );
   procedure BreakDown( l : String ) is
      Matches : Match_Array (0 .. 0);
      Current : Natural := l'First;
   begin
      loop
         Match (wordpat, l , Matches, Current );
         exit when Matches (0) = No_Match;
         if Match(keywordpat,l(Matches(0).First..Matches(0).Last))
         then
            Put_Line( l(Matches(0).First..Matches(0).Last) );
         end if ;
         Current := Matches (0).Last + 1;
      end loop;
   end BreakDown;
begin
   Open(f,In_FIle,fn);
   while not End_Of_File(f)
   loop
      Get_Line( f , line , linelen );
      BreakDown( line(1..linelen) );
   end loop ;
   Close(f);
end words ;