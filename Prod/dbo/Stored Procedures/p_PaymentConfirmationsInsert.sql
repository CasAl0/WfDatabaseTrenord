
CREATE procedure [dbo].[p_PaymentConfirmationsInsert](@clientId int, @storeOrderId varchar(50), @paymentChannelId int)
as
begin
	declare @now datetime;

	set @now = getdate();

	update PaymentConfirmations set ConfirmPaymentDate = getdate(), PaymentChannelId = @paymentChannelId
	where StoreOrderId = @storeOrderId and ClientId = @clientId;

	insert into PaymentConfirmations (StoreOrderId, ClientId, ConfirmPaymentDate, PaymentChannelId)
	select @storeOrderId, @clientId, @now, @paymentChannelId
	except
	select StoreOrderId, ClientId, @now, @paymentChannelId
	from PaymentConfirmations where StoreOrderId = @storeOrderId and ClientId = @clientId;

end