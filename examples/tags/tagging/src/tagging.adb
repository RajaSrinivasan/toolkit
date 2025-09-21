with Ada.Text_IO; use Ada.Text_IO;
with Ada.Tags; use Ada.Tags;

with p ;
procedure Tagging is
begin
   Put_Line("Package p type T1 ");
   Put("Expanded_Name: ");
   Put_Line( Expanded_Name( p.T1'Tag) );
   Put("External_Tag: ");
   Put_Line( External_Tag( p.T1'Tag) );
   -- put_line( Expanded_Name(Descendant_Tag( "field1" , p.T1'Tag )));


   Put_Line("Package p.s type ST1 ");
   Put("Expanded_Name: ");
   Put_Line( Expanded_Name( p.s.ST1'Tag) );
   Put("External_Tag: ");
   Put_Line( External_Tag( p.s.ST1'Tag) );

end Tagging;
