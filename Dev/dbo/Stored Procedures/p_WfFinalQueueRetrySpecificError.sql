CREATE procedure [dbo].[p_WfFinalQueueRetrySpecificError]
as
begin
	
	begin try
		
		update WfFinalQueue set StateCode = 1
		where ErrorLog in
		(
			'Wf-TlnHandler-ErrGateway : -1',
			'Wf-TlnHandler-ErrGateway : 9999',
			'Wf-TlnHandler-ErrGateway : 99999',
			'Wf-TlnHandler-ErrGateway : 10068'
		)
		and StateCode = 90
		and cast(OrderDate as date) >= cast(GETDATE() - 1 as date);

		update WfFinalQueue set StateCode = 1
		where errorlog = 'Wf-TicketListHandler-ErrCreatePatOrderNumber : Impossible to complete order'
		and StateCode = 90 and LegacyOrderId is not null
		and cast(OrderDate as date) >= cast(GETDATE() - 5 as date);

		update WfFinalQueue set StateCode = 1
		where errorlog = 'Wf-MailHandler-Exception : IndexOutOfRangeException Index was outside the bounds of the array.'
		and StateCode = 90 and LegacyOrderId is not null
		and cast(OrderDate as date) >= cast(GETDATE() - 5 as date);

	end try
	begin catch
		DECLARE @ErrorMessage NVARCHAR(4000), @ErrorSeverity INT, @ErrorState INT;
		SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();
		
		RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
	end catch
	
end