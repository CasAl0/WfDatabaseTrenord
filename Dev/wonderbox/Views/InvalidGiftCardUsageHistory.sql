

CREATE VIEW [wonderbox].[InvalidGiftCardUsageHistory]
AS
    SELECT gcuh.Id AS GiftCardUsageHistoryId ,
           o.Id AS OrderId
    FROM   wonderbox.Orders AS o
           INNER JOIN wonderbox.GiftCardUsageHistory AS gcuh ON gcuh.UsedWithOrderId = o.Id
           LEFT JOIN WfFinalQueue AS fq ON CAST(fq.StoreOrderId AS INT) = o.Id
                                        AND fq.StoreOrderId IS NOT NULL
                                        AND fq.ClientId = 1
    WHERE  o.OrderStatusId = 40
           AND o.PaymentStatusId = 50
           AND fq.Token IS NULL;