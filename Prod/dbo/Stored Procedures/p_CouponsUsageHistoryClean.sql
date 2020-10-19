
create procedure [dbo].[p_CouponsUsageHistoryClean]
as
begin
	begin try
		
		delete from CouponsUsageHistory where StoreOrderId is null and datediff(hh, LastChangeDate, getdate()) > 1;
		
	end try
	begin catch
		
		DECLARE @ErrorMessage NVARCHAR(4000), @ErrorSeverity INT, @ErrorState INT;
		SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();

		RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
	end catch
	
end