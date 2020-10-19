
CREATE procedure [dbo].[p_CouponsUsageHistoryUpdate]
	@token varchar(32)
as
begin
	begin try
		
		update dbo.CouponsUsageHistory set ClientId = a.cid, StoreOrderId = a.soid, LegacyOrderId = a.loid, LastChangeDate = getdate()
		from (select ClientId as cid, StoreOrderId as soid, LegacyOrderId as loid, Token as tk from WfFinalQueue where Token = @token) as a
		where Token = a.tk;
		
	end try
	begin catch
		
		DECLARE @ErrorMessage NVARCHAR(4000), @ErrorSeverity INT, @ErrorState INT;
		SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();

		RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
	end catch
	
end