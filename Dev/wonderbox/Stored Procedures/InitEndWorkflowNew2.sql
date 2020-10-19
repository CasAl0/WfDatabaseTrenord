CREATE PROCEDURE [wonderbox].[InitEndWorkflowNew2]
AS
BEGIN

    PRINT 'START - ' + CONVERT(VARCHAR, GETDATE(), 108);

    DECLARE @tokenItems TABLE (Token VARCHAR(32) NOT NULL,
                               SerialNo VARCHAR(50) NOT NULL,
                               BillingRequested BIT NULL,
                               OrderId INT NOT NULL,
                               OrderDate DATETIME NOT NULL,
                               ProductName NVARCHAR(400) NOT NULL);

    DECLARE @ids TABLE (Id VARCHAR(50) NOT NULL);

    DECLARE @finalizeTokenDays INT;

    SELECT @finalizeTokenDays = -FinalizeTokenDays
      FROM dbo.WfConfiguration WITH (NOLOCK)
     WHERE [Current] = 1;

    DELETE FROM dbo.PaidOrders
     WHERE OrderDate < DATEADD(d, @finalizeTokenDays, GETDATE());

    PRINT 'PULIZIA ORDINI PAGATI - ' + CONVERT(VARCHAR, GETDATE(), 108);

    INSERT INTO dbo.PaidOrders (ClientId,
                                StoreOrderId,
                                OrderDate,
                                BillingAddressId,
                                CustomerId,
                                PaymentMethodSystemName)
    SELECT 1,
           Id,
           DATEADD(mi, DATEDIFF(mi, GETUTCDATE(), GETDATE()), CreatedOnUtc) AS OrderDate,
           BillingAddressId,
           CustomerId,
           PaymentMethodSystemName
      FROM wonderbox.Orders
     WHERE OrderStatusId   = 30
       AND PaymentStatusId = 30
       AND CreatedOnUtc    > DATEADD(d, @finalizeTokenDays, GETUTCDATE())
    EXCEPT
    SELECT ClientId,
           CAST(StoreOrderId AS INT),
           OrderDate,
           BillingAddressId,
           CustomerId,
           PaymentMethodSystemName
      FROM dbo.PaidOrders;

    PRINT 'INSERIMENTO ORDINI PAGATI - ' + CONVERT(VARCHAR, GETDATE(), 108);

    INSERT INTO @ids (Id)
    SELECT StoreOrderId
      FROM dbo.PaidOrders
     WHERE ClientId = 1
    EXCEPT
    SELECT StoreOrderId
      FROM dbo.WfFinalQueue WITH (NOLOCK)
     WHERE ClientId = 1
       AND StoreOrderId IS NOT NULL;

    PRINT 'ORDINI - ' + CONVERT(VARCHAR, GETDATE(), 108);

    DECLARE @idsNo INT;

    SELECT @idsNo = COUNT(*)
      FROM @ids;

    IF @idsNo > 0
    BEGIN;
        WITH Pending
          AS (SELECT      o.StoreOrderId,
                          o.OrderDate,
                          oi.BillingRequested,
                          p.Name AS ProductName,
                          CAST(CAST(REPLACE(
                                        oi.AttributesXml,
                                        '<ProductVariantAttribute ID="' + CAST(pam.Id AS VARCHAR(10)) + '">',
                                        '<ProductVariantAttribute ID="WFTOKEN">') AS XML).query(
                                                                                              '/Attributes[1]/ProductVariantAttribute[@ID="WFTOKEN"]/ProductVariantAttributeValue[1]/Value[1]/text()') AS VARCHAR(100)) AS Attributes
                FROM      @ids AS i
               INNER JOIN dbo.PaidOrders AS o
                  ON o.StoreOrderId         = i.Id
                 AND o.ClientId             = 1
               INNER JOIN wonderbox.OrderItems AS oi
                  ON oi.OrderId             = o.StoreOrderId
               INNER JOIN wonderbox.Products AS p
                  ON p.Id                   = oi.ProductId
               INNER JOIN wonderbox.ProductAttributeMappings AS pam
                  ON p.Id                   = pam.ProductId
                 AND pam.ProductAttributeId = 21) -- 21 è l'ID della tabella ProductAttribute contenente [IdOrdine]
        INSERT INTO @tokenItems (OrderId,
                                 OrderDate,
                                 BillingRequested,
                                 ProductName,
                                 Token,
                                 SerialNo)
        SELECT      pg.StoreOrderId,
                    pg.OrderDate,
                    pg.BillingRequested,
                    pg.ProductName,
                    pg.Token,
                    pg.SerialNo
          FROM      dbo.WfFinalQueue AS fq
         INNER JOIN (   SELECT StoreOrderId,
                               OrderDate,
                               BillingRequested,
                               ProductName,
                               LEFT(Attributes, 32) AS Token,
                               SUBSTRING(Attributes, 34, 100) AS SerialNo
                          FROM Pending) AS pg
            ON fq.Token = pg.Token
         WHERE      fq.StateCode = 0;

        PRINT 'INFORMAZIONI ORDINI - ' + CONVERT(VARCHAR, GETDATE(), 108);

        WITH PendingGiftCardsToRegister
          AS (SELECT      o.StoreOrderId,
                          o.OrderDate,
                          oi.BillingRequested,
                          p.Name AS ProductName,
                          cp.CreationToken
                FROM      @ids AS i
               INNER JOIN dbo.PaidOrders AS o
                  ON o.StoreOrderId              = i.Id
                 AND o.ClientId                  = 1
               INNER JOIN wonderbox.OrderItems AS oi
                  ON oi.OrderId                  = o.StoreOrderId
               INNER JOIN wonderbox.GiftCards AS gc
                  ON gc.PurchasedWithOrderItemId = oi.Id
               INNER JOIN wonderbox.Products AS p
                  ON p.Id                        = oi.ProductId
               INNER JOIN dbo.Coupons AS cp
                  ON cp.CouponCode               = gc.GiftCardCouponCode COLLATE Latin1_General_CS_AI)
        INSERT INTO @tokenItems (OrderId,
                                 OrderDate,
                                 BillingRequested,
                                 ProductName,
                                 Token,
                                 SerialNo)
        SELECT      pg.StoreOrderId,
                    pg.OrderDate,
                    pg.BillingRequested,
                    pg.ProductName,
                    pg.CreationToken,
                    ''
          FROM      dbo.WfFinalQueue AS fq
         INNER JOIN PendingGiftCardsToRegister AS pg
            ON fq.Token = pg.CreationToken
         WHERE      fq.StateCode = 0;

        PRINT 'INFORMAZIONI NUOVI COUPON - ' + CONVERT(VARCHAR, GETDATE(), 108);

        INSERT INTO dbo.WfFinalQueueItems (Token,
                                           SerialNo,
                                           BillingRequested)
        SELECT Token,
               SerialNo,
               BillingRequested
          FROM @tokenItems;

        PRINT 'INSERIMENTO ITEMS - ' + CONVERT(VARCHAR, GETDATE(), 108);

        UPDATE WfFinalQueue
           SET WfFinalQueue.StateCode = 1,
               WfFinalQueue.StoreOrderId = a.OrderId,
               WfFinalQueue.OrderDate = a.OrderDate,
               WfFinalQueue.ProductName = a.ProductName
          FROM @tokenItems AS a
         WHERE WfFinalQueue.Token = a.Token;

        PRINT 'FINALIZZAZIONI IN PRELAVORAZIONE - ' + CONVERT(VARCHAR, GETDATE(), 108);

        INSERT INTO dbo.CouponsUsageHistory (CouponId,
                                             ClientId,
                                             StoreOrderId,
                                             Value)
        SELECT      c.CouponId,
                    c.CreationClientId,
                    gcuh.UsedWithOrderId,
                    gcuh.UsedValue
          FROM      @ids AS i
         INNER JOIN wonderbox.GiftCardUsageHistory AS gcuh
            ON gcuh.UsedWithOrderId = i.Id
         INNER JOIN wonderbox.GiftCards AS gc
            ON gc.Id                = gcuh.GiftCardId
         INNER JOIN dbo.Coupons AS c
            ON c.CouponCode         = gc.GiftCardCouponCode COLLATE Latin1_General_CS_AI
           AND c.CreationClientId   = 1
        EXCEPT
        SELECT CouponId,
               ClientId,
               StoreOrderId,
               Value
          FROM dbo.CouponsUsageHistory;

        PRINT 'ALLINEAMENTO STORICO UTILIZZI COUPON - ' + CONVERT(VARCHAR, GETDATE(), 108);
    END;

    DELETE FROM @ids;

    PRINT 'PULIZIA TABELLA TEMPORANEA @ids - ' + CONVERT(VARCHAR, GETDATE(), 108);

    DELETE FROM @tokenItems;

    PRINT 'PULIZIA TABELLA TEMPORANEA @tokenItems - ' + CONVERT(VARCHAR, GETDATE(), 108);
END;