CREATE procedure p_WfCopyFinalQueueParams @current_token varchar(32), @finalqueue_token varchar(32)
as
begin
	insert into WfSession(Token, ObjectName, ObjectBase64, ObjectType, StepNr)
	select @current_token, ObjectName, ObjectValue, Coalesce(ObjectName, ''), 0 from WfFinalQueueParams where Token = @finalqueue_token
end