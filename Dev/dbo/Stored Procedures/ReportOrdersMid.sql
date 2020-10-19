CREATE procedure [dbo].[ReportOrdersMid]
	@ClientId int,
	@ProductGroupId int = 0,
	@DateFrom date = null,
	@DateTo date = null
as
begin

declare @params as varchar(1000);

set @params = dbo.ReportParameters(@ClientId, null, null, null, null, null, @ProductGroupId, null, @DateFrom, @DateTo);

select fq.ClientId, c.ClientDescription, fq.StoreOrderId, wh.PaymentMethod, fq.OrderDate,
cast(sum(wh.Quantity * wh.Price) as money) as TotalPrice,
fq.UserLastname, fq.UserFirstname, fq.UserEmail, coalesce(fq.OrderSmsNumber, '') as OrderSmsNumber,
pg.ProductGroupId, pg.ProductGroupDescription, @params as SearchParameters
from WfFinalQueue fq with (nolock)
inner join WfWareHouse wh with (nolock) on wh.Token = fq.Token
inner join ProductCodes pc with (nolock) on pc.ProductSku = fq.ProductSku
inner join ProductGroup pg with (nolock) on pg.ProductGroupId = pc.ProductGroupId
inner join Client c with (nolock) on c.ClientId = fq.ClientId
where fq.StateCode in (10, 90, 99)
and (@ClientId = 0 or fq.ClientId = @ClientId)
and (@ProductGroupId = 0 or pg.ProductGroupId = @ProductGroupId)
and fq.OrderDate between isnull(@DateFrom, '2000-01-01') and dateadd(d, 1, isnull(@DateTo,  getdate()))
group by fq.ClientId, c.ClientDescription, fq.StoreOrderId, wh.PaymentMethod, fq.OrderDate,
fq.UserLastname, fq.UserFirstname, fq.UserEmail, fq.OrderSmsNumber,
pg.ProductGroupId, pg.ProductGroupDescription
order by fq.OrderDate asc, fq.ClientId asc, fq.StoreOrderId asc, pg.ProductGroupId asc;

end
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[ReportOrdersMid] TO [reporting]
    AS [dbo];

