
CREATE procedure [dbo].[ReservationAddNormalTickets]
	@reservationId int,
	@tickets varchar(200) = ''
as 

begin
	begin transaction reservation_save_tickets;
	begin try
		
		set @tickets = ltrim(rtrim(@tickets));

		delete from trains.ReservationsTariffs where ReservationId = @reservationId
		and TariffDetailsId in
		(
			select TariffDetailsId from trains.TariffDetails td
			inner join Tariff t on t.TariffId = td.TariffId and t.SpecialComposition = 0
		);

		if len(@tickets) > 0
		begin		

			declare @t1 varchar(40);
			declare @t2 varchar(20);
			declare @t3 varchar(20);

			while len(@tickets) > 0
			begin
				set @t1 = left(@tickets, charindex('#', @tickets) -1);
				set @tickets = ltrim(rtrim(right(@tickets, len(@tickets) - charindex('#', @tickets))));

				set @t2 = left(@t1, charindex('|', @t1) -1);
				set @t3 = ltrim(rtrim(right(@t1, len(@t1) - charindex('|', @t1))));

				if cast(@t3 as int) > 0
				begin
					insert into trains.ReservationsTariffs (ReservationId, TariffDetailsId, Quantity)
					values (@reservationId, @t2, @t3);
				end
			end
		end

		commit transaction reservation_save_tickets;
		return 0;

	end try
	begin catch
		rollback transaction reservation_save_tickets;
		return -99;
	end catch
end