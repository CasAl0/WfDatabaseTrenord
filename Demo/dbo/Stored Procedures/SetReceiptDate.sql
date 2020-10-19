

CREATE PROCEDURE [dbo].[SetReceiptDate]
    @clientId INT,
    @storeOrderId VARCHAR(50),
    @receiptDate DATETIME,
    @receiptNumber VARCHAR(100)
AS
BEGIN

    DECLARE @ErrorMessage  NVARCHAR(4000),
            @ErrorSeverity INT,
            @ErrorState    INT;

	DECLARE @flg AS INT = 0;

    BEGIN TRANSACTION set_receipt_date;
    BEGIN TRY

		-- Serve per gestire il caso in cui un ordine abbia righe miste; alcune per cui è stata richiesta fattura, altre no.
		-- In un ordine di più righe, in cui, per il primo item inserito è stata richiesta fattura mentre per il secondo no, 
		-- dobbiamo comunque impostare la colonna FlgElectronicSend della tabella WfInvoices a True (1).
		-- La fattura elettronica deve essere emessa, ma solo per quegli item che sono stati selezionati come "da fatturare"
		-- La GRUOP BY per OrderId con la somma della colonna BillingRequested consente di eseguire l'update della tabella WfInvoices con il corretto valore
		-- della colonna FlgElectronicSend; True(1) se anche un solo item dell'ordine richiede fattura, altrimenti False(0).
        SELECT @flg = SUM(CONVERT(INT, COALESCE(BillingRequested, 0)))
          FROM dbo.WfWareHouse
         WHERE OrderId  = @storeOrderId
           AND ClientId = @clientId
         GROUP BY OrderId
        HAVING SUM(CONVERT(INT, COALESCE(BillingRequested, 0))) > 0;

        UPDATE [dbo].[WfInvoices]
           SET PdfDateReceipt = @receiptDate,
               ReceiptNumber = @receiptNumber,
               FlgElectronicSend = IIF(@flg > 0, 1, 0)
         WHERE OrderId  = @storeOrderId
           AND ClientId = @clientId;

        COMMIT TRANSACTION set_receipt_date;
    END TRY
    BEGIN CATCH
        SELECT @ErrorMessage = ERROR_MESSAGE(),
               @ErrorSeverity = ERROR_SEVERITY(),
               @ErrorState = ERROR_STATE();

        ROLLBACK TRANSACTION set_receipt_date;
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH;

END;