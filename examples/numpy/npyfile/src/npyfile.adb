with Ada.Command_Line ; use Ada.Command_Line;
with npy ;

procedure Npyfile is
   f : npy.File_Type ;
begin
   f := npy.Open( Argument(1) );
   npy.Show(f);
   
end Npyfile;
