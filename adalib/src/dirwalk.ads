generic
   type context_type is private;
procedure dirwalk
  (context   : context_type; dirname : String; pattern : String;
   processor : access procedure
     (context : context_type; filename : in String));
