CREATE procedure [dbo].[ReservationFinalize]
	@reservationId int,
	@price decimal(9, 2),
	@currentSsoUserId int
as 

begin

	begin try
		
		UPDATE [dbo].[Reservations]
		SET [ReservationStatusId] = 3,
			[ClientId] = a.cid,
			[StoreOrderId] = a.stid,
			[Price] = @price,
			[LastChangeDate] = getdate(),
			[CurrentSsoUserId] = @currentSsoUserId
			from
			(
				select fq.ClientId as cid, fq.StoreOrderId as stid, r.ReservationId as rid
				from Reservations r with (nolock)
				inner join WfFinalQueue fq with (nolock) on fq.Token = r.Token
				where r.ReservationId = @reservationId
			) as a
		where ReservationId = a.rid;

		return 0;

	end try
	begin catch
		return -99;
	end catch
end