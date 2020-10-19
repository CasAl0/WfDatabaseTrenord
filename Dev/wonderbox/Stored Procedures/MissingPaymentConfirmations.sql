CREATE procedure [wonderbox].[MissingPaymentConfirmations]
	@mode int
as
begin

if @mode = 1
begin
	insert into dbo.PaymentConfirmations (StoreOrderId, ClientId, ConfirmPaymentDate, PaymentChannelId)
	select StoreOrderId, ClientId, OrderDate as ConfirmPaymentDate, 1 as PaymentChannelId
	from WfFinalQueue with (nolock) where ClientId = 1 and StoreOrderId is not null
	and StoreOrderId not in (select StoreOrderId from PaymentConfirmations with (nolock))
	group by StoreOrderId, ClientId, OrderDate;
end

select StoreOrderId, ClientId, OrderDate as ConfirmPaymentDate, 1 as PaymentChannelId
from WfFinalQueue with (nolock) where ClientId = 1 and StoreOrderId is not null
and StoreOrderId not in (select StoreOrderId from PaymentConfirmations with (nolock))
group by StoreOrderId, ClientId, OrderDate;

end
GO
GRANT EXECUTE
    ON OBJECT::[wonderbox].[MissingPaymentConfirmations] TO [reporting]
    AS [dbo];

