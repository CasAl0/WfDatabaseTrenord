

CREATE VIEW [wonderbox].[PendingGiftCardsNotInUse]
AS

with paidOrders as
(
select o2.Id from wonderbox.Orders o2 where o2.OrderStatusId = 30 and o2.PaymentStatusId = 30
except
select cast(CreationStoreOrderId as int) as Id from Coupons with (nolock) where CreationClientId = 1 and CreationStoreOrderId is not null
)
select o.Id as StoreOrderId, cu.Id as CustomerId, 1 as SsoUserId, null as SsoProfile, gc.GiftCardCouponCode, c.ClientId, c.ClientKey, cpm.ProductSku,
gc.Amount, gc.SenderName, gc.SenderEmail, gc.[Message] as SenderMessage, gc.RecipientName, gc.RecipientEmail,
case when psa.SpecificAttributeValue is null then 1 else 3 end as CouponTypeId
from wonderbox.Orders o
inner join paidOrders po on po.Id = o.Id
inner join wonderbox.OrderItems oi on oi.OrderId = o.Id
inner join wonderbox.Products p on p.Id = oi.ProductId
inner join wonderbox.GiftCards gc on gc.PurchasedWithOrderItemId = oi.Id
inner join wonderbox.Customers cu on o.CustomerId = cu.Id
inner join Client_Product_Map cpm on cpm.ClientId = 1 and cpm.ProductSku = p.Sku
inner join Client c on c.ClientId = cpm.ClientId
inner join wonderbox.ProductSpecificAttributes psa on psa.ProductId = oi.ProductId and psa.SpecificAttributeName = 'WorkFlowPrepaid'
where OrderStatusId = 30 and PaymentStatusId = 30;