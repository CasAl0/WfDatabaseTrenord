


CREATE VIEW [dbo].[v_ReportMensileVoucherStudyInMilanUtilizzati] AS
(
SELECT  Voucher ,
        ( CASE WHEN Stato = 2
                    AND ( b.ClientDescription = 'STORE' ) THEN 'IMPEGNATO'
               WHEN Stato = 2
                    AND ( b.ClientDescription <> 'STORE' ) THEN 'UTILIZZATO'
               WHEN Stato = 3 THEN 'UTILIZZATO'
               WHEN Stato = 1 THEN 'NON utilizzato'
          END ) AS Stato ,
        ChangeTracking AS [Data Utilizzo] ,
        b.ClientDescription AS [Canale Vendita] ,
        Token AS [Codice Turno]
FROM    [PromoBennet] AS a
        INNER JOIN Client AS b ON a.CanaleVendita = b.ClientId
WHERE   a.CouponTypeId = 4
        AND ChangeTracking BETWEEN '20160430 23:59:00.000'
                           AND     '20160601 03:00:00.000'
--ORDER BY ChangeTracking , Stato;
)


