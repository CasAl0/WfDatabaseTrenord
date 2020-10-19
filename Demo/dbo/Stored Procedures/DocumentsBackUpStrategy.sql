


CREATE PROCEDURE dbo.DocumentsBackUpStrategy
@category VARCHAR(500), @path VARCHAR(500), @fname VARCHAR(200), @createdby VARCHAR(200), @createdat DATETIME2 = NULL
AS
BEGIN

	BEGIN TRY

		IF(UPPER(@category) = 'TICKET')
		BEGIN
			  INSERT INTO dbo.BackUpTicket
			  VALUES  ( @path , -- Path - varchar(500)
						@fname , -- FileName - varchar(200)
						COALESCE(@createdat, SYSDATETIME()) , -- CreatedAt - datetime2(7)
						@createdby  -- CreatedBy - varchar(200)
					  )
		END


		IF(UPPER(@category) = 'RECEIPT')
		BEGIN
			  INSERT INTO dbo.BackUpReceipt
			  VALUES  ( @path , -- Path - varchar(500)
						@fname , -- FileName - varchar(200)
						COALESCE(@createdat, SYSDATETIME()) , -- CreatedAt - datetime2(7)
						@createdby  -- CreatedBy - varchar(200)
					  )
		END

		
		IF(UPPER(@category) = 'INVOICE')
		BEGIN
			  INSERT INTO dbo.BackUpInvoice
			  VALUES  ( @path , -- Path - varchar(500)
						@fname , -- FileName - varchar(200)
						COALESCE(@createdat, SYSDATETIME()) , -- CreatedAt - datetime2(7)
						@createdby  -- CreatedBy - varchar(200)
					  )
		END

	END TRY
	BEGIN CATCH
		DECLARE @ErrorMessage NVARCHAR(4000), @ErrorSeverity INT, @ErrorState INT
		SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE()

		RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
	END CATCH

END