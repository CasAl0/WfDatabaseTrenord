CREATE PROCEDURE [dbo].[B2B_InitEndWorkflow] (
@ClientKey VARCHAR(10),
@OrderId VARCHAR(50),
@SsoUserId INT,
@OrderDate DATETIME,
@ItemId INT,
@ProductId INT,
@Sku VARCHAR(400) = NULL,
@Quantity INT,
@Price DECIMAL(18, 4),
@ProductName VARCHAR(400),
@Description VARCHAR(MAX) = NULL,
@Token VARCHAR(32) = NULL,
@SerialNo VARCHAR(50) = NULL,
@BillingRequested BIT = NULL,
@Recipient VARCHAR(500),
@VatNumber VARCHAR(50) = NULL,
@FiscalCode VARCHAR(50) = NULL,
@City VARCHAR(100),
@Address VARCHAR(4000),
@ZipCode VARCHAR(20),
@Country VARCHAR(100),
@EMail VARCHAR(255),
@PaymentMethod VARCHAR(100),
@PaymentTransactionId VARCHAR(100) = NULL)
AS
BEGIN

    /* 
			Esiste già una contesto di transazione nel codice chiamante (si veda CreateInitEndWorkflow(List<WfWarehouseData> inputs), progetto ContextManagement, classe Container).
			Applicare anche qui un contesto di transazione genera, in caso di rollback, un errore: 
				Transaction count after EXECUTE indicates a mismatching number of BEGIN and COMMIT statements.
	*/
    ---begin transaction tran_B2B_insert;
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

        INSERT INTO WfFinalQueueItems
        VALUES (@Token, @SerialNo, @BillingRequested);

        UPDATE WfFinalQueue
           SET StateCode = 1,
               StoreOrderId = @OrderId,
               OrderDate = @OrderDate,
               ProductName = @ProductName
         WHERE StateCode          = 0
           AND WfFinalQueue.Token = @Token;

        INSERT INTO [dbo].[WfWareHouse] (ClientId,
                                         OrderId,
                                         SsoUserId,
                                         OrderDate,
                                         ItemId,
                                         ProductId,
                                         Sku,
                                         Quantity,
                                         Price,
                                         ProductName,
                                         [Description],
                                         Token,
                                         SerialNo,
                                         BillingRequested,
                                         PaymentMethod,
                                         PaymentTransactionId)
        VALUES (@clientid, @OrderId, @SsoUserId, @OrderDate, @ItemId, @ProductId, @Sku, @Quantity, @Price,
                @ProductName, @Description, @Token, @SerialNo, @BillingRequested, @PaymentMethod, @PaymentTransactionId);


        /*
				ATTENZIONE: 
				Gestione fattura/ricevuta fiscale.
				E' definita nella tabella Client, colonna InvoiceEnabled. 
				Se 0 (false) il B2B non emette fattura. Se 1 (true) può farlo.
				Quando il B2B chiama il metodo InitEndWorkflow del WfEngine passandogli le info sul prodotto venduto, viene richiamata qs sp.
				Se InvoiceEnabled = 1 entra in questo flusso, che, con la sola insert, va in errore di chiave duplicata in presenza di quantità (tariffe) maggiori di uno per il singolo prodotto.
				Con la modfica (MERGE) evitiamo che ciò accada andando in update nel caso sia già presente quella chiave.
		*/
        --IF (@ClientKey <> 'S9V7F1Z0M') -- Modifica per Alkemy che ad oggi(27.06.2019) fa la fatturazione in un modo differente. In futuro dovrebbe passare da qui e verrà tolto.
        --BEGIN
        --    IF (@InvoiceEnabled = 1)
        --    BEGIN
        --        --INSERT INTO dbo.WfInvoices ( OrderId ,
        --        --                             ClientId ,
        --        --                             Recipient ,
        --        --                             VatNumber ,
        --        --                             FiscalCode ,
        --        --                             City ,
        --        --                             [Address] ,
        --        --                             ZipCode ,
        --        --                             Country ,
        --        --                             EMail )
        --        --VALUES ( @OrderId, @clientid, @Recipient, @VatNumber ,
        --        --         @FiscalCode ,@City, @Address, @ZipCode ,
        --        --         @Country ,@EMail, @clientid, @Recipient, @VatNumber ,
        --        --         @FiscalCode ,@City, @Address, @ZipCode ,
        --        --         @Country ,@EMail );
        --        ;WITH base
        --           AS (SELECT @OrderId AS OrderId,
        --                      @clientid AS clientid,
        --                      @Recipient AS Recipient,
        --                      @VatNumber AS VatNumber,
        --                      @FiscalCode AS FiscalCode,
        --                      @City AS City,
        --                      @Address AS [Address],
        --                      @ZipCode AS ZipCode,
        --                      @Country AS Country,
        --                      @EMail AS EMail)
        --        MERGE INTO dbo.WfInvoices AS TGT
        --        USING base AS SRC
        --           ON TGT.OrderId = SRC.OrderId
        --          AND TGT.ClientId = SRC.clientid
        --         WHEN MATCHED THEN UPDATE SET TGT.Recipient = SRC.Recipient,
        --                                      TGT.VatNumber = SRC.VatNumber,
        --                                      TGT.FiscalCode = SRC.FiscalCode,
        --                                      TGT.City = SRC.City,
        --                                      TGT.[Address] = SRC.[Address],
        --                                      TGT.ZipCode = SRC.ZipCode,
        --                                      TGT.Country = SRC.Country,
        --                                      TGT.EMail = SRC.EMail
        --         WHEN NOT MATCHED THEN
        --            INSERT (OrderId,
        --                    ClientId,
        --                    Recipient,
        --                    VatNumber,
        --                    FiscalCode,
        --                    City,
        --                    [Address],
        --                    ZipCode,
        --                    Country,
        --                    EMail)
        --            VALUES (OrderId, clientid, Recipient, VatNumber, FiscalCode, City, [Address], ZipCode, Country,
        --                    EMail);
        --    END;
        --END;
    ----commit transaction tran_B2B_insert;

    END TRY
    BEGIN CATCH
        ----rollback transaction tran_B2B_insert;
        SELECT @ErrorMessage = ERROR_MESSAGE(),
               @ErrorSeverity = ERROR_SEVERITY(),
               @ErrorState = ERROR_STATE();
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH;

END;