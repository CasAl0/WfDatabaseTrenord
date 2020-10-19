CREATE PROCEDURE [dbo].[PrepareElectronicInvoicing]
--@PdfDateInvoice AS DATE
AS
TRUNCATE TABLE dbo.InvoicesFatturazioneEStaging;

INSERT INTO dbo.InvoicesFatturazioneEStaging
SELECT      wi.*,
            c.TwoLetterIsoCode
  FROM      dbo.WfInvoices AS wi
 INNER JOIN [dbo].[Country] AS c
    ON c.[Name]           = wi.Country
    OR c.TwoLetterIsoCode = wi.Country
 WHERE      CONVERT(DATE, wi.PdfDateInvoice) = CAST((GETDATE() - 1) AS DATE) --@PdfDateInvoice
   AND      wi.FlgElectronicSend                  = 1;

--WHERE  wi.FlgElectronicSend = 1 AND wi.PdfDateInvoice < 'XXXXXXXX' AND wi.ClientId = X
--WHERE  CONVERT(DATE, wi.PdfDateInvoice) BETWEEN 'XXXXXXXX' AND 'XXXXXXXX'


/* QUERY DI CONTROLLO: TROVA TUTTE LE FATTURE CHE NON SONO STATE PROCESSATE CORRETTAMENTE E CHE VANNO RIPROCESSATE DAL BATCH */
--SELECT      COUNT(wi.OrderId)
--  FROM      dbo.WfInvoices AS wi
-- INNER JOIN dbo.Country AS c
--    ON c.[Name]           = wi.Country
--    OR c.TwoLetterIsoCode = wi.Country
-- WHERE  wi.FlgElectronicSend = 1 -- AND wi.PdfDateInvoice < 'XXXXXXXX' AND wi.ClientId = X;