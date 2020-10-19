CREATE procedure [dbo].[p_WfSessionCleaning]
as
begin
	declare @tokenExpirationMinutes int
	select @tokenExpirationMinutes = - TokenExpirationMinutes from WfConfiguration with (nolock) where [Current] = 1
	
	if exists(select token from WfToken  where CreationDate < dateadd(mi, @tokenExpirationMinutes, getdate()))
	begin
		declare @rows int = 0;
		declare @tkn varchar(32) = null;
		declare @Table table (token varchar(32) NOT NULL);

		Insert Into @Table (token)
		select top(5000) Token from WfToken where CreationDate < dateadd(mi, @tokenExpirationMinutes, getdate());

		select @rows=COUNT(*) from @Table;

		While @rows > 0
		begin 
			set @rows-=1;
			select top 1 @tkn=token from @Table;

			delete from WfSession where Token=@tkn;
			delete from WfToken where Token=@tkn;
			delete from @Table where token=@tkn;
		end

	end
end