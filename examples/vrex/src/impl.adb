with Ada.Text_Io; use Ada.Text_Io ;
with GNAT.RegExp ;

package body impl is
    MAX_LENGTH : constant := 256 ;
    function Matches( pattern : String ; line : String ;
                      glob : boolean := false ; caseinsensitive : boolean := false ) return boolean is
        exp : GNAT.RegExp.RegExp := GNAT.RegExp.Compile( pattern , glob , not caseinsensitive );
    begin
        return GNAT.RegExp.Match( line , exp  );
    end Matches ;

    pcompiled : access GNAT.RegExp.RegExp ;
    procedure Matches( pattern : String ; filename : String ;
                       glob : boolean := false ; 
                       caseinsensitive : boolean := false) is
        file : File_Type ;
        line : String(1..MAX_LENGTH);
        linelength : Natural ;
        lineno : Natural := 0 ;
        count : Natural := 0 ;
    begin
        if pcompiled = null
        then
            pcompiled := new Gnat.RegExp.RegExp ;
            pcompiled.all := Gnat.RegExp.Compile( pattern , glob , not caseinsensitive );
        end if ;

        Put("Pattern "); Put(pattern); Put(" ");
        Put_Line(filename);
        Open(file,In_File,filename);
        while not End_Of_File(file)
        loop
            Get_Line(file,line,linelength);
            lineno := lineno + 1 ;
            if GNAT.RegExp.Match( line(1..linelength) , pcompiled.all  )
            then
                count := count + 1 ;
                Put(lineno'Image);
                Set_Col(8);
                Put(": ");
                Put_Line(line(1..linelength));
            end if ;
        end loop ;
        Close(file);
        Put(count'Image);
        Put_Line(" lines matched");
    end Matches ;

end impl ;
