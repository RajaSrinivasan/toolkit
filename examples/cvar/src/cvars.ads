with critical_float ;
package cvars is
    var1 : critical_float.Variable_Type ;
    var2 : critical_float.Variable_Type ;
    function allocator( secondary : boolean ) return access Float ;
end cvars ;