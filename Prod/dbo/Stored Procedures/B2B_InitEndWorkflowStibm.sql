

CREATE PROCEDURE [dbo].[B2B_InitEndWorkflowStibm] (
	@Token VARCHAR(32),
	@ClientKey VARCHAR(10),
	@Sku VARCHAR(400),
	@OrderId VARCHAR(50),
	@OrderDate DATETIME,
	@NumeroOrdine VARCHAR(50),
	@IdTicket VARCHAR(50),
	@ProductName VARCHAR(400),
	@Description VARCHAR(MAX) = NULL,
	@UserFirstname VARCHAR(100) = NULL,
	@UserLastname VARCHAR(100) = NULL,
	@UserEmail VARCHAR(260),
	@SsoUserId INT,
	@UserProfile VARCHAR(100) = NULL,
	@ItemId INT = 0,
	@ProductId INT = 0,
	@Quantity INT,
	@Price DECIMAL(18, 2),
	@BillingRequested BIT = NULL,
	@Recipient VARCHAR(500) = '',
	@VatNumber VARCHAR(50) = '',
	@FiscalCode VARCHAR(50) = '',
	@City VARCHAR(100) = '',
	@Address VARCHAR(4000) = '',
	@ZipCode VARCHAR(20) = '',
	@Country VARCHAR(100) = '',
	@PaymentMethod VARCHAR(100) = '',
	@PaymentTransactionId VARCHAR(100) = '')
AS
BEGIN

    BEGIN TRY
        
		--BEGIN TRAN StibmTran;
        
		DECLARE @ErrorMessage NVARCHAR(4000);
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;

        DECLARE @clientid INT = 0;
        DECLARE @InvoiceEnabled BIT = 0;
		SELECT @clientid = ClientId,
               @InvoiceEnabled = InvoiceEnabled
          FROM Client
         WHERE ClientKey = @ClientKey;

		DECLARE @finalQueueExpirationDays INT;
		SELECT @finalQueueExpirationDays = FinalQueueExpirationDays
		  FROM WfConfiguration
		 WHERE [Current] = 1;


        --INSERT INTO WfFinalQueueItems
        --VALUES (@Token, @SerialNo, @BillingRequested);

        --DECLARE @ProductName   AS VARCHAR(50);
        DECLARE @EndWorkflowId AS VARCHAR(8);

        --SELECT @ProductName=pc.ProductDescription * FROM dbo.ProductCodes AS pc WHERE pc.ProductSku = @Sku;
        SELECT @EndWorkflowId = EndWorkflowId
          FROM dbo.Client_Product_Map
         WHERE ProductSku = @Sku;

        INSERT INTO dbo.WfFinalQueue (Token,
                                      ClientId,
                                      ProductSku,
                                      OrderDate,
                                      Expiration,
                                      StateCode,
                                      EndWorkflowId,
                                      LegacyOrderId,
                                      StoreOrderId,
                                      ProductName,
                                      [Description],
                                      UserFirstname,
                                      UserLastname,
                                      UserEmail,
                                      OrderSmsNumber,
                                      ErrorLog,
                                      ReleaseDate,
                                      ReleasePlace,
                                      UserId,
                                      UserProfile)
        VALUES (@Token, -- Token - varchar(32)
                @clientid, -- ClientId - int
                @Sku, -- ProductSku - char(8)
                @OrderDate, -- OrderDate - datetime
                dateadd(DD, @finalQueueExpirationDays, @OrderDate) , -- Expiration - datetime
                1, -- StateCode - int
                @EndWorkflowId, -- EndWorkflowId - char(8)
                @NumeroOrdine, -- LegacyOrderId - varchar(50)
                @OrderId, -- StoreOrderId - varchar(50)
                @ProductName, -- ProductName - varchar(200)
                @Description, -- Description - varchar(max)
                @UserFirstname, -- UserFirstname - varchar(200)
                @UserLastname, -- UserLastname - varchar(200)
                @UserEmail, -- UserEmail - varchar(255)
                NULL, -- OrderSmsNumber - varchar(255)
                NULL, -- ErrorLog - varchar(max)
                NULL, -- ReleaseDate - varchar(50)
                NULL, -- ReleasePlace - varchar(255)
                @SsoUserId, -- UserId - int
                @UserProfile -- UserProfile - varchar(10)
            );

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
                @ProductName, @Description, @Token, @IdTicket, @BillingRequested, @PaymentMethod, @PaymentTransactionId);

       -- COMMIT TRAN StibmTran;

    END TRY

    BEGIN CATCH
        SELECT @ErrorMessage = ERROR_MESSAGE(),
               @ErrorSeverity = ERROR_SEVERITY(),
               @ErrorState = ERROR_STATE();

        --ROLLBACK TRANSACTION StibmTran;
        
		RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH;

END;