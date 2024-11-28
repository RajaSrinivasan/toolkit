package body cvars is
    function allocator( secondary : boolean ) return access Float is
    begin
        return new Float ;
    end allocator ;
begin
    critical_float.SetAllocators( allocator'access );
end cvars ;