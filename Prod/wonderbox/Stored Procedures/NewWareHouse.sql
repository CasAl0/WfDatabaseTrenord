
CREATE PROCEDURE [wonderbox].[NewWareHouse]
AS
BEGIN
    PRINT 'START - ' + CONVERT(VARCHAR, GETDATE(), 108);

    WITH newWareHouse
      AS (SELECT ItemId,
                 Token,
                 SerialNo
            FROM [wonderbox].[TotalOrdersToken]
          EXCEPT
          SELECT ItemId,
                 Token,
                 SerialNo
            FROM [dbo].[WfWareHouse]
           WHERE ClientId = 1)
    INSERT INTO [dbo].[WfWareHouse] (ClientId,
                                     OrderId,
                                     SsoUserId,
                                     OrderDate,
                                     ItemId,
                                     ProductId,
                                     Sku,
                                     Quantity,
                                     Price,
                                     ProductName,
                                     [Description],
                                     BillingRequested,
                                     Token,
                                     SerialNo,
                                     PaymentMethod)
    SELECT      1 AS ClientId,
                O.StoreOrderId AS OrderId,
                NULL AS SsoUserId,
                O.OrderDate,
                I.Id AS ItemId,
                I.ProductId,
                P.Sku,
                I.Quantity,
                CONVERT(DECIMAL(18, 4), (I.PriceInclTax / I.Quantity)) AS PriceInclTax,
                P.Name AS ProductName,
                I.AttributeDescription,
                I.BillingRequested,
                CP.CreationToken AS Token,
                '' AS SerialNo,
                CASE O.PaymentMethodSystemName
                     WHEN 'Payments.Unicredit' THEN 'Carta di credito'
                     WHEN 'Payments.PayPalCustom' THEN 'PayPal'
                     WHEN 'Payments.Satispay' THEN 'satispay'
                     ELSE 'n.d.' END AS PaymentMethod
      FROM      newWareHouse AS N
     INNER JOIN wonderbox.OrderItems AS I
        ON I.Id                        = N.ItemId
     INNER JOIN dbo.PaidOrders AS O
        ON I.OrderId                   = CAST(O.StoreOrderId AS INT)
       AND O.ClientId                  = 1
       AND O.Paid                      = 1
     INNER JOIN wonderbox.Products AS P
        ON P.Id                        = I.ProductId
     INNER JOIN wonderbox.GiftCards AS GC
        ON GC.PurchasedWithOrderItemId = I.Id
     INNER JOIN Coupons AS CP
        ON CP.CouponCode               = GC.GiftCardCouponCode COLLATE Latin1_General_CS_AI
       AND CP.CreationClientId         = 1
     WHERE      I.Quantity > 0;

    PRINT 'INSERIMENTO NUOVI DATI DI WAREHOUSE (CARTE PREPAGATE) - ' + CONVERT(VARCHAR, GETDATE(), 108);

    WITH newWareHouse
      AS (SELECT ItemId,
                 Token,
                 SerialNo
            FROM [wonderbox].[TotalOrdersToken]
          --WHERE Token <> '[TOKEN]'
          -- da usare per escludere duplicati (=> token + serialno): 
          -- accade saltuariamente con i prodotti COMITIVE per qualche strana operatività dell'utente che non siamo ancora risusciti a riprodurre.
          -- Questa modifica consente alla successiva esecuzione del batch TokenFinalizer (storefs01/storefs02) di tornare a funzionare.
          -- dopo che ha girato il bacth TokenFinalizer eseguire il batch LegacyAligner per allineare il warehouse del TLN
          EXCEPT
          SELECT ItemId,
                 Token,
                 SerialNo
            FROM [dbo].[WfWareHouse]
           WHERE ClientId = 1)
    INSERT INTO [dbo].[WfWareHouse] (ClientId,
                                     OrderId,
                                     SsoUserId,
                                     OrderDate,
                                     ItemId,
                                     ProductId,
                                     Sku,
                                     Quantity,
                                     Price,
                                     ProductName,
                                     [Description],
                                     BillingRequested,
                                     Token,
                                     SerialNo,
                                     PaymentMethod)
    SELECT      1 AS ClientId,
                O.StoreOrderId AS OrderId,
                NULL AS SsoUserId,
                O.OrderDate,
                I.Id AS ItemId,
                I.ProductId,
                P.Sku,
                I.Quantity,
                CONVERT(DECIMAL(18, 4), (I.PriceInclTax / I.Quantity)) AS PriceInclTax,
                P.Name AS ProductName,
                I.AttributeDescription,
                I.BillingRequested,
                N.Token,
                N.SerialNo,
                CASE O.PaymentMethodSystemName
                     WHEN 'Payments.Unicredit' THEN 'Carta di credito'
                     WHEN 'Payments.PayPalCustom' THEN 'PayPal'
                     WHEN 'Payments.Satispay' THEN 'satispay'
                     ELSE 'n.d.' END AS PaymentMethod
      FROM      newWareHouse AS N
     INNER JOIN wonderbox.OrderItems AS I
        ON I.Id       = N.ItemId
     INNER JOIN dbo.PaidOrders AS O
        ON I.OrderId  = CAST(O.StoreOrderId AS INT)
       AND O.ClientId = 1
       AND O.Paid     = 1
     INNER JOIN wonderbox.Products AS P
        ON P.Id       = I.ProductId
     WHERE      I.Quantity > 0;

    PRINT 'INSERIMENTO NUOVI DATI DI WAREHOUSE - ' + CONVERT(VARCHAR, GETDATE(), 108);
END;
