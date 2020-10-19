-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [tln].[ExtractWareHouse]
    @lastWareHouseId BIGINT
AS
    BEGIN
        -- SET NOCOUNT ON added to prevent extra result sets from
        -- interfering with SELECT statements.
        SET NOCOUNT ON;

        DECLARE @warehouse TABLE
            (
                [WarehouseId] [BIGINT] NOT NULL ,
                [ClientId] [INT] NOT NULL ,
                [ClientDescription] [VARCHAR](200) NOT NULL ,
                [Channel] [VARCHAR](50) NOT NULL ,
                [OrderId] [VARCHAR](50) NOT NULL ,
                [SsoUserId] [INT] NOT NULL ,
                [OrderDate] [DATETIME] NOT NULL ,
                [Quantity] [INT] NOT NULL ,
                [Price] [DECIMAL](18, 4) NOT NULL ,
                [TotalPrice] [DECIMAL](18, 4) NOT NULL ,
                [PaymentMethod] [VARCHAR](100) NOT NULL ,
                [ProductSku] [CHAR](8) NOT NULL ,
                [ProductDescription] [VARCHAR](100) NOT NULL ,
                [SerialNo] [BIGINT] NULL ,
                [LegacyOrderId] [BIGINT] NOT NULL ,
                [UserLastname] [VARCHAR](150) NULL ,
                [UserFirstname] [VARCHAR](150) NULL ,
                [UserEmail] [VARCHAR](255) NULL ,
                [OrderSmsNumber] [VARCHAR](255) NULL ,
                [InvoiceRecipient] [VARCHAR](500) NULL ,
                [InvoiceVatNumber] [VARCHAR](50) NULL ,
                [InvoiceFiscalCode] [VARCHAR](50) NULL ,
                [InvoiceCity] [VARCHAR](100) NULL ,
                [InvoiceAddress] [VARCHAR](4000) NULL ,
                [InvoiceZipCode] [VARCHAR](50) NULL ,
                [InvoiceCountry] [VARCHAR](100) NULL ,
                [InvoiceDate] [DATETIME] NULL ,
                [InvoiceNumber] [VARCHAR](100) NULL ,
                [InvoiceYear] [INT] NULL ,
                [ProductGroupId] [INT] NULL ,
                [ProductGroupDescription] [VARCHAR](50) NULL
            );

        INSERT INTO @warehouse ( [WarehouseId] ,
                                 [ClientId] ,
                                 [ClientDescription] ,
                                 [Channel] ,
                                 [OrderId] ,
                                 [SsoUserId] ,
                                 [OrderDate] ,
                                 [Quantity] ,
                                 [Price] ,
                                 [TotalPrice] ,
                                 [PaymentMethod] ,
                                 [ProductSku] ,
                                 [ProductDescription] ,
                                 [SerialNo] ,
                                 [LegacyOrderId] ,
                                 [UserLastname] ,
                                 [UserFirstname] ,
                                 [UserEmail] ,
                                 [OrderSmsNumber] ,
                                 [InvoiceRecipient] ,
                                 [InvoiceVatNumber] ,
                                 [InvoiceFiscalCode] ,
                                 [InvoiceCity] ,
                                 [InvoiceAddress] ,
                                 [InvoiceZipCode] ,
                                 [InvoiceCountry] ,
                                 [InvoiceDate] ,
                                 [InvoiceNumber] ,
                                 [InvoiceYear] ,
                                 [ProductGroupId] ,
                                 [ProductGroupDescription] )
                    SELECT wh.WareHouseId ,
                           wh.ClientId ,
                           c.ClientDescription ,
                           CASE WHEN wh.ClientId = 2 THEN 'Mobile'
                                ELSE
                                    COALESCE(
                                        pc2.PaymentChannelDescription ,
                                        'Desktop')
                           END AS Channel ,
                           wh.OrderId ,
                           fq.UserId AS SsoUserId ,
                           wh.OrderDate ,
                           wh.Quantity ,
                           wh.Price ,
                           wh.Quantity * wh.Price AS TotalPrice ,
                           COALESCE(wh.PaymentMethod, 'n.d.') AS PaymentMethod ,
                           p.ProductSku ,
                           p.ProductDescription ,
                           wh.SerialNo ,
                           fq.LegacyOrderId ,
                           fq.UserLastname ,
                           fq.UserFirstname ,
                           fq.UserEmail ,
                           fq.OrderSmsNumber ,
                           i.Recipient AS InvoiceRecipient ,
                           i.VatNumber AS InvoiceVatNumber ,
                           i.FiscalCode AS InvoiceFiscalCode ,
                           i.City AS InvoiceCity ,
                           i.[Address] AS InvoiceAddress ,
                           i.ZipCode AS InvoiceZipCode ,
                           i.Country AS InvoiceCountry ,
                           i.PdfDateInvoice AS InvoiceDate ,
                           i.InvoiceNumber ,
                           YEAR(i.PdfDateInvoice) AS InvoiceYear ,
                           pg.ProductGroupId ,
                           pg.ProductGroupDescription
                    FROM   WfWareHouse wh
                           INNER JOIN WfFinalQueue fq ON fq.Token = wh.Token
                                                         AND fq.StateCode IN (10 , 90, 99)
                           INNER JOIN Client c ON c.ClientId = wh.ClientId
                           INNER JOIN ProductCodes p ON p.ProductSku = wh.Sku
                           INNER JOIN ProductGroup pg ON pg.ProductGroupId = p.ProductGroupId
                           LEFT JOIN WfInvoices i ON i.OrderId = wh.OrderId
                                                     AND i.ClientId = wh.ClientId
                                                     AND i.InvoiceNumber IS NOT NULL
                           LEFT JOIN PaymentConfirmations pc1 ON pc1.StoreOrderId = wh.OrderId
                                                                 AND pc1.ClientId = wh.ClientId
                           LEFT JOIN PaymentChannels pc2 ON pc2.PaymentChannelId = pc1.PaymentChannelId
                    WHERE  wh.WareHouseId > @lastWareHouseId
							AND fq.LegacyOrderId IS NOT NULL -- 06.06.2019 per problema con un record  LegacyOrderId NULL
                           AND wh.OrderDate < DATEADD(hh, -1, GETDATE())
                           AND fq.UserId IS NOT NULL;

        DECLARE @missing_warehouse TABLE
            (
                [WarehouseId] [BIGINT] NOT NULL
            );


		
		/*
		11.11.2019 
		QUESTA ISTRUZIONE RISCHIA DI MANDARE IN TIMEOUT TUTTA LA SP. 
		PER ORA L'HO AGGIUSTATA CON IL FILTRO SULLA DATA CHE LIMITA IL RANGE. COMUNQUE ANDREBBE RIVISTA.
		*/
		DECLARE @data AS DATE;
		SELECT @data = CAST(DATEADD(MONTH, -2, SYSDATETIME()) AS DATE);
        INSERT INTO @missing_warehouse ( WarehouseId )
        SELECT wh.WareHouseId
        FROM   WfWareHouse AS wh WITH ( NOLOCK )
                INNER JOIN WfFinalQueue AS fq WITH ( NOLOCK ) 
				ON fq.Token = wh.Token AND fq.LegacyOrderId IS NOT NULL
        WHERE  wh.WareHouseId < @lastWareHouseId
			--AND  YEAR(wh.OrderDate) > 2018
			AND CAST(wh.OrderDate AS DATE) > @data
        EXCEPT
        SELECT WarehouserId
        FROM   tln.Wfengine_warehouse;

        INSERT INTO @warehouse ( [WarehouseId] ,
                                 [ClientId] ,
                                 [ClientDescription] ,
                                 [Channel] ,
                                 [OrderId] ,
                                 [SsoUserId] ,
                                 [OrderDate] ,
                                 [Quantity] ,
                                 [Price] ,
                                 [TotalPrice] ,
                                 [PaymentMethod] ,
                                 [ProductSku] ,
                                 [ProductDescription] ,
                                 [SerialNo] ,
                                 [LegacyOrderId] ,
                                 [UserLastname] ,
                                 [UserFirstname] ,
                                 [UserEmail] ,
                                 [OrderSmsNumber] ,
                                 [InvoiceRecipient] ,
                                 [InvoiceVatNumber] ,
                                 [InvoiceFiscalCode] ,
                                 [InvoiceCity] ,
                                 [InvoiceAddress] ,
                                 [InvoiceZipCode] ,
                                 [InvoiceCountry] ,
                                 [InvoiceDate] ,
                                 [InvoiceNumber] ,
                                 [InvoiceYear] ,
                                 [ProductGroupId] ,
                                 [ProductGroupDescription] )
                    SELECT   wh.WareHouseId ,
                             wh.ClientId ,
                             c.ClientDescription ,
                             CASE WHEN wh.ClientId = 2 THEN 'Mobile'
                                  ELSE
                                      COALESCE(
                                          pc2.PaymentChannelDescription ,
                                          'Desktop')
                             END AS Channel ,
                             wh.OrderId ,
                             fq.UserId AS SsoUserId ,
                             wh.OrderDate ,
                             wh.Quantity ,
                             wh.Price ,
                             wh.Quantity * wh.Price AS TotalPrice ,
                             COALESCE(wh.PaymentMethod, 'n.d.') AS PaymentMethod ,
                             p.ProductSku ,
                             p.ProductDescription ,
                             wh.SerialNo ,
                             fq.LegacyOrderId ,
                             fq.UserLastname ,
                             fq.UserFirstname ,
                             fq.UserEmail ,
                             fq.OrderSmsNumber ,
                             i.Recipient AS InvoiceRecipient ,
                             i.VatNumber AS InvoiceVatNumber ,
                             i.FiscalCode AS InvoiceFiscalCode ,
                             i.City AS InvoiceCity ,
                             i.[Address] AS InvoiceAddress ,
                             i.ZipCode AS InvoiceZipCode ,
                             i.Country AS InvoiceCountry ,
                             i.PdfDateInvoice AS InvoiceDate ,
                             i.InvoiceNumber ,
                             YEAR(i.PdfDateInvoice) AS InvoiceYear ,
                             pg.ProductGroupId ,
                             pg.ProductGroupDescription
                    FROM     @missing_warehouse mw
                             INNER JOIN WfWareHouse wh ON wh.WareHouseId = mw.WarehouseId
                             INNER JOIN WfFinalQueue fq ON fq.Token = wh.Token
                                                           AND fq.StateCode IN (10, 90, 99 )
                             INNER JOIN Client c ON c.ClientId = wh.ClientId
                             INNER JOIN ProductCodes p ON p.ProductSku = wh.Sku
                             INNER JOIN ProductGroup pg ON pg.ProductGroupId = p.ProductGroupId
                             LEFT JOIN WfInvoices i ON i.OrderId = wh.OrderId
                                                       AND i.ClientId = wh.ClientId
                                                       AND i.InvoiceNumber IS NOT NULL
                             LEFT JOIN PaymentConfirmations pc1 ON pc1.StoreOrderId = wh.OrderId
                                                                   AND pc1.ClientId = wh.ClientId
                             LEFT JOIN PaymentChannels pc2 ON pc2.PaymentChannelId = pc1.PaymentChannelId
                    WHERE    wh.OrderDate < DATEADD(hh, -1, GETDATE())
                             AND fq.UserId IS NOT NULL
                    ORDER BY WareHouseId ASC;

        SELECT *
        FROM   @warehouse;
    END;
