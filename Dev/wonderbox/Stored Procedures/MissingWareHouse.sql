CREATE procedure [wonderbox].[MissingWareHouse]
	@mode int
as
begin

declare @missingWH table
(
	[ClientId] [int],
	[OrderId] [varchar](50),
	[SsoUserId] [int],
	[OrderDate] [datetime],
	[ItemId] [int],
	[ProductId] [int],
	[Sku] [nvarchar](400) NULL,
	[Quantity] [int],
	[Price] [decimal](18, 4),
	[ProductName] [nvarchar](400),
	[Description] [varchar](max),
	[Token] [varchar](50),
	[SerialNo] [varchar](50),
	[CreatedOn] [datetime],
	[BillingRequested] [bit],
	[PaymentMethod] [varchar](100),
	[CouponUsedValue] [decimal](18, 4)
);

insert into @missingWH (ClientId, OrderId, SsoUserId, OrderDate, ItemId, ProductId, Sku, Quantity, Price, ProductName, Description, Token, SerialNo, CreatedOn, BillingRequested, PaymentMethod)
select distinct fq.ClientId, fq.StoreOrderId, fqp1.SSOUserId,
fq.OrderDate, oi.Id as ItemId,
oi.ProductId as ProductId, fq.ProductSku, oi.Quantity, cast(oi.UnitPriceInclTax as money) as Price, 
pc.ProductDescription, oi.AttributeDescription as Description,
fq.token, fqi.SerialNo, fq.OrderDate, fqi.BillingRequested,
case o.PaymentMethodSystemName
when 'Payments.PayPalCustom' then 'PayPal'
when 'Payments.Unicredit' then 'Carta di credito'
else null end as PaymentMethod
from WfFinalQueue fq with (nolock)
cross apply (select cast(substring(ObjectValue, 1, charindex(',', ObjectValue) - 1) as int) as SSOUserId
from WfFinalQueueParams fqp1 with (nolock) where Token = fq.Token and ObjectName = '#userid') fqp1
inner join ProductCodes pc with (nolock) on pc.ProductSku = fq.ProductSku
inner join WfFinalQueueItems fqi with (nolock) on fqi.Token = fq.Token
inner join wonderbox.Orders o with (nolock) on o.Id = cast(fq.StoreOrderId as int)
inner join wonderbox.OrderItems oi with (nolock) on oi.OrderId = o.Id and oi.AttributeDescription like '%' + fqi.Token + (case when fqi.SerialNo = '' then '' else '.' + fqi.SerialNo end)
where fq.clientid = 1 and fq.token not in (select token from WfWareHouse with (nolock)) and fq.StateCode <> 0
and cast(fq.OrderDate as date) < cast(getdate() as date)
group by fq.ClientId, fq.StoreOrderId, fqp1.SSOUserId,
fq.OrderDate, oi.Id,
oi.ProductId, fq.ProductSku, oi.Quantity, oi.UnitPriceInclTax,
pc.ProductDescription, oi.AttributeDescription,
fq.token, fqi.SerialNo, fq.OrderDate, fqi.BillingRequested, o.PaymentMethodSystemName;

if @mode = 1
begin
	insert into dbo.WfWareHouse (ClientId, OrderId, SsoUserId, OrderDate, ItemId, ProductId, Sku, Quantity, Price, ProductName, Description, Token, SerialNo, CreatedOn, BillingRequested, PaymentMethod)
	select ClientId, OrderId, SsoUserId, OrderDate, ItemId, ProductId, Sku, Quantity, Price, ProductName, Description, Token, SerialNo, CreatedOn, BillingRequested, PaymentMethod
	from @missingWH;
end

select ClientId, OrderId, SsoUserId, OrderDate, ItemId, ProductId, Sku, Quantity, Price, ProductName, Description, Token, SerialNo, CreatedOn, BillingRequested, PaymentMethod
from @missingWH
order by OrderId asc;

end
GO
GRANT EXECUTE
    ON OBJECT::[wonderbox].[MissingWareHouse] TO [reporting]
    AS [dbo];

