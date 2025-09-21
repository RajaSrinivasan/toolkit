-- codemd: begin segment=Library caption=Predefined Library Support
with Ada.Text_IO;      use Ada.Text_IO;
with Ada.Command_Line; use Ada.Command_Line;
with Ada.Strings.Fixed;

with GNAT.Source_Info; use GNAT.Source_Info;
-- codemd: end

procedure fileio is

   verbose         : constant Boolean := True;
   myname          : constant String  := Enclosing_Entity;
   MAX_LINE_LENGTH : constant         := 256;
   procedure linecount is
      use Ada;
      myname : constant String := Enclosing_Entity;
      procedure linecount (fn : String) is
         txtfile    : Text_IO.File_Type;
         line       : String (1 .. MAX_LINE_LENGTH);
         linelength : Natural;
         num_lines  : Integer := 0;
      begin
         Text_IO.Open (txtfile, Text_IO.In_File, fn);
         while not Text_IO.End_Of_File (txtfile) loop
            Get_Line (txtfile, line, linelength);
            num_lines := num_lines + 1;
         end loop;
         Close (txtfile);
         Put ("File ");
         Put (fn);
         Put (" has ");
         Put (num_lines'Image);
         Put_Line (" lines");
      end linecount;
   begin
      if verbose then
         Put_Line (myname);
      end if;
      for f in 2 .. Argument_Count loop
         linecount (Argument (f));
      end loop;
   end linecount;

   procedure list is
      myname : constant String := Enclosing_Entity;
      use Ada.Text_IO;
      procedure list (fn : String) is
         txtfile     : File_Type;
         line        : String (1 .. MAX_LINE_LENGTH);
         linelength  : Natural;
         line_number : Integer := 0;
      begin
         Put ("*****");
         Put_Line (fn);
         Open (txtfile, In_File, fn);
         while not End_Of_File (txtfile) loop
            Get_Line (txtfile, line, linelength);
            line_number := line_number + 1;
            Put (line_number'Image);
            Set_Col (8);
            Put (" : ");
            Put_Line (line (1 .. linelength));
         end loop;
         Close (txtfile);
         Put_Line ("***** End of File ******");
      end list;
   begin
      if verbose then
         Put_Line (myname);
      end if;
      for f in 2 .. Argument_Count loop
         list (Argument (f));
      end loop;
   end list;

   procedure search is
      myname : constant String := Enclosing_Entity;
      use Ada;
      use Text_IO;
      procedure search (fn : String; arg : String) is
         txtfile     : File_Type;
         line        : String (1 .. MAX_LINE_LENGTH);
         linelength  : Natural;
         line_number : Integer := 0;
         argpos      : Natural;
         count       : Natural := 0;
      begin
         Put ("*****");
         Put_Line (fn);
         Open (txtfile, In_File, fn);
         -- codemd: begin segment=ReadLines caption=Line oriented file input
         while not End_Of_File (txtfile) loop
            Get_Line (txtfile, line, linelength);
            line_number := line_number + 1;
            argpos := Strings.Fixed.Index (line (1 .. linelength), arg, 1);
            if argpos > 0 then
               count := count + 1;
               Put (line_number'Image);
               Set_Col (8);
               Put (" : ");
               Put_Line (line (1 .. linelength));
            end if;
         end loop;
         -- codemd: end
         Close (txtfile);
         Put ("***** Found ");
         Put (count'Image);
         Put_Line (" instances");
      end search;
   begin
      if verbose then
         Put_Line (myname);
      end if;
      if Argument_Count < 3 then
         Put_Line ("Search argument is missing");
      end if;
      for f in 3 .. Argument_Count loop
         search (Argument (f), Argument (2));
      end loop;
   end search;

begin
   if verbose then
      Put_Line (myname);
   end if;
   -- codemd: begin segment=Command caption=Command Line Handling
   if Argument_Count >= 1 then
      declare
         operation : constant String := Argument (1);
      begin
         if operation = "lc" or operation = "linecount" then
            linecount;
         elsif operation = "ls" or operation = "list" then
            list;
         elsif operation = "find" or operation = "search" then
            search;
         else
            Put (operation);
            Put_Line (" is not a supported command");
         end if;
      end;
      -- codemd: end
   else
      Put_Line ("usage: fileio [lc|ls|find] file1 file2 ...");
   end if;
end fileio;
