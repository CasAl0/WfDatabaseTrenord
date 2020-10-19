CREATE VIEW [dbo].[FindInvoicesByNumberAndCurrentYear]
--WITH ENCRYPTION, SCHEMABINDING, VIEW_METADATA
AS
    
    WITH base
      AS (SELECT CAST(SUBSTRING(InvoiceNumber, 0, CHARINDEX('/', InvoiceNumber)) AS INT) AS InvNum,
                 *
            FROM dbo.WfInvoices
           WHERE InvoiceNumber IS NOT NULL
             AND CAST(SUBSTRING(InvoiceNumber, CHARINDEX('/', InvoiceNumber) + 1, 4) AS INT) = YEAR(GETDATE()))
    SELECT *
      FROM base;
-- WITH CHECK OPTION