CREATE PROCEDURE [wonderbox].[StrangeOrders]
AS
    BEGIN

        SELECT   fq2.Token ,
                 fq2.ProductSku ,
                 fq2.ProductName ,
                 fq2.OrderDate ,
                 fq2.StoreOrderId ,
                 REPLACE(wh2.Description, '<br />', CHAR(13) + CHAR(10)) AS Description ,
                 wh2.SsoUserId ,
                 fq2.UserFirstname ,
                 fq2.UserLastname ,
                 fq2.UserEmail ,
                 fq2.OrderSmsNumber ,
                 fq2.ReleaseDate ,
                 fq2.ReleasePlace ,
                 wh2.Quantity ,
                 wh2.Price ,
                 fq2.LegacyOrderId ,
                 wh2.SerialNo ,
                 wh2.PaymentMethod
        FROM     WfFinalQueue AS fq2
                 INNER JOIN WfWareHouse AS wh2 ON wh2.Token = fq2.Token
                                                  AND fq2.StoreOrderId IN (   SELECT   wh.OrderId
                                                                              FROM     tln.vol_ordine AS vo WITH ( NOLOCK )
                                                                                       INNER JOIN WfFinalQueue AS fq WITH ( NOLOCK ) ON fq.LegacyOrderId = vo.NumeroOrdine
                                                                                                                                        AND fq.ClientId = 1
                                                                                       INNER JOIN WfWareHouse AS wh WITH ( NOLOCK ) ON wh.Token = fq.Token
                                                                                       INNER JOIN wonderbox.Orders AS o WITH ( NOLOCK ) ON o.Id = CAST(fq.StoreOrderId AS INT)
                                                                              GROUP BY wh.OrderId ,
                                                                                       wh.OrderDate ,
                                                                                       wh.Sku ,
                                                                                       vo.TotaleIvaInclusa ,
                                                                                       vo.NumeroOrdine ,
                                                                                       o.OrderSubTotalInclTax
                                                                              HAVING   vo.TotaleIvaInclusa <> SUM(wh.Quantity
                                                                                                                  * wh.Price))
        ORDER BY fq2.OrderDate DESC;
    END;
GO
GRANT EXECUTE
    ON OBJECT::[wonderbox].[StrangeOrders] TO [reporting]
    AS [dbo];

