CREATE procedure [dbo].[p_WfExpiredFinalQueueCleaning]
as
begin
	if exists(select token from WfExpiredFinalQueue where StoreOrderId is null)
	begin
		declare @rows int = 0;
		declare @tkn varchar(32) = null;
		declare @Table table (token varchar(32) NOT NULL);

		insert into @Table (token)
		select Token from WfExpiredFinalQueue where StoreOrderId is null;

		select @rows = COUNT(*) from @Table;

		While @rows > 0
		begin
			print 'Mancanti: ' + convert(varchar, @rows);

			set @rows -= 1;
			select top 1 @tkn = token from @Table;

			delete from WfExpiredFinalQueueParams where Token = @tkn;
			delete from WfExpiredFinalQueueItems where Token = @tkn;
			delete from WfExpiredFinalQueue where Token = @tkn;
			delete from @Table where token = @tkn;
		end

	end
end