--with Ada.Numerics.Elementary_Functions ;

package body numlib is
   function Convert (a : RealArray) return Vector is
      result : Vector;
      idx    : Integer := a'First;
      procedure Copy (c : Cursor) is
      begin
         Replace_Element (result, c, a (idx));
         idx := idx + 1;
      end Copy;
   begin
      result.Set_Length (a'Length);
      result.Iterate (Copy'Access);
      return result;
   end Convert;
   function Convert (v : Vector) return RealArray is
      result : RealArray (1 .. Integer (Length (v)));
      ptr    : Integer := 0;
      procedure Copy (c : Cursor) is
      begin
         ptr          := ptr + 1;
         result (ptr) := Element (c);
      end Copy;
   begin
      v.Iterate (Copy'Access);
      return result;
   end Convert;

   function Create
     (length : Natural; default : RealType := RealType'First) return Vector
   is
      result : Vector;
   begin
      result := To_Vector (default, Ada.Containers.Count_Type (length));
      return result;
   end Create;

   -- codemd: begin segment=Create caption=Basic Creation
   function Create (from : Vector) return Vector is
      result : Vector;
   begin
      result := To_Vector (0.0, from.Length);
      Add (result, from);
      return result;
   end Create;

   function Create (length : Natural; low, high : RealType) return Vector is
      result : Vector            := Create (length);
      val    : RealType          := low;
      vdelta : constant RealType := (high - low) / Float (length - 1);
   begin
      for idx in 0 .. length - 1 loop
         result.Replace_Element (idx, val);
         val := val + vdelta;
      end loop;
      return result;
   end Create;
   -- codemd: end

   function Create (low, high, step : RealType) return Vector is
      result : Vector;
      val    : RealType := low;
   begin
      while val <= high loop
         result.Append (val);
         val := val + step;
      end loop;
      return result;
   end Create;

   -- codemd: begin segment=Populate caption=populate with a custom data generator
   function Create
     (length   : Natural;
      populate : not null access function
        (length, idx : Natural) return RealType)
      return Vector
   is
      use type Ada.Containers.Count_Type;
      result : Vector;
   begin
      result.Set_Length (Ada.Containers.Count_Type (length));
      for idx in 0 .. length - 1 loop
         Replace_Element (result, idx, populate (length, idx));
      end loop;
      return result;
   end Create;
   -- codemd: end

   procedure Set (v : in out Vector; value : RealType) is
      procedure Set (c : Cursor) is
      begin
         Replace_Element (v, c, value);
      end Set;
   begin
      v.Iterate (Set'Access);
   end Set;

   procedure Print
     (v    : Vector; sep : String := ","; linelen : Positive_Count := 80;
      dest : File_Type := Standard_Output)
   is
      procedure Print (c : Cursor) is
      begin
         if Col (dest) > linelen then
            New_Line (dest);
         end if;
         Put (Element (c)'Image);
         Put (sep);
      end Print;
   begin
      v.Iterate (Print'Access);
   end Print;

   function Append (v1 : Vector; v2 : Vector) return Vector is
      use type Ada.Containers.Count_Type;
      result : Vector;
      procedure Append (c : Cursor) is
         tidx : constant Extended_Index := To_Index (c);
         fidx : Extended_Index; -- := tidx - Extended_Index(v1.Length) ;
      begin
         if tidx >= Extended_Index (v1.Length) then
            fidx := tidx - Extended_Index (v1.Length);
            Replace_Element (result, c, v2.Element (fidx));
         else
            Replace_Element (result, c, v1.Element (tidx));
         end if;
      end Append;
   begin
      result.Set_Length (v1.Length + v2.Length);
      result.Iterate (Append'Access);
      return result;
   end Append;

   function Rev (v : Vector) return Vector is
      result : Vector := To_Vector (v.Length);
      procedure RevCopy (c : Cursor) is
         idx   : constant Extended_Index := To_Index (c);
         toidx : constant Extended_Index :=
           Extended_Index (v.Length) - idx - 1;
      begin
         Replace_Element (result, toidx, Element (c));
      end RevCopy;
   begin
      v.Iterate (RevCopy'Access);
      return result;
   end Rev;

   procedure Add (v : in out Vector; value : RealType) is
      procedure Add (c : Cursor) is
      begin
         Replace_Element (v, c, value + Element (c));
      end Add;
   begin
      v.Iterate (Add'Access);
   end Add;

   procedure Sub (v : in out Vector; value : RealType) is
      procedure Sub (c : Cursor) is
      begin
         Replace_Element (v, c, value - Element (c));
      end Sub;
   begin
      v.Iterate (Sub'Access);
   end Sub;

   procedure Mult (v : in out Vector; value : RealType) is
      procedure Mult (c : Cursor) is
      begin
         Replace_Element (v, c, value * Element (c));
      end Mult;
   begin
      v.Iterate (Mult'Access);
   end Mult;

   procedure Div (v : in out Vector; value : RealType) is
      procedure Div (c : Cursor) is
      begin
         Replace_Element (v, c, value / Element (c));
      end Div;
   begin
      v.Iterate (Div'Access);
   end Div;

   procedure Add (v : in out Vector; value : Vector) is
      procedure add (c : Cursor) is
         idx : constant Extended_Index := To_Index (c);
      begin
         Replace_Element (v, c, Element (c) + Element (value, idx));
      end add;
   begin
      v.Iterate (add'Access);
   end Add;

   procedure Sub (v : in out Vector; value : Vector) is
      procedure sub (c : Cursor) is
         idx : constant Extended_Index := To_Index (c);
      begin
         Replace_Element (v, c, Element (c) - Element (value, idx));
      end sub;
   begin
      v.Iterate (sub'Access);
   end Sub;

   procedure Mult (v : in out Vector; value : Vector) is
      procedure Mult (c : Cursor) is
         idx : constant Extended_Index := To_Index (c);
      begin
         Replace_Element (v, c, Element (c) * Element (value, idx));
      end Mult;
   begin
      v.Iterate (Mult'Access);
   end Mult;

   procedure Div (v : in out Vector; value : Vector) is
      procedure Div (c : Cursor) is
         idx : constant Extended_Index := To_Index (c);
      begin
         Replace_Element (v, c, Element (c) / Element (value, idx));
      end Div;
   begin
      v.Iterate (Div'Access);
   end Div;

   function sum (v : Vector) return RealType is
      result : RealType := 0.0;
      procedure sum (c : Cursor) is
      begin
         result := result + Element (c);
      end sum;
   begin
      v.Iterate (sum'Access);
      return result;
   end sum;

   procedure Mutate
     (v        : in out Vector;
      modifier : not null access function (value : RealType) return RealType)
   is
      procedure Mutate (c : Cursor) is
      begin
         Replace_Element (v, c, modifier (Element (c)));
      end Mutate;
   begin
      v.Iterate (Mutate'Access);
   end Mutate;

   function Mutate
     (v        : Vector;
      modifier : not null access function (value : RealType) return RealType)
      return Vector
   is
      result : Vector := Create (v);
      procedure Mutate (c : Cursor) is
      begin
         Replace_Element
           (result, result.To_Cursor (To_Index (c)), modifier (Element (c)));
      end Mutate;
   begin
      v.Iterate (Mutate'Access);
      return result;
   end Mutate;

end numlib;
