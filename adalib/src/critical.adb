package body critical is

   allocate : AllocatorType;

   procedure SetAllocators (a : not null AllocatorType) is
   begin
      allocate := a;
   end SetAllocators;

   --codemd: begin segment=GetSet caption=GetSet and Setter implementations
   procedure Set (var : in out Variable_Type; value : Item_Type) is
   begin
      if var.primary = null then
         if allocate = null then
            raise AllocatorError;
         end if;
         var.primary     := ItemPtr_Type (allocate.all);
         var.primary.all := value;

         var.secondary     := ItemPtr_Type (allocate.all (True));
         var.secondary.all := value;
         return;
      end if;

      if var.primary.all = var.secondary.all then
         var.primary.all   := value;
         var.secondary.all := value;
         return;
      end if;

      raise VariableCorruption;
   end Set;

   function Get (var : Variable_Type) return Item_Type is
   begin
      if var.primary.all = var.secondary.all then
         return var.primary.all;
      end if;
      raise VariableCorruption;
   end Get;
   --codemd: end

end critical;
