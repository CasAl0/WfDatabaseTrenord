
CREATE procedure [dbo].[ReservationAddSpecialTicket]
	@reservationId int,
	@tariffDetailsId int,
	@quantity int,
    @price decimal(9, 2),
    @originLegacyStationId int,
    @destinationLegacyStationId int,
    @passengerClass varchar(5),
    @via1LegacyStationId int,
    @via2LegacyStationId int,
    @distance int
as 

begin
	begin try
		
		INSERT INTO [trains].[ReservationsTariffs]
           ([ReservationId]
           ,[TariffDetailsId]
           ,[Quantity]
           ,[Price]
           ,[OriginLegacyStationId]
           ,[DestinationLegacyStationId]
           ,[PassengerClass]
           ,[Via1LegacyStationId]
           ,[Via2LegacyStationId]
           ,[Distance])
		 VALUES
		 (
			@reservationId,
			@tariffDetailsId,
			@quantity,
			@price,
			@originLegacyStationId,
			@destinationLegacyStationId,
			@passengerClass,
			@via1LegacyStationId,
			@via2LegacyStationId,
			@distance
		);
		return 0;

	end try
	begin catch
		return -99;
	end catch
end