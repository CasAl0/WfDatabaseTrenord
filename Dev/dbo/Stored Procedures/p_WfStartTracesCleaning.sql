CREATE procedure [dbo].[p_WfStartTracesCleaning]
as
begin
	declare @StartTracesExpirationDays int
	select @StartTracesExpirationDays = - StartTracesExpirationDays from WfConfiguration with (nolock) where [Current] = 1
	
	delete from WfStartTraces where TraceDate < dateadd(dd, @StartTracesExpirationDays, getdate())
end