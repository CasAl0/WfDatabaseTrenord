-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetOrderInvoiceNumber]
(
	@CompanyId	int,
	@ClientId	int,
	@OrderId	VARCHAR(50),
	@OrderDate	DATETIME,
	@InvoiceNumber VARCHAR(100) OUTPUT
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	BEGIN TRY

		BEGIN TRANSACTION InvoicesNumbers_TRAN;

		DECLARE @num BIGINT = 0;
		DECLARE @newNum TABLE(val bigint);
		DECLARE @referenceYear int = YEAR(@OrderDate);

		IF NOT EXISTS(SELECT * FROM InvoicesNumbers WHERE InvoiceYear = @referenceYear and CompanyId = @CompanyId)
		BEGIN
			-- inserisco il record di default ad ogni cambio anno o nel caso non sia prensete
			INSERT INTO  InvoicesNumbers VALUES (0, @referenceYear, @CompanyId);
		END

		--Incremento il numero fattura
		UPDATE InvoicesNumbers SET InvoiceNumber += 1 
		OUTPUT Inserted.InvoiceNumber INTO @newNum
		WHERE InvoiceYear = @referenceYear and CompanyId = @CompanyId;
	
		-- Recupero il numero assegnato alla fattura
		SELECT TOP 1 @num = val FROM @newNum;

		-- Formatto la variabile
		SET @InvoiceNumber = CONVERT(VARCHAR, @num) + '/' + CONVERT(VARCHAR, @referenceYear);

		-- Associo il numero fattura allo specifico ordine
		UPDATE dbo.WfInvoices SET InvoiceNumber = @InvoiceNumber WHERE OrderId = @OrderId and ClientId = @ClientId;

		COMMIT TRANSACTION InvoicesNumbers_TRAN;
    
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION InvoicesNumbers_TRAN;
		DECLARE @ErrorMessage NVARCHAR(4000), @ErrorSeverity INT, @ErrorState INT;
		SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();
		RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
	END CATCH

END