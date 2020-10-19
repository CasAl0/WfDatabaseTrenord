CREATE procedure [dbo].[ReportOrdersFull]
	@ClientId int,
	@ProductGroupId int = 0,
	@Sku char(8) = '',
	@DateFrom date = null,
	@DateTo date = null
as
begin

declare @params as varchar(1000);

set @params = dbo.ReportParameters(@ClientId, null, null, null, null, null, @ProductGroupId, @Sku, @DateFrom, @DateTo);

select ofq.*, pc.ProductDescription, pg.ProductGroupId, pg.ProductGroupDescription, @params as SearchParameters
from OrdiniFinalizzati ofq 
inner join ProductCodes pc with (nolock) on pc.ProductSku = ofq.CodiceProdotto
inner join ProductGroup pg with (nolock) on pg.ProductGroupId = pc.ProductGroupId
where (@ClientId = 0 or ofq.ClientId = @ClientId)
and (@ProductGroupId = 0 or pg.ProductGroupId = @ProductGroupId)
and (len(@Sku) = 0 or pc.ProductSku = @Sku)
and ofq.DataOrdine between isnull(@DateFrom, '2000-01-01') and dateadd(d, 1, isnull(@DateTo,  getdate()))
order by ofq.DataOrdine asc;

end