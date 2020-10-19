

CREATE FUNCTION [dbo].[TariffCategorySelector]
(
	@origin int,
	@destination int,
	@stations varchar(100),
	@categories varchar(100)	
)
returns varchar(10) 
as
begin
	
	declare @code varchar(10);

	set @code = '';

	select @code = isnull(tc.Code, '') from TariffCategory tc
	inner join TariffCategoryRules tcr on tcr.TariffCategoryId = tc.TariffCategoryId
	where OriginKey = @origin
	and DestinationKey = @destination
	group by tc.Code;

	if len(ltrim(rtrim(@code))) = 0
	begin		
		
		set @code = '';

		select @code = isnull(tc.Code, '') from TariffCategory tc
		inner join TariffCategoryRules tcr on tcr.TariffCategoryId = tc.TariffCategoryId
		where CHARINDEX('[' + tcr.StationKey + ']', @stations, 0) > 0
		and  CHARINDEX('[' + tcr.TrainCategory + ']', @categories, 0) > 0
		group by tc.Code;

		if len(ltrim(rtrim(@code))) = 0
		begin
		
			set @code = '';

			select @code = isnull(tc.Code, '') from TariffCategory tc
			inner join TariffCategoryRules tcr on tcr.TariffCategoryId = tc.TariffCategoryId
			where CHARINDEX('[' + tcr.TrainCategory + ']', @categories, 0) > 0
			group by tc.Code;
		end
	end

	return @code;
end

