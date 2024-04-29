with Ada.Text_IO;         use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Strings.Fixed ;
with Ada.Directories ;

with GNAT.OS_Lib ;
with GNAT.Command_Line;
with GNAT.Source_Info; use GNAT.Source_Info;

package body cli is

   package boolean_text_io is new Enumeration_IO (Boolean);
   use boolean_text_io;
   
   comp_date : constant String := GNAT.Source_Info.Compilation_Date ;
   comp_time : constant String := GNAT.Source_Info.Compilation_Time ;
    procedure Show_Arguments is 
    begin
        Put("Port "); Put(port); New_Line ;
        Put("logname "); Put(To_String(logname)); New_Line ;
        Put("logdir "); Put(To_String(logdir)); New_Line ;
    end Show_Arguments;

   procedure SwitchHandler
     (Switch : String; Parameter : String; Section : String)
   is
   begin
      Put ("SwitchHandler " & Switch);
      Put (" Parameter " & Parameter);
      Put (" Section " & Section);
      New_Line;
   end SwitchHandler;

   usagestr : constant String :=
     "dglogs port_number logfilenamepattern targetdir" ;
     
   procedure ProcessCommandLine is
      Config : GNAT.Command_Line.Command_Line_Configuration;
   begin
        GNAT.Command_Line.Set_Usage
            (Config,
         Help =>
            NAME & " " & VERSION & " " & comp_date & " " & comp_time & usagestr);

        GNAT.Command_Line.Initialize_Option_Scan(Stop_At_First_Non_Switch => true );
        GNAT.Command_Line.Define_Switch
            (Config, Verbosity'access, Switch => "-v:", Long_Switch => "--verbosity:",
            Help                           => "Verbosity Level");

        GNAT.Command_Line.Getopt (Config, SwitchHandler'access);
            
        port := Integer'Value (GetNextArgument);
        logname := To_Unbounded_String( GetNextArgument );
        logdir := To_Unbounded_String( GetNextArgument );

        if Verbosity >= 1
        then
            Show_Arguments ;
        end if ;
    exception
        when others =>
            Put(usagestr); New_Line;
   end ProcessCommandLine;

   function GetNextArgument return String is
      nextarg : String := GNAT.Command_Line.Get_Argument( Do_Expansion => False ) ;
   begin
      return nextarg ;
   end GetNextArgument;
 

end cli;