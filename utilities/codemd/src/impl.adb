with Ada.Text_IO; use Ada.Text_IO;

with Ada.Strings.Fixed;       use Ada.Strings.Fixed;
with Ada.Strings.Unbounded;   use Ada.Strings.Unbounded;
with Ada.Characters.Handling; use Ada.Characters.Handling;

with cli;
with GNAT.OS_Lib; use GNAT.OS_Lib;
with GNAT.Directory_Operations; use GNAT.Directory_Operations;

with GNAT.Regpat; use GNAT.Regpat;
with GNAT.Expect;

package body impl is
   use GNAT.Strings;
   -- codemd: begin segment=patterns 
   cmdid      : constant String := "codemd" & ":";
   beginpat   : constant Pattern_Matcher :=
     Compile (cmdid & " +begin" & " +segment=([a-zA-Z0-9]+)");
   endpat     : constant Pattern_Matcher := Compile (cmdid & " +end");
   skippat    : constant Pattern_Matcher := Compile (cmdid & " +skipbegin");
   skipendpat : constant Pattern_Matcher := Compile (cmdid & " +skipend");
   -- codemd: end

   strpat     : constant Pattern_Matcher := Compile ('"' & ".+" & '"');
   wordpat    : constant Pattern_Matcher := Compile ("[a-zA-Z_]+");
   keywordpat : constant Pattern_Matcher :=
     Compile
       ("procedure|begin|end|function|with|use|if|then|else",
        GNAT.Regpat.Case_Insensitive);

   function KeywordMarkup (txt : String) return String is
   begin
      if Match (keywordpat, txt) then
         return txt;
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

   function pretty (txt : String) return String renames Markup;

   function ZeroPrefixed (val : Integer; length : Integer := 4) return String
   is
      valimg : constant String := Integer'Image (val);
      pfx    : constant String (1 .. length) := (others => '0');
   begin
      return pfx (1 .. length - valimg'Length + 1) & valimg (2 .. valimg'Last);
   end ZeroPrefixed;

   procedure Emit_Line (lineno : Integer; line : String) is
   begin
      Put (ZeroPrefixed (lineno));
      Put (" | ");
      Put_Line (pretty (line));
   end Emit_Line;

   procedure Emit_Prolog
     (caption : GNAT.Strings.String_Access; inputfilename : String) is
   begin
      Put ("**");
      if caption.all'Length /= 0 then
         Put ("Caption: ");
         Put (caption.all);
         Put (" ");
      end if;
      Put (inputfilename);
      Put ("**");
      New_Line;
      Put_Line ("``` {style=""background-color: beige; color:steel-blue""}");

   end Emit_Prolog;

   procedure Emit_Segment_Prolog
     (segname : String; 
      caption : GNAT.Strings.String_Access; 
      inputfilename : String) is
   begin

      Put("```{.ada .bg-beige #lst-patterns lst-cap=");
      Put('"');
      Put(segname);
      Put('"');
      Put_Line("}");

   end Emit_Segment_Prolog;

   procedure Emit_Epilog is
   begin
      Put_Line ("```");
   end Emit_Epilog;

   procedure Emit_Segment_Epilog( hdr : String) is
   begin
      Put_Line ("```");
      Put_Line( hdr ) ;
      Put_Line (":::");
   end Emit_Segment_Epilog;

   procedure Extract
     (inputfilename : String;
      segment       : String := "*";
      caption       : GNAT.Strings.String_Access := null)
   is
      inpfile    : File_Type;
      inpline    : String (1 .. 512);
      inplinelen : Natural;
      lineno     : Integer := 0;
      segspec    : Match_Array (0 .. 2);
      output_dir : GNAT.Strings.String_Access := cli.output_dir ;

      procedure Skip_Segment is
      begin
         while not End_Of_File (inpfile) loop
            Get_Line (inpfile, inpline, inplinelen);
            lineno := lineno + 1;
            if Match (endpat, inpline (1 .. inplinelen)) then
               return;
            end if;
         end loop;
      end Skip_Segment;

      procedure Skip_Section is
      begin
         while not End_Of_File (inpfile) loop
            Get_Line (inpfile, inpline, inplinelen);
            lineno := lineno + 1;
            if Match (skipendpat, inpline (1 .. inplinelen)) then
               return;
            end if;
         end loop;
      end Skip_Section;

      --codemd: begin segment=Segment caption=Process_Segment
      procedure Process_Segment is
         listfile : File_Type;
         segname : constant String := inpline (segspec (1).First .. segspec (1).Last) ;
      begin
         if segment = "*" then
            Create( listfile , Out_File, output_dir.all & 
                                         GNAT.Directory_Operations.Dir_Separator & 
                                         segname &
                                         ".md");
            Set_Output(listfile);
         end if;
         Emit_Segment_Prolog (segname , caption , inputfilename);
         while not End_Of_File (inpfile) loop
            Get_Line (inpfile, inpline, inplinelen);
            lineno := lineno + 1;
            if Match (endpat, inpline (1 .. inplinelen)) then
               if segment = "*" then
                  Emit_Epilog ;
                  Close (listfile);
                  Set_Output (Standard_Output);
               end if;
               return;
            elsif Match (skippat, inpline (1 .. inplinelen)) then
               New_Line;
               Put_Line ("...skipped...");
               Skip_Section;
               New_Line;
            else
               Emit_Line (lineno, inpline (1 .. inplinelen));
            end if;
         end loop;
         Emit_Epilog;
      end Process_Segment;
 
      --codemd: end
   begin
      --codemd: begin segment=Process
      --Put_Line(inputfilename);
      if segment="*" then
         if cli.output_dir.all'Length = 0 then
            Put ("No output directory specified, using current directory");
            output_dir := new String'(GNAT.Directory_Operations.Get_Current_Dir);
            Put_Line ("Current directory is " & output_dir.all);
         end if;
      end if ;

      Open (inpfile, In_File, inputfilename);

      while not End_Of_File (inpfile) loop
         Get_Line (inpfile, inpline, inplinelen);
         lineno := lineno + 1;
         --codemd: skipbegin
         Match (beginpat, inpline (1 .. inplinelen), segspec);
         if segspec (0) /= No_Match then
            if segment = inpline (segspec (1).First .. segspec (1).Last)
              or segment = "*"
            then
               Process_Segment;
            else
               Skip_Segment;
            end if;
         end if;
         --codemd: skipend
      end loop;
      Close (inpfile);
      Emit_Epilog;
      --codemd: end
   end Extract;

   procedure Extract
     (inputfilename : String;
      lineno_from   : Integer;
      linecount     : Integer;
      caption       : GNAT.Strings.String_Access := null)
   is

      inpfile    : File_Type;
      inpline    : String (1 .. 512);
      inplinelen : Natural;
      lineno     : Integer := 0;
      count      : Integer := 0;

   begin
      Open (inpfile, In_File, inputfilename);
      Emit_Prolog (caption, "Reference : " & inputfilename);
      while not End_Of_File (inpfile) loop
         Get_Line (inpfile, inpline, inplinelen);
         lineno := lineno + 1;
         if lineno >= lineno_from then
            Emit_Line (lineno, inpline (1 .. inplinelen));
            count := count + 1;
            if count >= linecount then
               exit;
            end if;
         end if;
      end loop;
      Close (inpfile);
      Emit_Epilog;
   end Extract;

   function Get_Line
     (str : in out Ada.Strings.Unbounded.Unbounded_String) return String
   is
      strstr : constant String := To_String (str);
      ptr    : Integer := 1;
      eolptr : Integer;
   begin
      while ptr <= strstr'Last loop
         if Is_Line_Terminator (strstr (ptr)) then
            exit;
         end if;
         ptr := ptr + 1;
      end loop;
      if ptr > strstr'Last then
         str := Null_Unbounded_String;
         return strstr;
      end if;
      eolptr := ptr - 1;
      while ptr <= strstr'Last loop
         if not Is_Line_Terminator (strstr (ptr)) then
            str := To_Unbounded_String (strstr (ptr .. strstr'last));
            return strstr (1 .. eolptr);
         end if;
         ptr := ptr + 1;
      end loop;
      str := Null_Unbounded_String;
      return strstr (1 .. eolptr);

   end Get_Line;

   procedure Execute
     (command : String; lineno_from : Integer := 0; linecount : Integer := 0)
   is

      argidx    : Integer;
      arglist   : Argument_List_Access;
      cmdStatus : aliased Integer;
   begin
      argidx := Index (command, " ");
      if argidx = 0 then
         argidx := command'Last + 1;
         arglist := Argument_String_To_List ("");
      else
         arglist :=
           Argument_String_To_List (command (argidx + 1 .. command'last));
      end if;

      declare
         result : Unbounded_String :=
           To_Unbounded_String
             (GNAT.Expect.Get_Command_Output
                (command (command'First .. argidx - 1),
                 arglist.all,
                 "",
                 cmdstatus'access));
         lineno : Integer := 0;
         showed : Integer := 0;
      begin
         Emit_Prolog (cli.caption, "Command : " & command);
         loop
            lineno := lineno + 1;
            if linecount > 0 then
               if lineno >= lineno_from then
                  Emit_Line (lineno, Get_Line (result));
                  showed := showed + 1;
                  if showed > linecount then
                     exit;
                  end if;
               end if;
            else
               Emit_Line (lineno, Get_Line (result));
            end if;
            if Length (result) < 1 then
               exit;
            end if;
         end loop;
         Emit_Epilog;
      end;
   end Execute;

end impl;
