create procedure [dbo].[p_WfRemoveCopiedFinalQueueParams] @current_token varchar(32)
as
begin
	delete from WfSession where Token = @current_token and ObjectName like '#%';
end
