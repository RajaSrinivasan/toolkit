generic

    type Item_Type is private ;
    with function "=" (left,right : Item_Type) return boolean ;

package critical is

    AllocatorError : exception ;
    VariableCorruption : exception ;

    type AllocatorType is access function ( secondary : boolean := false ) return access Item_Type ;
    procedure SetAllocators( a : not null AllocatorType );


    type Variable_Type is private ;
    procedure Set(var : in out Variable_Type; value : Item_Type );
    function Get( var : Variable_Type ) return Item_Type ;

    private
    type ItemPtr_Type is access all Item_Type ;
    type Variable_Type is
    record
        primary : ItemPtr_Type ;
        secondary : ItemPtr_Type ;
    end record ;
end critical ;