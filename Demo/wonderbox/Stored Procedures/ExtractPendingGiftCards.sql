
CREATE PROCEDURE [wonderbox].[ExtractPendingGiftCards]
AS
    BEGIN
        SET NOCOUNT ON;

        WITH paidOrders
        AS ( SELECT o2.StoreOrderId
             FROM   dbo.PaidOrders o2
             WHERE  o2.ClientId = 1
                    AND o2.Paid = 1
             EXCEPT
             SELECT CreationStoreOrderId AS StoreOrderId
             FROM   Coupons WITH ( NOLOCK )
             WHERE  CreationClientId = 1
                    AND CreationStoreOrderId IS NOT NULL )
        SELECT   CAST(o.StoreOrderId AS INT) AS StoreOrderId ,
                 cu.Id AS CustomerId ,
                 NULL AS SsoUserId ,
                 NULL AS SsoProfile ,
                 gc.GiftCardCouponCode ,
                 c.ClientId ,
                 c.ClientKey ,
                 p.Sku AS ProductSku ,
                 gc.Amount ,
                 gc.SenderName ,
                 gc.SenderEmail ,
                 gc.[Message] AS SenderMessage ,
                 gc.RecipientName ,
                 gc.RecipientEmail ,
                 CASE WHEN psa.SpecificAttributeValue IS NULL THEN 1
                      ELSE 3
                 END AS CouponTypeId
        FROM     dbo.PaidOrders o
                 INNER JOIN paidOrders po ON po.StoreOrderId = o.StoreOrderId
                 INNER JOIN wonderbox.OrderItems oi ON oi.OrderId = o.StoreOrderId
                 INNER JOIN wonderbox.Products p ON p.Id = oi.ProductId
                 INNER JOIN wonderbox.GiftCards gc ON gc.PurchasedWithOrderItemId = oi.Id
                 INNER JOIN wonderbox.Customers cu ON o.CustomerId = cu.Id
                 INNER JOIN Client c ON c.ClientId = 1
                 LEFT JOIN wonderbox.ProductSpecificAttributes psa ON psa.ProductId = oi.ProductId
                                                                      AND psa.SpecificAttributeName = 'WorkFlowPrepaid'
        WHERE    o.ClientId = 1
                 AND o.Paid = 1
                 AND p.Sku IS NOT NULL
        ORDER BY o.StoreOrderId ASC;

    END;