CREATE procedure [dbo].[p_WfCleanFinalQueue]
as
begin
	declare @tokens table ([Token] [varchar](50));

	insert into @tokens (Token)
	select Token from WfFinalQueue with (nolock) where Expiration < GETDATE() - 1 and StateCode = 0;

	print 'CLEAN';
	print '{';
	begin try
		delete from WfFinalQueueParams where Token in (select Token from @tokens)
		delete from WfFinalQueueItems where Token in (select Token from @tokens)
		delete from WfFinalQueue where Token in (select Token from @tokens)
	end try
	begin catch
		print ERROR_MESSAGE();
	end catch
	print '}';

	delete from @tokens;
end