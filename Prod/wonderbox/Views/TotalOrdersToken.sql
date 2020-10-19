






CREATE view [wonderbox].[TotalOrdersToken]
as
With VistaBase as
(
	select 
	I.Id as ItemId,
	I.ProductId,
	PAM.Id as AttributeId,
	I.AttributeDescription,
	cast(I.AttributesXml as xml) as AttributesXml
	from wonderbox.OrderItems I
	inner join dbo.PaidOrders O with (nolock) on O.StoreOrderId = I.OrderId and O.ClientId = 1 and O.Paid = 1
	inner join wonderbox.ProductAttributeMappings PAM with (nolock) on I.ProductId = PAM.ProductId
	inner join wonderbox.ProductAttributes PA with (nolock) on PAM.ProductAttributeId = PA.Id and PA.Id = 21
)
SELECT v.ItemId,
	left(convert(varchar(5000), m.c.query('ProductVariantAttributeValue/Value/text()')),32) as Token,
	substring(convert(varchar(5000), m.c.query('ProductVariantAttributeValue/Value/text()')),34,100) as SerialNo
FROM VistaBase as V
	outer apply V.AttributesXml.nodes('/Attributes/ProductVariantAttribute') as m(c)
WHERE AttributeId = m.c.value('@ID', 'int') 



















