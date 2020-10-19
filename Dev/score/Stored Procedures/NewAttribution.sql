

CREATE procedure [score].[NewAttribution]
	@internalUserName nvarchar(50),
	@sku char(8),
	@tariffId int,
	@attributionDate datetime,
	@reason nvarchar(200),
	@token varchar(32),
	@periodNumber int,
	@periodFrom datetime,
	@periodTo datetime
as 

begin

	begin try
		
		declare @combinationId int;
		declare @points int;
		declare @partnerId int;
		
		declare combinations cursor fast_forward for

		select CombinationId, Points, PartnerId
		from score.Combinations
		where ProductSku = @sku and TariffId = @tariffId and cast(getdate() as date) between ValidFrom and  ValidTo;

		open combinations;

		fetch next from combinations into @combinationId, @points, @partnerId;

		while @@FETCH_STATUS = 0
		begin
			declare @associationId int;

			select @associationId = coalesce(AssociationId, 0) from score.Associations
			where InternalUserName = @internalUserName
			and PartnerId = @partnerId
			and cast(getdate() as date) between ValidFrom and ValidTo;

			if @associationId > 0
			begin
				declare @i int;

				set @i = 0;

				while @i < @periodNumber
				begin
					insert into score.Attributions
					(
						AssociationId,
						CombinationId,
						AttributionDate,
						Reason,
						AttributionStatusId,
						Token,
						SentToPartnerDate,
						PeriodNumber,
						PeriodFrom,
						PeriodTo,
						Points
					)
					values
					(
						@associationId,
						@combinationId,
						@attributionDate,
						@reason,
						0,
						@token,
						null,
						@periodNumber,
						@periodFrom,
						@periodTo,
						@points
					);

					set @i = @i + 1;
				end
			end

			fetch next from combinations into @combinationId, @points, @partnerId;
		end

		close combinations;
		deallocate combinations;
				
		return 0;

	end try
	begin catch
		return -99;
	end catch
end