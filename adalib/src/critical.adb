package body critical is

    allocate : AllocatorType ;
 
    procedure SetAllocators( a : not null AllocatorType ) is
    begin
        allocate := a ;
    end SetAllocators ;

    --codemd: begin segment=GetSet caption=GetSet and Setter implementations                  
    procedure Set(var : in out Variable_Type;  value : Item_Type ) is
    begin
        if var.Primary = null
        then
            if allocate = null
            then
                raise AllocatorError ;
            end if;
            var.Primary := ItemPtr_Type(allocate.all) ;
            var.Primary.all := value ;

            var.Secondary := ItemPtr_Type(allocate.all(true)) ;
            var.Secondary.all := value ;
            return ;
        end if ;

        if var.Primary.all = var.Secondary.all
        then
            var.Primary.all := value ;
            var.Secondary.all := value ;
            return ;
        end if ;

        raise VariableCorruption ;
    end Set ;

    function Get( var : Variable_Type ) return Item_Type is
    begin
        if var.Primary.all = var.Secondary.all
        then
            return var.Primary.all ;
        end if ;
        raise VariableCorruption ;
    end Get ;
    --codemd: end

end critical ;