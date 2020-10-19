


CREATE VIEW [dbo].[FullPaymentConfirmations]
AS
SELECT [StoreOrderId], [ClientId], [ConfirmPaymentDate], [PaymentChannelId]
FROM PaymentConfirmations WITH (nolock)
union
SELECT [StoreOrderId], [ClientId], [ConfirmPaymentDate], [PaymentChannelId]
FROM History.PaymentConfirmations WITH (nolock)
union
SELECT [StoreOrderId], [ClientId], [OrderDate], 3
FROM WfFinalQueue WITH (nolock) where ClientId = 2 and StoreOrderId is not null



