CREATE VIEW [dbo].[WareHouseData]
AS
SELECT      wh.OrderId,
            wh.WareHouseId,
            wh.ClientId,
            wh.SsoUserId,
            wh.OrderDate,
            wh.ItemId,
            wh.ProductId,
            wh.Sku,
            wh.Quantity,
            wh.Price,
            wh.ProductName,
            wh.[Description],
            wh.Token,
            wh.SerialNo,
            wh.CreatedOn,
            wh.BillingRequested,
            wh.PaymentMethod,
            wh.PaymentTransactionId,
            fq.LegacyOrderId,
            COALESCE(fq.UserLastname, 'ANONIMO') AS UserLastname,
            COALESCE(fq.UserFirstname, 'ANONIMO') AS UserFirstname,
            fq.UserEmail,
            fq.OrderSmsNumber,
            fq.UserProfile
  FROM      dbo.WfWareHouse AS wh WITH (NOLOCK)
 INNER JOIN dbo.WfFinalQueue AS fq WITH (NOLOCK)
    ON fq.Token = wh.Token
   AND fq.StateCode IN (10, 90, 99);



