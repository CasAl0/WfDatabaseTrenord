

CREATE procedure [score].[SendPendingAttribution]
	@attributionId bigint,
	@attributionDate datetime,
	@attributionStatusCode nvarchar(50),
	@sentToPartnerDate datetime
as 

begin

	begin try
			
		if not exists(select 1 from score.Attributions at
						inner join score.AttributionStatus ats on ats.AttributionStatusId = at.AttributionStatusId
						where at.AttributionId = @attributionId
						and ats.RetryToSend = 1)
		begin
			-- ATTRIBUZIONE NON REINVIABILE
			return -1;
		end

		declare @attributionStatusId int;

		select @attributionStatusId = coalesce(ats.AttributionStatusId, 0)
		from score.AttributionStatus ats
		inner join score.Associations ass on ass.PartnerId = ats.PartnerId
		inner join score.Attributions at on at.AssociationId = ass.AssociationId and at.AttributionId = @attributionId
		where ats.Code = @attributionStatusCode;

		if @attributionStatusId = 0
		begin
			-- CODICE STATO NON CENSITO
			return -2;
		end
		else
		begin						
		
			update score.Attributions set AttributionDate = @attributionDate, AttributionStatusId = @attributionStatusId, SentToPartnerDate = @sentToPartnerDate
			where AttributionId = @attributionId;
		
			return 0;
		end

	end try
	begin catch
		return -99;
	end catch
end
