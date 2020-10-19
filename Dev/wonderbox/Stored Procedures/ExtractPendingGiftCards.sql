
CREATE PROCEDURE [wonderbox].[ExtractPendingGiftCards]
AS
BEGIN
	SET NOCOUNT ON;

	with paidOrders as
	(
		select o2.StoreOrderId from dbo.PaidOrders o2 where o2.ClientId = 1 and o2.Paid = 1
		except
		select CreationStoreOrderId as StoreOrderId from Coupons with (nolock) where CreationClientId = 1 and CreationStoreOrderId is not null
	)
	select cast(o.StoreOrderId as int) as StoreOrderId, cu.Id as CustomerId, null as SsoUserId, null as SsoProfile, gc.GiftCardCouponCode, c.ClientId, c.ClientKey, p.Sku as ProductSku,
	gc.Amount, gc.SenderName, gc.SenderEmail, gc.[Message] as SenderMessage, gc.RecipientName, gc.RecipientEmail,
	case when psa.SpecificAttributeValue is null then 1 else 3 end as CouponTypeId
	from dbo.PaidOrders o
	inner join paidOrders po on po.StoreOrderId = o.StoreOrderId
	inner join wonderbox.OrderItems oi on oi.OrderId = o.StoreOrderId
	inner join wonderbox.Products p on p.Id = oi.ProductId
	inner join wonderbox.GiftCards gc on gc.PurchasedWithOrderItemId = oi.Id
	inner join wonderbox.Customers cu on o.CustomerId = cu.Id
	inner join Client c on c.ClientId = 1	
	left join wonderbox.ProductSpecificAttributes psa on psa.ProductId = oi.ProductId and psa.SpecificAttributeName = 'WorkFlowPrepaid'
	where o.ClientId = 1 and o.Paid = 1
	and p.Sku is not null
	order by o.StoreOrderId asc;
	
END