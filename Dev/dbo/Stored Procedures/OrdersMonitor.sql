CREATE procedure [dbo].[OrdersMonitor]
as
begin

 -- ERRATI + IN STALLO
select case fq.StateCode when 90 then 'KO' when 99 then 'ANNULLATO MAN.'
when 1 then 'PRELAVORAZIONE' when 2 then 'IN STALLO' when 3 then (case when fq.ErrorLog is null then 'IN LAVORAZIONE' else 'ERRATO' end) end as Stato, fq.ProductSku,
fq.ClientId, fq.Token, fq.OrderDate, fq.LegacyOrderId, wh.SerialNo, fq.StoreOrderId, fq.ErrorLog, replace(wh.Description, '<br />', ' ') as Description,
fq.UserLastname + ' ' + fq.UserFirstname + ' - ' + fq.UserEmail as UserData, wh.PaymentMethod, wh.Quantity * wh.Price as Price
from WfFinalQueue fq with (nolock) inner join WfWareHouse wh with (nolock) on wh.token = fq.token
where fq.StateCode in (1, 2, 3, 90)
and cast(fq.OrderDate as date) > '2016-06-15'
order by fq.orderdate desc

--select * from Mail with (nolock) where status = 'N'

end
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[OrdersMonitor] TO [reporting]
    AS [dbo];

