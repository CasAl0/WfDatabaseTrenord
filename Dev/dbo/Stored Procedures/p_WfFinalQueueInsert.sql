CREATE procedure [dbo].[p_WfFinalQueueInsert] @token varchar(32), @name varchar(50), @namedest varchar(50)
as
begin
	declare @finalQueueExpirationDays int
	select @finalQueueExpirationDays = FinalQueueExpirationDays from WfConfiguration with (nolock) where [Current] = 1

	begin transaction tran_finalQueue_insert
	begin try
		declare @dt datetime = getdate()
		declare @exp datetime = dateadd(DD, @finalQueueExpirationDays, @dt)
		declare @clientid int
		declare @sku char(8)
		declare @endwf char(8)
		
		select @clientid = ClientId, @sku = ProductSku, @endwf = EndWorkflowId from WfToken where Token = @token;

		if @endwf is not null
		begin
			if not exists(select token from WfFinalQueue where StateCode = 0 and Token = @token) begin
				-- inserisco la coda finale
				insert into WfFinalQueue(Token, ClientId, ProductSku, OrderDate, Expiration, StateCode, EndWorkflowId)
				select Token, ClientId, ProductSku, @dt, @exp, 0, EndWorkflowId
				from WfToken where Token = @token;
			end
			else
			begin
				update WfFinalQueue set OrderDate = @dt, Expiration = @exp, StateCode = 0
				where Token = @token;
			end
			
			if not exists(select token from WfFinalQueueParams where Token = @token and ObjectName = @namedest)
			begin
				insert into WfFinalQueueParams(Token, ObjectName, ObjectValue, ObjectType)
				select @token, @namedest, ObjectBase64, ObjectType from WfSession where Token = @token and ObjectName = @name;
			end
			else
			begin
				update WfFinalQueueParams set ObjectValue = (select ObjectBase64 from WfSession where Token = @token and ObjectName = @name)
				where Token = @token and ObjectName = @namedest;
			end

			if @namedest = '#sms_number'
			begin
				update WfFinalQueue set OrderSmsNumber =
				(
					select cast(ObjectValue as varchar(255)) from WfFinalQueueParams
					where Token = @token and ObjectName = @namedest
				)
				where Token = @token;
			end
		end

		commit transaction tran_finalQueue_insert;
	end try
	begin catch
		DECLARE @ErrorMessage NVARCHAR(4000), @ErrorSeverity INT, @ErrorState INT;
		SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();

		rollback transaction tran_finalQueue_insert;

		RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
	end catch
	
end