with Ada.Text_Io; use Ada.Text_Io;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Strings.Unbounded ; use Ada.Strings.Unbounded ;
with Ada.Command_Line; use Ada.Command_Line;
with stacks ;
with fifo ;

procedure Revarg is
   package arglist_Pkg is new stacks (Unbounded_String);
   use arglist_Pkg ;
   package argbuf_Pkg is new fifo (Unbounded_String) ;

   content : Unbounded_String ;
   procedure T1 is   
      revargs : arglist_Pkg.Stack := Create ;
   begin
     Outer_Loop : for i in 1..Argument_Count
   loop
      for j in 1..10
      loop
         if Full(revargs)
         then
            Put("Stack is full. Cannot push item "); Put(i); New_Line ;
            exit Outer_Loop ;
         end if;
         Push( revargs, To_Unbounded_String(Argument(i)));
         Put("Pushed "); Put_Line(Argument(i));
      end loop ;
   end loop Outer_Loop ;
   Put_Line("Stack Contents -------" );
   while not Empty(revargs)
   loop
      Pop(revargs,content);
      Put_Line(To_String(content)) ;
   end loop ;

   end T1 ;

   procedure T2 is
      circbuf : argbuf_Pkg.Buffer_Type := argbuf_Pkg.Create(32);
      count : Integer := 0;
   begin
      Outer_Loop : for i in 1..Argument_Count loop

         for j in 1..Argument_Count
         loop
            if argbuf_Pkg.Full(circbuf)
            then
               Put(count); Put(" elements added to circular buffer"); New_Line ;
               Exit Outer_Loop ;
            end if ;
            argbuf_Pkg.Push(circbuf,To_Unbounded_String(Argument(i)));
            count := @ + 1 ;
         end loop ;
      end loop Outer_Loop;
      Put_Line("Circular buffer contents ......");
      count := 1 ;
      while not argbuf_Pkg.Empty(circbuf)
      loop
         Put(count) ; Put(" > ");
         argbuf_Pkg.Get(circbuf,content);
         Put_Line(To_String(content));
         count := @ + 1 ;
      end loop ;

   end T2 ;

begin
   T1 ;
   T2 ;
end Revarg;
