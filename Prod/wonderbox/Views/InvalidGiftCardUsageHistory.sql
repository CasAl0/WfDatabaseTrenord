

create view wonderbox.InvalidGiftCardUsageHistory
as
select gcuh.Id as GiftCardUsageHistoryId, o.Id as OrderId from wonderbox.Orders o
inner join wonderbox.GiftCardUsageHistory gcuh on gcuh.UsedWithOrderId = o.Id
left join WfFinalQueue fq on cast(fq.StoreOrderId as int) = o.Id and fq.StoreOrderId is not null and fq.ClientId = 1 
where o.OrderStatusId = 40 and o.PaymentStatusId = 50
and fq.Token is null
