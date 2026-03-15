package body md is

   function Transform (t : String; m : Markup) return String is
   begin
      if (m and Bold) /= 0 then
         return "**" & t & "**";
      end if;
      return t;
   end Transform;

end md;
