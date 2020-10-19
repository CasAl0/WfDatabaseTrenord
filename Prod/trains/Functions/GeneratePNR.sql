
CREATE FUNCTION [trains].[GeneratePNR](@ticketId bigint)
returns varchar(8) 
as
begin
	declare @tmp bigint
	declare @base varchar(36)
	declare @res varchar(8)

	set @base = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'
	set @tmp = cast(abs(sin(@ticketId)) * 1000000000000 as bigint)
	set @res = ''
	
	while (@tmp <> 0) 
	begin
		set @res = substring(@base, 1 + @tmp % 36, 1) + @res
		set @tmp = @tmp / 36;
	end
	return @res
end
