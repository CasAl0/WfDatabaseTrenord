


CREATE VIEW [wonderbox].[TotalOrdersToken]
AS
WITH VistaBase
  AS (
     SELECT      I.Id AS ItemId,
                 I.ProductId,
                 PAM.Id AS AttributeId,
                 I.AttributeDescription,
                 CAST(I.AttributesXml AS XML) AS AttributesXml
       FROM      wonderbox.OrderItems I
      INNER JOIN dbo.PaidOrders O WITH (NOLOCK)
         ON O.StoreOrderId         = I.OrderId
        AND O.ClientId             = 1
        AND O.Paid                 = 1
      INNER JOIN wonderbox.ProductAttributeMappings PAM WITH (NOLOCK)
         ON I.ProductId            = PAM.ProductId
      INNER JOIN wonderbox.ProductAttributes PA WITH (NOLOCK)
         ON PAM.ProductAttributeId = PA.Id
        AND PA.Id                  = 21)
SELECT       V.ItemId,
             LEFT(CONVERT(VARCHAR(5000), m.c.query('ProductVariantAttributeValue/Value/text()')), 32) AS Token,
             SUBSTRING(CONVERT(VARCHAR(5000), m.c.query('ProductVariantAttributeValue/Value/text()')), 34, 100) AS SerialNo
  FROM       VistaBase AS V
 OUTER APPLY V.AttributesXml.nodes('/Attributes/ProductVariantAttribute') AS m(c)
 WHERE       AttributeId = m.c.value('@ID', 'int')
UNION
SELECT      oi.Id,
            fq.Token,
            '' AS SerialNo
  FROM      dbo.PaidOrders AS po
 INNER JOIN dbo.WfFinalQueue AS fq
    ON fq.StoreOrderId = po.StoreOrderId
 INNER JOIN wonderbox.OrderItems AS oi
    ON fq.StoreOrderId = oi.OrderId
 WHERE      fq.ProductSku = 'CP-00001';