CREATE VIEW [dbo].[CarnetAttivi]
--WITH ENCRYPTION, SCHEMABINDING, VIEW_METADATA
AS
SELECT wfqt.Token,
       wfqt.StoreOrderId,
       wfqt.LegacyOrderId,
       wfqt.CounterfoilPNR,
       SUM(CAST(wfqt.Available AS INT)) AS Rimanenti,
       YEAR(wfqt.LastChangeDate) AS YYYY
  FROM dbo.WfFinalQueueTickets AS wfqt
 WHERE wfqt.SingleTicketToken IS NULL
 GROUP BY wfqt.Token,
          wfqt.StoreOrderId,
          wfqt.LegacyOrderId,
          wfqt.CounterfoilPNR,
          YEAR(wfqt.LastChangeDate)
HAVING SUM(CAST(wfqt.Available AS INT)) > 0
 --ORDER BY YYYY, Rimanenti DESC;
-- WITH CHECK OPTION