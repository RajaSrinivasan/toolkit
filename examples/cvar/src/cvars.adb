-- codemd: begin segment=Implement caption=Implementation
package body cvars is
   function allocator (secondary : Boolean) return access Float is
   begin
      return new Float;
   end allocator;
begin
   critical_float.SetAllocators (allocator'Access);
end cvars;
--codemd: end
