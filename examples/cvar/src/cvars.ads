with critical_float ;
package cvars is
    tempSetpoint : critical_float.Variable_Type ;
    pressureSetpoint : critical_float.Variable_Type ;
    function allocator( secondary : boolean ) return access Float ;
end cvars ;