
CREATE procedure [trains].[CalculateKms]
	@departureStationId int,
	@arrivalStationId int,
	@travelKm int output
	
as

begin

select @travelKm = min(tp.DistanceKm) from trains.TrainPaths tp where tp.DepartureStationId = @departureStationId and tp.ArrivalStationId = @arrivalStationId

end