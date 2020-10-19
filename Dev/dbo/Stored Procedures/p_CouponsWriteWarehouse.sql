
CREATE procedure [dbo].[p_CouponsWriteWarehouse]
as
begin
	begin transaction coupons_write_warehouse;
	begin try
		
		declare @wareHouseId bigint;
		declare @clientOrderId varchar(60);
		declare @price decimal(18, 4);
		declare @value decimal(18, 4);

		declare warehouse cursor fast_forward for
 
		select wh.WareHouseId, cast(wh.ClientId as varchar(9)) + '_' + wh.OrderId as ClientOrderId, (wh.Quantity * wh.Price) as Price, sum(cuh.Value) as Value
		from CouponsUsageHistory cuh
		inner join WfWareHouse wh on wh.ClientId = cuh.ClientId and wh.OrderId = cuh.StoreOrderId
		where wh.CouponUsedValue is null
		group by wh.WareHouseId, wh.ClientId, wh.OrderId, wh.Quantity, wh.Price
		order by wh.WareHouseId asc;

		open warehouse;
		fetch next from warehouse into @wareHouseId, @clientOrderId, @price, @value;

		declare @currentClientOrderId varchar(60);
		declare @residualValue decimal(18, 4);
		declare @usedValue decimal(18, 4);

		set @currentClientOrderId = '';
		set @residualValue = -1.0;

		while @@FETCH_STATUS = 0
		begin
			if @currentClientOrderId <> @clientOrderId
			begin
				set @currentClientOrderId = @clientOrderId;
				set @residualValue = @value;
			end
	
			if @residualValue > 0.0 and @residualValue >= @price
			begin
				set @usedValue = @price;
				set @residualValue = @residualValue - @price;
			end
			else if @residualValue > 0.0 and @residualValue < @price
			begin
				set @usedValue = @residualValue;
				set @residualValue = 0.0;
			end
			else
			begin
				set @usedvalue = 0.0;
			end

			update WfWareHouse set CouponUsedValue = @usedValue where WareHouseId = @wareHouseId;

			fetch next from warehouse into @wareHouseId, @clientOrderId, @price, @value;
		end

		close warehouse;
		deallocate warehouse;
		
		update WfWareHouse
		set PaymentMethod = case when (Quantity * Price) = CouponUsedValue then 'Carte prepagate' else PaymentMethod end
		where CouponUsedValue is not null;

		update WfWareHouse
		set PaymentMethod = 'Prodotto gratuito'
		where Price = 0.0 and (PaymentMethod = 'n.d.' or PaymentMethod is null);

		commit transaction coupons_write_warehouse;

	end try
	begin catch
		
		DECLARE @ErrorMessage NVARCHAR(4000), @ErrorSeverity INT, @ErrorState INT
		SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE()

		rollback transaction coupons_write_warehouse;

		RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)

	end catch
	
end