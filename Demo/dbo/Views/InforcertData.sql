
CREATE VIEW [dbo].[InforcertData]
AS
SELECT      WareHouseId,
            w.OrderId,
            w.ItemId,
            w.ClientId,
            REPLACE(
                i.InvoiceNumber,
                '/' + CONVERT(VARCHAR(4), (YEAR(GETDATE()))),
                '/' + CONVERT(VARCHAR(2), (YEAR(GETDATE()) - 2000))) AS ProgressivoInvio,
            CASE
                 WHEN i.VatNumber IS NULL
                  AND i.FiscalCode IS NOT NULL
                  AND UPPER(i.TwoLetterIsoCode) = 'IT' THEN UPPER(COALESCE(i.PecEmail, '0000000'))
                 WHEN UPPER(i.TwoLetterIsoCode) <> 'IT' THEN 'XXXXXXX'
                 ELSE UPPER(COALESCE(i.PecEmail, i.TargetCode)) END AS CodiceDestinatario,
            i.TwoLetterIsoCode AS IdPaese,
            UPPER(REPLACE(i.VatNumber, ' ', '')) AS PartitaIva,
            UPPER(REPLACE(i.FiscalCode, ' ', '')) AS CodiceFiscale,
            UPPER(REPLACE(SUBSTRING(RTRIM(LTRIM(i.Recipient)), 1, 70), '’', '''')) AS Denominazione,
            UPPER(REPLACE(SUBSTRING(RTRIM(LTRIM(i.[Address])), 1, 50), '’', '''')) AS Indirizzo,
            CASE
                 WHEN UPPER(i.TwoLetterIsoCode) = 'IT' THEN CASE
                                                                 WHEN TRY_PARSE(i.ZipCode AS INT) IS NULL THEN '99999'
                                                                 ELSE RIGHT('99999' + REPLACE(i.ZipCode, ' ', '9'), 5)END
                 ELSE '99999' END AS Cap,
            UPPER(REPLACE(SUBSTRING(RTRIM(LTRIM(i.City)), 1, 50), '’', '''')) AS Comune,
            CASE
                 WHEN UPPER(i.TwoLetterIsoCode) = 'IT' THEN UPPER(i.Province)
                 ELSE 'EE' END AS Provincia,
            i.TwoLetterIsoCode AS Nazione,
            CONVERT(VARCHAR(10), i.PdfDateInvoice, 120) AS DataEmissioneFattura,
            'ONLINE ' + i.InvoiceNumber AS NumeroFattura,
            CAST((SUM(w.Price * w.Quantity) OVER (PARTITION BY w.OrderId)) AS DECIMAL(18, 2)) AS ImportoTotaleDocumento,

            --MODIFICA DEL 26.02.2019
            --'e-Store Trenord - Fattura N° ' + i.InvoiceNumber AS Causale,
            'e-Store Trenord - Ordine ' + w.OrderId AS Causale,
            ROW_NUMBER() OVER (PARTITION BY i.OrderId ORDER BY i.OrderId, w.ItemId) AS NumeroLinea,
            UPPER(REPLACE(REPLACE(SUBSTRING(LTRIM(RTRIM(w.ProductName)), 1, 90), '’', ''''), '€', '')) AS Descrizione,
            CAST(w.Quantity AS DECIMAL(18, 2)) AS Quantita,
            ROUND(CAST(((100 * w.Price) / (100 + r.VateRate)) AS DECIMAL(18, 8)), 2) AS PrezzoUnitario,
            --ROUND(CAST((CAST(((100 * w.Price) / (100 + r.VateRate)) AS DECIMAL(18, 8)) * w.Quantity) AS DECIMAL(18, 8)), 2) AS PrezzoTotale,			
            ROUND(CAST(((100 * w.Price) / (100 + r.VateRate)) AS DECIMAL(18, 8)), 2) * w.Quantity AS PrezzoTotale,
            r.VateRate AS AliquotaIva
  FROM      dbo.WfWareHouse AS w
 INNER JOIN dbo.InvoicesFatturazioneEStaging AS i
    ON i.OrderId    = w.OrderId
 INNER JOIN dbo.WfVatRates AS r
    ON r.ProductSku = w.Sku
 WHERE      w.BillingRequested = 1

/* IN CASO SERVANO CONDIZIONI PIU' COMPLESSE  */
--AND CONVERT(INT, SUBSTRING(i.InvoiceNumber, CHARINDEX('/', i.InvoiceNumber) + 1, 5)) = YEAR(GETDATE())
--AND CAST(i.PdfDateInvoice AS DATE) = '20191027'
--AND i.InvoiceNumber IN ('47557/2019')
;