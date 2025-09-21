package body car is
   procedure Cycle( p : in out Car_T ;
                     input : float ) is
    begin
        p.Value := p.Value + input ;
    end Cycle ;
end car ;
