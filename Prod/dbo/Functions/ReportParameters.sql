
CREATE FUNCTION [dbo].[ReportParameters]
(
	@ClientId int = null,
	@GroupByType int = null,	
	@ShowSku bit = null,
	@WithoutClient bit = null,
	@WithoutProductGroup bit = null,
	@PaymentChannelId int = null,
	@ProductGroupId int = null,
	@Sku char(8) = null,
	@DateFrom date = null,
	@DateTo date = null
)
returns varchar(1000)
as
begin
	declare @params as varchar(1000);

	set @params = '';

	if @ClientId is not null
	begin
		set @params = @params + 'Piattaforma ' + 
						case @ClientId
						when 0 then 'TUTTE'
						when 1 then 'STORE'
						when 2 then 'APP'
						end;
	end

	if @GroupByType is not null
	begin
		set @params = @params + ' - Raggruppamento ' + 
						case @GroupByType
						when 0 then 'TUTTO'
						when 1 then 'PER ANNO'
						when 2 then 'PER MESE'
						when 3 then 'PER GIORNO'
						when 4 then 'PER ORA'
						end;
	end

	if @ShowSku is not null
	begin
		set @params = @params + case when @ShowSku = 0 then '' else ' - DETTAGLIO PRODOTTI' end;
	end

	if @WithoutClient is not null
	begin
		set @params = @params + case when @WithoutClient = 0 then '' else ' - TUTTE LE PIATTAFORME INSIEME' end;
	end

	if @WithoutProductGroup is not null
	begin
		set @params = @params + case when @WithoutProductGroup = 0 then '' else ' - SENZA RAGGRUPPAMENTO PRODOTTI' end;
	end

	if @PaymentChannelId is not null
	begin
		set @params = @params + ' - Canale ' + 
						case @PaymentChannelId
						when 0 then 'TUTTI'
						when 1 then 'DESKTOP'
						when 2 then 'MOBILE'
						end;
	end

	if @ProductGroupId is not null
	begin
		set @params = @params + case when @ProductGroupId = 0 then '' else ' - Gruppo prodotti ' + (select upper(ProductGroupDescription) from ProductGroup with (nolock) where ProductGroupId = @ProductGroupId) end;
	end

	if @Sku is not null
	begin
		set @params = @params + case when len(@Sku) = 0 then '' else ' - Prodotto specifico ' + (select upper(ProductDescription) from ProductCodes with (nolock) where ProductSku = @Sku) end;
	end

	set @params = @params + case when @DateFrom is null then '' else ' - Dal ' +  format(@DateFrom, 'dd/MM/yyyy', 'it-IT') end;
	set @params = @params + case when @DateTo is null then '' else ' - Al ' + format(@DateTo, 'dd/MM/yyyy', 'it-IT') end;

	return @params;
end

