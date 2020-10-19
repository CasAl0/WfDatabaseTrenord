

CREATE procedure [score].[InvalidateAssociation]
	@partnerId int, 
	@partnerUserName nvarchar(50),
	@validTo date = null
as 

begin

	begin try
		if not exists(select 1 from score.Associations
					where PartnerId = @partnerId
					and PartnerUserName = @partnerUserName
					and cast(getdate() as date) between ValidFrom and ValidTo)
		begin
			-- ASSOCIAZIONE INVALIDABILE NON PRESENTE
			return -1;
		end
		
		update score.Associations set ValidTo = coalesce(@validTo, cast(getdate() - 1 as date)), LastUpdate = getdate()
		where PartnerId = @partnerId
		and PartnerUserName = @partnerUserName
		and cast(getdate() as date) between ValidFrom and ValidTo;
	
		return 0;

	end try
	begin catch
		return -99;
	end catch
end
