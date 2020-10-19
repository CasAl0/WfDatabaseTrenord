CREATE PROCEDURE [sbme].[AlignTariffs]
	@TariffId int,
	@TariffMiniName varchar(6),
	@TariffShortName varchar(16),
	@TariffLongName varchar(30),
	@Description varchar(128),
	@ContractClassId int,
	@ProviderId int,
	@SaleaAgentListId int,
	@OperatorListId int,
	@EnglishTariffName varchar(30),
	@FrenchTariffName varchar(30),
	@GermanTariffName varchar(30),
	@ExtraLangTariffName varchar(310),
	@Priority int,
	@Status varchar(6)
AS
BEGIN
	declare @TariffKey varchar(10);
	set @TariffKey = cast(@TariffId as varchar(10));

	if not exists (select 1 from dbo.[Tariff] where TariffKey = @TariffKey)
	begin
		return;
	end

	if exists (select 1 from sbme.[Tariffs] where TariffKey = @TariffKey)
	begin
		update [sbme].[Tariffs] set
				[TariffMiniName]	=	@TariffMiniName,
				[TariffShortName]	=	@TariffShortName,
				[TariffLongName]	=	@TariffLongName,
				[Description]		=	@Description,
				[ContractClassId]	=	@ContractClassId,
				[ProviderId]		=	@ProviderId,
				[SaleAgentListId]	=	@SaleaAgentListId,
				[OperatorListId]	=	@OperatorlistId,
				[EnglishTariffName]	=	@EnglishTariffName,
				[FrenchTariffName]	=	@FrenchTariffName,
				[GermanTariffName]	=	@GermanTariffName,
				[ExtraLangTariffName] =	@ExtraLangTariffName,
				[Priority]			=	@Priority,
				[Status]			=	@Status
		where [TariffKey] = @TariffKey;
	end
	else
	begin
		INSERT INTO [sbme].[Tariffs]
			   ([TariffKey]
			   ,[TariffMiniName]
			   ,[TariffShortName]
			   ,[TariffLongName]
			   ,[Description]
			   ,[ContractClassId]
			   ,[ProviderId]
			   ,[SaleAgentListId]
			   ,[OperatorListId]
			   ,[EnglishTariffName]
			   ,[FrenchTariffName]
			   ,[GermanTariffName]
			   ,[ExtraLangTariffName]
			   ,[Priority]
			   ,[Status])
		values
		(
			@TariffKey,
			@TariffMiniName,
			@TariffShortName,
			@TariffLongName,
			@Description,
			@ContractClassId,
			@ProviderId,
			@SaleaAgentListId,
			@OperatorlistId,
			@EnglishTariffName,
			@FrenchTariffName,
			@GermanTariffName,
			@ExtraLangTariffName,
			@Priority,
			@Status
		);
	end
END