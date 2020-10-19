

CREATE procedure [score].[NewAssociation]
	@internalUserName nvarchar(50),
	@partnerId int, 
	@partnerUserName nvarchar(50),
	@associationDate datetime,
	@validFrom date = null,
	@validTo date = null,
	@saleDeviceId int = null,
	@serialNo bigint = null,
	@holderId bigint = null,
	@ssoUserId int = null
as 

begin

	begin try
		if exists(select 1 from score.Associations
					where InternalUserName = @internalUserName
					and PartnerId = @partnerId
					and PartnerUserName = @partnerUserName
					and cast(getdate() as date) between ValidFrom and ValidTo)
		begin
			-- ASSOCIAZIONE GIA' PRESENTE
			return -1;
		end

		if exists(select 1 from score.Associations
					where InternalUserName = @internalUserName
					and PartnerId = @partnerId
					and PartnerUserName <> @partnerUserName
					and cast(getdate() as date) between ValidFrom and ValidTo)
		begin
			-- UTENTE TRENORD GIA' ASSOCIATO AD ALTRO CLIENTE DEL PARTNER
			return -2;
		end

		if exists(select 1 from score.Associations
					where InternalUserName <> @internalUserName
					and PartnerId = @partnerId
					and PartnerUserName = @partnerUserName
					and cast(getdate() as date) between ValidFrom and ValidTo)
		begin
			-- UTENTE DEL PARTNER GIA' ASSOCIATO AD ALTRO CLIENTE TRENORD
			return -3;
		end
	
		insert into score.Associations
		(
			InternalUserName,
			PartnerId,
			PartnerUserName,
			AssociationDate,
			ValidFrom,
			ValidTo,
			LastUpdate,
			SaleDeviceId,
			SerialNo,
			HolderId,
			SsoUserId
		)
		values
		(
			@internalUserName,
			@partnerId,
			@partnerUserName,
			@associationDate,
			coalesce(@validFrom, getdate()),
			coalesce(@validTo, cast('2999-01-01' as date)),
			getdate(),
			@saleDeviceId,
			@serialNo,
			@holderId,
			@ssoUserId
		);

		return 0;

	end try
	begin catch
		return -99;
	end catch
end
