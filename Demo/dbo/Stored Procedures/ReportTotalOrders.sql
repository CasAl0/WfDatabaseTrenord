CREATE procedure [dbo].[ReportTotalOrders]
	@ClientId int,
	@GroupByType int,
	@PaymentChannelId int = null,
	@DateFrom date = null,
	@DateTo date = null,
	@ShowSku bit = 0,
	@WithoutClient bit = 0,
	@WithoutProductGroup bit = 0	
as
begin

/*
@GroupByType
-------------------------
0 -> tutto
1 -> per anno
2 -> per mese
3 -> per giorno
4 -> per ora
-------------------------
*/

declare @params as varchar(1000);

set @params = dbo.ReportParameters(@ClientId, @GroupByType, @ShowSku, @WithoutClient, @WithoutProductGroup, @PaymentChannelId, null, null, @DateFrom, @DateTo);

With Orders as
(
	select
	case when @WithoutClient = 1 then 0 else c.ClientId end as ClientId,
	case when @WithoutClient = 1 then 'Tutte le piattaforme' else c.ClientDescription end as ClientDescription,	
	case when @WithoutClient = 1 then 0 else isnull(pcs.PaymentChannelId, 0) end as PaymentChannelId,
	case when @WithoutClient = 1 then '' else isnull(pcs.PaymentChannelDescription, '') end as PaymentChannelDescription,
	case when @WithoutProductGroup = 1 then 0 else pg.ProductGroupId end as ProductGroupId,
	case when @WithoutProductGroup = 1 then 'Tutti i prodotti' else pg.ProductGroupDescription end as ProductGroupDescription,
	fq.StoreOrderId,
	upper(case @GroupByType
	when 0 then ''
	when 1 then 'Anno ' + format(fq.OrderDate, 'yyyy', 'it-IT')
	when 2 then format(fq.OrderDate, 'MMMM yyyy', 'it-IT')
	when 3 then format(fq.OrderDate, 'dd/MM/yyyy', 'it-IT')
	when 4 then 'Ore ' + format(fq.OrderDate, 'HH', 'it-IT') + ' del ' + format(fq.OrderDate, 'dd/MM/yyyy', 'it-IT')
	end) as Period,
	case @GroupByType
	when 0 then ''
	when 1 then format(fq.OrderDate, 'yyyy', 'it-IT')
	when 2 then format(fq.OrderDate, 'yyyyMM', 'it-IT')
	when 3 then format(fq.OrderDate, 'yyyyMMdd', 'it-IT')
	when 4 then format(fq.OrderDate, 'yyyyMMddHH', 'it-IT')
	end as PeriodOrder,
	case when @ShowSku = 0 then '' else fq.ProductSku end as ProductSku,
	case when @ShowSku = 0 then '' else pcd.ProductDescription end as ProductDescription,	
	wh.Quantity, (wh.Quantity * wh.Price) - isnull(wh.CouponUsedValue, 0.0) as Sold,
	isnull(wh.PaymentMethod, 'n.d.') as PaymentMethod,
	case wh.PaymentMethod
	when 'Carta di credito' then 1
	when 'PayPal' then 2
	when 'Carte prepagate' then 3
	when 'Prodotto gratuito' then 4
	else 5 end as PaymentMethodOrder
	from WfFinalQueue fq with (nolock)
	inner join Client c with (nolock) on c.ClientId = fq.ClientId
	inner join ProductCodes pcd with (nolock) on pcd.ProductSku = fq.ProductSku
	inner join WfWareHouse wh with (nolock) on wh.Token = fq.Token
	inner join ProductGroup pg with (nolock) on pg.ProductGroupId = pcd.ProductGroupId
	left join PaymentConfirmations pc with (nolock) on pc.StoreOrderId = fq.StoreOrderId and pc.ClientId = fq.ClientId
	left join PaymentChannels pcs with (nolock) on pcs.PaymentChannelId = pc.PaymentChannelId
	where fq.StateCode in (10, 90, 99)
	and (@ClientId = 0 or fq.ClientId = @ClientId)
	and fq.OrderDate between isnull(@DateFrom, '2000-01-01') and dateadd(d, 1, isnull(@DateTo,  getdate()))
	and (@PaymentChannelId = 0 or pc.PaymentChannelId = isnull(@PaymentChannelId, pc.PaymentChannelId))
)
select distinct
o.ClientId, o.ClientDescription,
o.PaymentChannelId, o.PaymentChannelDescription,
o.ProductGroupId, o.ProductGroupDescription,
o.ProductSku, o.ProductDescription,
count(distinct(o.StoreOrderId)) as OrdersNo,
isnull(sum(o.Quantity), 0) as ProductQuantity,
isnull(sum(o.Sold), 0.0) as Sold,
o.PaymentMethod, o.PaymentMethodOrder,
o.Period, o.PeriodOrder,
@params as SearchParameters
from Orders o
group by o.ClientId, o.ClientDescription, o.PaymentChannelId, o.PaymentChannelDescription,
o.ProductGroupId, o.ProductGroupDescription, o.ProductSku, o.ProductDescription,
o.PaymentMethod, o.PaymentMethodOrder, o.Period, o.PeriodOrder;

end
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[ReportTotalOrders] TO [reporting]
    AS [dbo];

