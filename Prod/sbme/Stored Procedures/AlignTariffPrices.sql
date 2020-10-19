CREATE PROCEDURE [sbme].[AlignTariffPrices]
	@TariffId int,
	@Distance int,
	@PassengerClass int,
	@Price decimal(18,2)
AS
BEGIN
	
	declare @TariffKey varchar(10);
	set @TariffKey = cast(@TariffId as varchar(10));

	set @Price = @Price / 100.0;

	if not exists (select 1 from sbme.[Tariffs] where TariffKey = @TariffKey)
	begin
		return;
	end
	
	if not exists (select 1 from sbme.TariffPrices where TariffKey = @TariffKey and Distance = @Distance and PassengerClass = @PassengerClass and Price = @Price)
	begin
		declare @ValidFrom datetime;
		set @ValidFrom = getdate();

		if exists (select 1 from sbme.TariffPrices where TariffKey = @TariffKey and Distance = @Distance and PassengerClass = @PassengerClass and Price <> @Price)
		begin
			set @ValidFrom = null;
		end
		
		insert into [sbme].[TariffPrices] ([TariffKey], [Distance], [PassengerClass], [Price], [ValidFrom], [ValidTo])
		values (@TariffKey, @Distance, @PassengerClass, @Price, @ValidFrom, null);
	end
END