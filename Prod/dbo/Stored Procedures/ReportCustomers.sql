CREATE procedure [dbo].[ReportCustomers]
	@ClientId int,
	@ProductGroupId int = 0,
	@Sku char(8) = '',
	@DateFrom date = null,
	@DateTo date = null
as
begin

declare @params as varchar(1000);

set @params = dbo.ReportParameters(@ClientId, null, null, null, null, null, @ProductGroupId, @Sku, @DateFrom, @DateTo);

select wh.SsoUserId, ltrim(rtrim(fq.UserLastname)) as LastName, ltrim(rtrim(fq.UserFirstname)) as FirstName, ltrim(rtrim(fq.UserEmail)) as Email,
isnull(sum(wh.Quantity), 0) as Quantity, isnull(sum((wh.Quantity * wh.Price) - isnull(wh.CouponUsedValue, 0.0)), 0) as Price,
c.ClientId, c.ClientDescription, pc.ProductSku, pc.ProductDescription, pg.ProductGroupId, pg.ProductGroupDescription,
@params as SearchParameters
from WfFinalqueue fq with (nolock)
inner join WfWareHouse wh with (nolock) on wh.Token = fq.Token
inner join Client c with (nolock) on c.ClientId = fq.ClientId
inner join ProductCodes pc with (nolock) on pc.ProductSku = fq.ProductSku
inner join ProductGroup pg with (nolock) on pg.ProductGroupId = pc.ProductGroupId
where fq.StateCode in (10, 90, 99)
and (@ClientId = 0 or fq.ClientId = @ClientId)
and (@ProductGroupId = 0 or pg.ProductGroupId = @ProductGroupId)
and (len(@Sku) = 0 or pc.ProductSku = @Sku)
and fq.OrderDate between isnull(@DateFrom, '2000-01-01') and dateadd(d, 1, isnull(@DateTo,  getdate()))
group by wh.SsoUserId, fq.UserLastname, fq.UserFirstname, fq.UserEmail,
c.ClientId, c.ClientDescription, pc.ProductSku, pc.ProductDescription, pg.ProductGroupId, pg.ProductGroupDescription
order by LastName asc, FirstName asc
end
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[ReportCustomers] TO [reporting]
    AS [dbo];

