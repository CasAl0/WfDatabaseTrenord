CREATE PROCEDURE [trenordapp].[StrangeOrders]
AS
    BEGIN
        --update WfWareHouse set price = price / quantity where token in (
        SELECT wf.Token ,
               wf.Provenienza ,
               wf.NumeroOrdineProvenienza ,
               vo.NumeroOrdine ,
               vo.TotaleIvaInclusa ,
               wf.totalewf
        FROM   tln.vol_ordine AS vo
               INNER JOIN (   SELECT   fq.LegacyOrderId AS notln ,
                                       SUM(wh.Price * wh.Quantity) AS totalewf ,
                                       fq.Token ,
                                       'APP' AS Provenienza ,
                                       fq.StoreOrderId AS NumeroOrdineProvenienza
                              FROM     WfFinalQueue AS fq WITH ( NOLOCK )
                                       INNER JOIN WfWareHouse AS wh WITH ( NOLOCK ) ON wh.Token = fq.Token
                              WHERE    fq.ClientId = 2
                              GROUP BY fq.LegacyOrderId ,
                                       fq.Token ,
                                       fq.StoreOrderId
                          ) AS wf ON wf.notln = vo.NumeroOrdine
        WHERE  wf.totalewf <> vo.TotaleIvaInclusa;
    --)
    END;
GO
GRANT EXECUTE
    ON OBJECT::[trenordapp].[StrangeOrders] TO [reporting]
    AS [dbo];

