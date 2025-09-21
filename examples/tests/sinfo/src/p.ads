with gnat.source_info ;
package p is
   package si renames GNAT.Source_Info ;
   procedure show( e : String := si.Enclosing_Entity ; l : Positive := si.Line );
   --procedure show ;
end p ;