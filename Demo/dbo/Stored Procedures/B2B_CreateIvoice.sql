CREATE PROCEDURE [dbo].[B2B_CreateIvoice] (
@ClientKey VARCHAR(10),
@OrderId VARCHAR(50),
@Recipient VARCHAR(500),
@VatNumber VARCHAR(50) = NULL,
@FiscalCode VARCHAR(50) = NULL,
@City VARCHAR(100),
@Address VARCHAR(4000),
@ZipCode VARCHAR(20),
@Province VARCHAR(4) = NULL,
@Country VARCHAR(100),
@EMail VARCHAR(255) = NULL,
@TargetCode VARCHAR(7) = NULL,
@PecEmail NVARCHAR(300) = NULL)
AS
BEGIN

    BEGIN TRY

        DECLARE @ErrorMessage NVARCHAR(4000);
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;

        DECLARE @clientid INT = 0;
        DECLARE @InvoiceEnabled BIT = 0;

        SELECT @clientid = ClientId,
               @InvoiceEnabled = InvoiceEnabled
          FROM Client
         WHERE ClientKey = @ClientKey;

        IF @clientid = 0
        BEGIN
            RETURN -1; -- ERR: (non autorizzato)
        END;

        IF NOT EXISTS (   SELECT *
                            FROM dbo.WfWareHouse
                           WHERE OrderId  = @OrderId
                             AND ClientId = @clientid)
        BEGIN
            RETURN -2; -- ERR: (ordine inesistente)
        END;

        IF @InvoiceEnabled = 0
        BEGIN
            RETURN -3; -- ERR: (fattura non permessa)
        END;

        IF EXISTS (   SELECT *
                        FROM dbo.WfInvoices
                       WHERE OrderId  = @OrderId
                         AND ClientId = @clientid)
        BEGIN
            RETURN -4; -- ERR: (fattura gia presente)
        END;

        /*
			Il tempo massimo per richiedere la fattura è stato fissato in OrderDate + [2 giorni alle 23.59.59]
			DATEDIFF(DAY, 0, OrderDate) --> azzera la parte oraria della data- Es. 2019-05-29 15:37:45.687 --> 2019-05-29 00:00:00.000
			DATEADD(DAY, 3, DATEDIFF(DAY, 0, OrderDate)) --> aggiunge 3 giorni alla OrderDate (con parte time azzerata) Es. 2019-05-29 00:00:00.000 --> 2019-06-01 00:00:00.000
			DATEADD(ms, -3, DATEADD(DAY, 3, DATEDIFF(DAY, 0, OrderDate))) --> sottrae 3 millisecondi alla data per ottenere OrderDate + [2 giorni alle 23.59.59.997]

			Il tipo dato DATETIME ha risoluzione di al massimo 3 millisecondi, per cui sottraendo 3 ms alla mezzanotte di una valore datetime, ottengo la data del giorno prima prossima alla mezzanotte
		*/
        IF NOT EXISTS (   SELECT DISTINCT OrderId
                            FROM dbo.WfWareHouse
                           WHERE OrderId                                                       = @OrderId
                             AND DATEADD(ms, -3, DATEADD(DAY, 3, DATEDIFF(DAY, 0, OrderDate))) >= GETDATE()
        --AND DATEADD(ms, -3, DATEADD(DAY, 3, CONVERT(DATETIME, DATEDIFF(DAY, 0, OrderDate)))) >= GETDATE()
        )
        BEGIN
            RETURN -5; -- ERR: (tempo massimo per richiedere fattura scaduto)
        END;

        BEGIN TRANSACTION;

        -- Si rende necessario fare update della colonna BillingRequested visto che il nuovo store Alkemy non consente di scegliere la fatturazione in fase di pagamento.
        -- Prima l'informazione veniva aggiornata con la chiamata della sp [dbo].[B2B_InitEndWorkflow] (metodo InitEndWorkflow(...)) ma con Alkemy, quell'informazione non è disponibile in quel momento.
        UPDATE dbo.WfWareHouse
           SET BillingRequested = 1
         WHERE OrderId = @OrderId;

        INSERT INTO dbo.WfInvoices (OrderId,
                                    Recipient,
                                    VatNumber,
                                    FiscalCode,
                                    City,
                                    [Address],
                                    ZipCode,
                                    Country,
                                    --EMail,
                                    PdfDateInvoice,
                                    PdfDateReceipt,
                                    InvoiceNumber,
                                    ReceiptNumber,
                                    ClientId,
                                    TargetCode,
                                    FlgElectronicSend,
                                    Province,
                                    PecEmail)
        VALUES (@OrderId, -- OrderId - varchar(50)
                @Recipient, -- Recipient - varchar(500)
                @VatNumber, -- VatNumber - varchar(50)
                @FiscalCode, -- FiscalCode - varchar(50)
                @City, -- City - varchar(100)
                @Address, -- Address - varchar(4000)
                @ZipCode, -- ZipCode - varchar(50)
                @Country, -- Country - varchar(100)
                --@EMail, -- EMail - varchar(255)
                NULL, -- PdfDateInvoice - datetime
                NULL, -- PdfDateReceipt - datetime
                NULL, -- InvoiceNumber - varchar(100)
                NULL, -- ReceiptNumber - varchar(100)
                @clientid, -- ClientId - int
                @TargetCode, -- TargetCode - varchar(7)
                0, -- FlgElectronicSend - int
                @Province, -- Province - varchar(4)
                @PecEmail -- PecEmail - nvarchar(300)
            );

        COMMIT TRANSACTION;

        RETURN 0;

    END TRY
    BEGIN CATCH

        SELECT @ErrorMessage = ERROR_MESSAGE(),
               @ErrorSeverity = ERROR_SEVERITY(),
               @ErrorState = ERROR_STATE();

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH;

END;