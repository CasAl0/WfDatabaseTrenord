
CREATE FUNCTION [dbo].[ProductPrice]
(
	@tariffDetailsId int,
	@km int,
	@travelDate date
)
returns decimal(9, 2)
as
begin
	declare @price decimal(9, 2);
	declare @holiday int;

	select @holiday = count(*) from Holidays where HolidayDate = @travelDate;

	select @price = tp.Price from trains.TariffDetails td
	inner join trains.TariffPrices tp on tp.TariffDetailsId = td.TariffDetailsId
	where @km between DistanceFrom and coalesce(DistanceTo, @km)
	and (tp.DayType = 0 or tp.Daytype = case when @holiday > 0 then 2 else 1 end)
	and td.TariffDetailsId = @tariffDetailsId;

	return @price;
end