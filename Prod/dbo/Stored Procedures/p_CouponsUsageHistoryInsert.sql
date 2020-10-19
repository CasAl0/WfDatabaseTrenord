
CREATE procedure [dbo].[p_CouponsUsageHistoryInsert]
	@couponId int,
	@token varchar(32),
	@amount decimal(18, 2)
as
begin
	begin try
		
		insert into dbo.CouponsUsageHistory (CouponId, Token, Value, LastChangeDate)
		select @couponId, @token, @amount, getdate();
		
	end try
	begin catch
		
		DECLARE @ErrorMessage NVARCHAR(4000), @ErrorSeverity INT, @ErrorState INT;
		SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();

		RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
	end catch
	
end