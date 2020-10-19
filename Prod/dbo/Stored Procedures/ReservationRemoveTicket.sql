
CREATE procedure [dbo].[ReservationRemoveTicket]
	@reservationsTariffId int
as 

begin
	begin try
		
		delete from [trains].[ReservationsTariffs] where ReservationsTariffId = @reservationsTariffId;

		return 0;

	end try
	begin catch
		return -99;
	end catch
end