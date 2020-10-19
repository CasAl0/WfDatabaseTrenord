
CREATE PROCEDURE [dbo].[GetReceiptsToProduce]
AS
    BEGIN
        SELECT   w.ClientId ,
                 w.OrderId ,
                 w.OrderDate ,
                 w.Price ,
                 w.ProductName ,
                 w.Quantity ,
                 w.Sku ,
                 w.PaymentMethod ,
                 w.BillingRequested ,
                 i.Recipient ,
                 i.VatNumber ,
                 i.FiscalCode ,
                 i.City ,
                 i.[Address] ,
                 i.ZipCode ,
                 i.Country ,

                 /* 27.07.2017 :
					modifica per recuperare la mail 'VERA' dell'utente anonimo, al posto di quella 'FINTA' generata da (CA)SSO, che ovviamente non è una mail valida e certamnete non è quella del cliente
				 */
                 --CASE WHEN i.EMail LIKE 'guest_%' AND i.EMail LIKE '%@trenord.it' THEN fq.UserEmail ELSE i.EMail END AS EMail ,
                 i.EMail ,
                 i.InvoiceNumber ,
                 i.ReceiptNumber ,
                 NULL AS VateRate ,
                 NULL AS VatCodeId ,
                 NULL AS VatCode ,
                 NULL AS VatDescription ,
                 c.Id AS CompanyId ,
                 c.Name AS CompanyName ,
                 c.Website AS CompanyWebsite ,
                 c.PhoneNumber AS CompanyPhoneNumber ,
                 c.Email AS CompanyEmail ,
                 c.InvoiceHeaderLogo AS CompanyHeaderLogo ,
                 c.InvoiceFooterLogo AS CompanyFooterLogo ,
                 c.InvoiceLeftFooter AS CompanyLeftFooterText ,
                 c.InvoiceRightFooter AS CompanyRightFooterText ,
                 c.ReceiptMailTemplateId AS CompanyReceiptMailTemplate ,
                 c.InvoiceMailTemplateId AS CompanyInvoiceMailTemplate ,
                 c.ReceiptPath AS CompanyReceiptPath ,
                 c.InvoicePath AS CompanyInvoicePath ,
                 c.ReceiptPrefixName AS CompanyReceiptPrefixName ,
                 c.InvoicePrefixName AS CompanyInvoicePrefixName
        FROM     dbo.WfWareHouse AS w
                 INNER JOIN WfInvoices AS i ON i.OrderId = w.OrderId
                                               AND i.ClientId = w.ClientId

                 /* 27.07.2017 ATTENZIONE QUESTA INNER DUPLICA LE RIGHE DI DETTAGLIO DELLA RICEVUTA FISCALE !!!! VA RIVISTA 
					modifica per recuperare la mail 'VERA' dell'utente anonimo, al posto di quella 'FINTA' generata da (CA)SSO, che ovviamente non è una mail valida e certamnete non è quella del cliente
				 */
                 --INNER JOIN dbo.WfFinalQueue AS fq ON fq.StoreOrderId = w.OrderId AND i.ClientId = w.ClientId

                 INNER JOIN ProductCodes AS p ON p.ProductSku = w.Sku
                 INNER JOIN Companies AS c ON c.Id = p.CompanyId
        WHERE    i.PdfDateReceipt IS NULL
                 AND i.ReceiptNumber IS NULL
                 AND w.BillingRequested = 0
        ORDER BY w.ClientId ASC ,
                 w.OrderId ASC ,
                 c.Id ASC;
    END;