--with Ada.Text_Io; use Ada.Text_Io;
--with Ada.Integer_Text_Io; use Ada.Integer_Text_Io;

package body Stacks is

   function Create (Depth : Integer := 64) return Stack is
      result : Stack (Depth);
   begin
      return result;
   end Create;

   procedure Push (Stk : in out Stack; Item : Item_Type) is
   begin
      if Stk.top > Stk.contents'Last then
         raise Overflow;
      end if;
      Stk.contents (Stk.top) := Item;
      Stk.top                := Stk.top + 1;
   end Push;

   procedure Pop (Stk : in out Stack; Item : out Item_Type) is
   begin
      if not Empty (Stk) then
         Stk.top := Stk.top - 1;
         Item    := Stk.contents (Stk.top);
      end if;
   end Pop;

   function Top (Stk : Stack) return Item_Type is
   begin
      if not Empty (Stk) then
         return Stk.contents (Stk.top);
      end if;
      raise Empty_Stack;
   end Top;

   function Empty (Stk : Stack) return Boolean is
   begin
      return Stk.top = 1;
   end Empty;

   function Full (Stk : Stack) return Boolean is
   begin
      return Stk.top > Stk.contents'Last;
   end Full;

end Stacks;
