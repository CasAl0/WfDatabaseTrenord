
CREATE procedure [dbo].[p_CouponInsert]
	@couponCode varchar(50),
	@clientId int,
	@storeOrderId varchar(50),
	@token varchar(32),
	@amount decimal(18, 2),
	@senderName nvarchar(4000),
	@senderEmail nvarchar(4000),
	@senderMessage nvarchar(4000),
	@recipientName nvarchar(4000),
	@recipientEmail nvarchar(4000),
	@couponTypeId int
as
begin
	begin transaction coupon_insert;
	begin try
		
		declare @couponId int

		insert into dbo.Coupons (CouponCode, LastChangeDate, CreationClientId, CreationStoreOrderId, CreationToken, CouponTypeId)
		select @couponCode, getdate(), @clientId, @storeOrderId, t.Token, cts.CouponTypeId
		from CouponTypeSku cts
		inner join WfToken t on t.ProductSku = cts.ProductSku
		where t.Token = @token
		and cts.CouponTypeId = @couponTypeId

		set @couponId = SCOPE_IDENTITY()

		insert into dbo.CouponsDetails (CouponId, Amount, SenderName, SenderEmail, SenderMessage, RecipientName, RecipientEmail)
		values (@couponId, @amount, @senderName, @senderEmail, @senderMessage, @recipientName, @recipientEmail)
		
		commit transaction coupon_insert;
	end try
	begin catch
		
		DECLARE @ErrorMessage NVARCHAR(4000), @ErrorSeverity INT, @ErrorState INT;
		SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();

		rollback transaction coupon_insert;

		RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
	end catch
	
end