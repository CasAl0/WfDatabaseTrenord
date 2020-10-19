
CREATE VIEW [dbo].[CouponInfoForLegacy]
AS
SELECT      c.CouponId,
            c.CouponCode,
            fq.Token,
            fq.UserId AS SsoUserId,
            COALESCE(fq.UserFirstname, 'Anonimo') AS UserFirstname,
            COALESCE(fq.UserLastname, 'Anonimo') AS UserLastname,
            fq.UserEmail,
            fq.ClientId,
            fq.StoreOrderId,
            wh.Quantity * wh.Price AS Price
  FROM      WfFinalQueue AS fq
 INNER JOIN Coupons AS c
    ON c.CreationToken = fq.Token
 INNER JOIN WfWareHouse AS wh
    ON wh.Token        = fq.Token
 WHERE      fq.StateCode = 10
   AND      fq.LegacyOrderId IS NULL

UNION

SELECT      DISTINCT c.CouponId,
                     c.CouponCode,
                     NULL AS Token,
                     fq.UserId AS SsoUserId,
                     COALESCE(fq.UserFirstname, 'Anonimo') AS UserFirstname,
                     COALESCE(fq.UserLastname, 'Anonimo') AS UserLastname,
                     fq.UserEmail,
                     fq.ClientId,
                     fq.StoreOrderId,
                     -cuh.Value AS Price
  FROM      CouponsUsageHistory AS cuh
 INNER JOIN Coupons AS c
    ON c.CouponId       = cuh.CouponId
 INNER JOIN WfFinalQueue AS fq
    ON cuh.ClientId     = fq.ClientId
   AND cuh.StoreOrderId = fq.StoreOrderId
 INNER JOIN WfWareHouse AS wh
    ON wh.Token         = fq.Token

 WHERE      cuh.LegacyOrderId IS NULL

 GROUP BY c.CouponId,
          c.CouponCode,
          fq.UserId,
          fq.UserFirstname,
          fq.UserLastname,
          fq.UserEmail,
          fq.ClientId,
          fq.StoreOrderId,
          cuh.Value;






