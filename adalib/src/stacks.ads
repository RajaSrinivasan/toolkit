generic
   type Item_Type is private;
package Stacks is

   Overflow    : exception;
   Empty_Stack : exception;

   type Contents_Type is array (Integer range <>) of aliased Item_Type;
   type Stack (capacity : Integer) is record
      contents : Contents_Type (1 .. capacity);
      top      : Integer := 1;
   end record;

   function Create (Depth : Integer := 64) return Stack;

   procedure Push (Stk : in out Stack; Item : Item_Type);
   procedure Pop (Stk : in out Stack; Item : out Item_Type);
   function Top (Stk : Stack) return Item_Type;
   function Empty (Stk : Stack) return Boolean;
   function Full (Stk : Stack) return Boolean;
end Stacks;
