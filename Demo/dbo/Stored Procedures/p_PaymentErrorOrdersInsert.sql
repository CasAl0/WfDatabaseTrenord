
CREATE procedure [dbo].[p_PaymentErrorOrdersInsert]
@storeOrderId varchar(50),
@clientId int,
@paymentStatusOrder varchar(50)
as
begin
	begin transaction tran_payerror_insert
	begin try
		
		insert into PaymentErrorOrders (StoreOrderId, ClientId, CreationDate, PaymentStatusOrder)
		values (@storeOrderId, @clientId, getdate(), @paymentStatusOrder)

		commit transaction tran_payerror_insert
	end try
	begin catch
		rollback transaction tran_payerror_insert
		DECLARE @ErrorMessage NVARCHAR(4000), @ErrorSeverity INT, @ErrorState INT
		SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE()
		RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
	end catch
	
end