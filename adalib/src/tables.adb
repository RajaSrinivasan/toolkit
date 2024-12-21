package body tables is

   function "=" (Left,Right : Ada.Calendar.Time) return boolean is
      use Ada.Calendar ;
   begin
      if Left < Right
      then
         return false ;
      elsif Left > Right
      then
         return false ;
      else
         return true ;
      end if ;
   end "=" ;
   package body ColumnPkg is
      use ColumnValues_Pkg ;
      function Get( col : TColumnType ; idx : Natural) return T is
      begin
         return Element( col.Values, idx );
      end Get ;

      procedure Set( col : in out TColumnType ; idx : Natural ; value : String ) is
         v : T ;
      begin
         v := Vfun(value);
         Replace_Element( col.values , idx , v );
      end Set ;

     procedure Append( col : in out TColumnType ; value : String ) is
         v : T ;
      begin
         v := Vfun(value);
         Append( col.values , v );
      end Append ;

      function Image( col : in out TColumnType ; idx : Natural ) return String is
      begin
         return Ifun( Element(col.Values,idx)) ;
      end Image ;

      function Create( name : String ) return ColPtrType is
         result : ColPtrType := new TColumnType ;
      begin
         result.name := To_Unbounded_String(name);
         return result ;
      end Create ;
      function Length( col : TColumnType ) return Natural is
      begin
         return Natural(col.Values.Length) ;
      end Length ;
      procedure Remove( col : in out TColumnType ; idx : Natural ) is
      begin
         col.Values.Delete( idx );
      end Remove ;

   end ColumnPkg ;

   use Ada.Strings.Unbounded ;
   function CreateStringColumn( name : String ) return ColPtrType is
      result : ColPtrType := new StringColumnType ;
   begin
      result.name := To_Unbounded_String(name);
      return result ;
   end CreateStringColumn ;
   function Length( col : StringColumnType ) return Natural is
   begin
      return Natural(col.Values.Length) ;
   end Length ;
   procedure Remove( col : in out StringColumnType ; idx : Natural ) is
   begin
      col.Values.Delete( idx );
   end Remove ;

   function Get( col : StringColumnType ; idx : Natural) return String is
   begin
      return To_String(col.Values.Element(idx)) ;
   end Get ;

   procedure Set( col : in out StringColumnType ; idx : Natural ; value : String ) is
   begin
      StringColumnValues_Pkg.Replace_Element( col.Values , idx , To_Unbounded_String(value)) ;
   end Set ;

   procedure Append( col : in out StringColumnType ; value : String ) is
   begin
      StringColumnValues_Pkg.Append( col.Values , To_Unbounded_String(value)) ;
   end Append ;

   function Image( col : in out StringColumnType ; idx : Natural ) return String is
   begin
      return Get( col , idx );
   end Image ;

   procedure Load( filename : String ; table : in out TableType; sep : String := ";") is separate ;

   procedure Save( filename : String ; table : TableType ; sep : String := ";" ) is
   begin
      null ;
   end Save ;

   function Rows( table : TableType ) return Natural is
   begin
      return TablePkg.Element(table,0).Length ;
   end Rows ;

   function Columns( table : TableType ) return Natural is
   begin
      return Natural(table.Length) ;
   end Columns ;  

   procedure Iterate( table : TableType ;
                      proc : not null access procedure (table : TableType ;
                                                    rownum : Natural)) is
   begin
      for rn in 0..Rows(table)-1
      loop
         proc( table , rn );
      end loop ;
   end Iterate ;

   procedure Mutate( table : in out TableType ;
                     col : in out ColPtrType ;
                     proc : not null access procedure (table : in out TableType ;
                                                       rownum : Natural ;
                                                       col : in out ColPtrType )) is
   begin
      for rn in 0..Rows(table)-1
      loop
         proc( table , rn , col );
      end loop ;
      table.Append(col);
   end Mutate ;

   
   procedure Filter( table : in out TableType ;
                     remove : not null access function (table : in out TableType ;
                                                       rownum : Natural ) return boolean ) is
      cp : ColPtrType ;
   begin
         for rn in 0..Rows(table)-1
      loop
         if remove( table , rn )
         then
            for cn in 0..Columns(table)-1
            loop
               cp := table.Element(cn);
               cp.Remove( cn );
            end loop ;
         end if ;
      end loop ;
   end Filter ;

end tables ;
