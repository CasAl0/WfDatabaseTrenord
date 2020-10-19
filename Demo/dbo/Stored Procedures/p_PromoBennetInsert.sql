
create procedure [dbo].[p_PromoBennetInsert]
	@voucher varchar(50),
	@datefrom date,
	@dateto date
as
begin

	if not exists (select 1 from PromoBennet where voucher = @voucher and CouponTypeId = 2)
	begin
		begin transaction promo_bennet_insert;
		begin try	
		
			insert into PromoBennet (Voucher, Stato, CouponTypeId, DateValidityFrom, DateValidityTo, ChangeTracking)
			values (@voucher, 1, 2, @datefrom, @dateto, getdate());
		
			commit transaction promo_bennet_insert;
		end try
		begin catch
		
			DECLARE @ErrorMessage NVARCHAR(4000), @ErrorSeverity INT, @ErrorState INT
			SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE()

			rollback transaction promo_bennet_insert;

			RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
		end catch
	end
end