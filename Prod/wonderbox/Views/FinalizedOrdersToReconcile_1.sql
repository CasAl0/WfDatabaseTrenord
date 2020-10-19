
CREATE VIEW [wonderbox].[FinalizedOrdersToReconcile]
AS
    SELECT DISTINCT CAST(O.Id AS BIGINT) AS NumeroOrdine ,
           DATEADD(mi, DATEDIFF(mi, GETUTCDATE(), GETDATE()), O.CreatedOnUtc) AS DataInserimento ,
           O.OrderStatusId AS IdStato ,
           O.PaymentStatusId AS IdStatoBanca
	FROM   wonderbox.Orders AS O
           INNER JOIN dbo.WfFinalQueue AS FQ ON CAST(FQ.StoreOrderId AS BIGINT) = O.Id
                                             AND FQ.ClientId = 1
                                             AND FQ.StateCode = 10
    WHERE  O.PaymentStatusId = 50
           AND O.PaymentMethodSystemName = 'Payments.Unicredit'
           AND DATEADD(
                   mi ,DATEDIFF(mi, GETUTCDATE(), GETDATE()), O.CreatedOnUtc) < DATEADD(
                                                                                    mi ,
                                                                                    -10,
                                                                                    GETDATE());