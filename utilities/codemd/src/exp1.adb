with Ada.Command_Line; use Ada.Command_Line;
with Ada.Text_Io;      use Ada.Text_Io;

with GNAT.Regpat; use GNAT.Regpat;


  procedure exp1
is
   fn     : constant String := Argument (1);
   txt    : String (1 .. 256);
   txtlen : Natural;

   strpat     : constant Pattern_Matcher := Compile ('"' & ".+" & '"');
   wordpat    : constant Pattern_Matcher := Compile ("[a-zA-Z_]+");
   keywordpat : constant Pattern_Matcher :=
     Compile
       ("procedure|begin|end|function|with|use|if|then|else",
        GNAT.Regpat.Case_Insensitive);

   function KeywordMarkup (txt : String) return String is
   begin
      if Match (keywordpat, txt) then
         return "##" & txt & "##";
      end if;
      return txt;
   end KeywordMarkup;

   function Markup (txt : String) return String is

      Matches : Match_Array (0 .. 0);
   begin
      loop
         Match (wordpat, txt, Matches, txt'First);
         if Matches (0) = No_Match then
            return txt;
         end if;
         return
           txt (txt'first .. Matches (0).First - 1)
           & KeywordMarkup (txt (Matches (0).First .. Matches (0).Last))
           & Markup (txt (Matches (0).Last + 1 .. txt'Last));
      end loop;
   end Markup;

   function pretty (txt : String) return String is
      Matches : Match_Array (0 .. 0);
   begin
      Match (strpat, txt, Matches, txt'first);
      if Matches (0) = No_Match then
         return Markup (txt);
      end if;
      if Matches (0).First = txt'First then
         declare
            str : constant String :=
              txt (Matches (0).First .. Matches (0).Last);
         begin
            if Matches (0).Last = txt'Last then
               return str;
            end if;
            return str & Markup (txt (Matches (0).Last .. txt'Last));
         end;
      end if;
      declare
         left : constant String := txt (txt'First .. Matches (0).First - 1);
         str  : constant String := txt (Matches (0).First .. Matches (0).Last);
      begin
         if Matches (0).last = txt'Last then
            return Markup (left) & str;
         end if;
         return
           Markup (left) & str & Markup (txt (Matches (0).Last .. txt'Last));
      end;
   end pretty;

   procedure pretty (line : String) is
   begin
      Put (pretty (line));
      New_Line;
   end pretty;

   f : File_Type;
begin
   Open (f, In_File, fn);
   while not End_Of_File (f) loop
      Get_Line (f, txt, txtlen);
      if txtlen > 0 then
         pretty (txt (1 .. txtlen));
      else
         pretty ("");
      end if;
   end loop;
   Close (f);
end exp1;
