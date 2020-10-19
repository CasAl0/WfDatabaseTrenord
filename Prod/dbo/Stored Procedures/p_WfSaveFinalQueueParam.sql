
CREATE procedure [dbo].[p_WfSaveFinalQueueParam] @current_token varchar(32), @current_name varchar(50), @finalqueue_token varchar(32), @finalqueue_name varchar(50)
as
begin
	declare @obj varchar(MAX)

	
	
	if exists(select * from WfFinalQueueParams where ObjectName = @finalqueue_name and Token=@finalqueue_token)
	begin
		select @obj = ObjectBase64 from WfSession where ObjectName=@current_name and Token=@current_token
		update WfFinalQueueParams set ObjectValue = @obj where ObjectName = @finalqueue_name and Token=@finalqueue_token
	end
	else
		insert into WfFinalQueueParams(Token, ObjectName, ObjectValue, ObjectType)
		select @finalqueue_token, @finalqueue_name, ObjectBase64, ObjectType from WfSession where ObjectName=@current_name and Token=@current_token
end


