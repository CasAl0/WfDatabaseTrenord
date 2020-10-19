
CREATE PROCEDURE [dbo].[SetInvoiceDate]
    @clientId INT,
    @storeOrderId VARCHAR(50),
    @invoiceDate DATETIME
AS
BEGIN

    DECLARE @ErrorMessage  NVARCHAR(4000),
            @ErrorSeverity INT,
            @ErrorState    INT;

    BEGIN TRANSACTION set_invoice_date;
    BEGIN TRY
        UPDATE [dbo].[WfInvoices]
           SET PdfDateInvoice = @invoiceDate,
               FlgElectronicSend = 1
         WHERE OrderId  = @storeOrderId
           AND ClientId = @clientId;
        COMMIT TRANSACTION set_invoice_date;
    END TRY
    BEGIN CATCH
        SELECT @ErrorMessage = ERROR_MESSAGE(),
               @ErrorSeverity = ERROR_SEVERITY(),
               @ErrorState = ERROR_STATE();

        ROLLBACK TRANSACTION set_invoice_date;

        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH;

END;