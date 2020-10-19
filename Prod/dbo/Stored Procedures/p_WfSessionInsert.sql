CREATE PROCEDURE [dbo].[p_WfSessionInsert]
    @token VARCHAR(32),
    @name VARCHAR(50),
    @objectBase64 VARCHAR(MAX),
    @objectType VARCHAR(50)
AS
BEGIN
    BEGIN TRANSACTION tran_session_insert;
    BEGIN TRY
        --DECLARE @dt DATETIME = GETDATE();
        --DECLARE @exp DATETIME = DATEADD(DAY, 1, GETDATE());

        -- definisco lo step solo per gli oggetti "esterni", ovvero che possono essere mandati in output
        -- servirà infatti per la cancellazione degli oggetti successivi in caso di rollback
        -- invece per gli oggetti interni metto step = 0 in modo che non vengano mai cancellati.
        DECLARE @step INT;
        IF (LEFT(@name, 1)) = '_'
            SET @step = 0;
        ELSE
            SELECT @step = CAST(ObjectBase64 AS INT)
            FROM dbo.WfSession
            WHERE Token = @token
                  AND ObjectName = '_currentStep';

        -- cancello se era già presente un oggetto con lo stesso nome
        DELETE FROM dbo.WfSession
        WHERE Token = @token
              AND ObjectName = @name;

        -- inserisco l'oggetto in sessione
        INSERT INTO dbo.WfSession
        (
            Token,
            ObjectName,
            ObjectBase64,
            ObjectType,
            StepNr
        )
        VALUES
        (@token, @name, @objectBase64, @objectType, @step);

        COMMIT TRANSACTION tran_session_insert;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000),
                @ErrorSeverity INT,
                @ErrorState INT;
        SELECT @ErrorMessage = ERROR_MESSAGE(),
               @ErrorSeverity = ERROR_SEVERITY(),
               @ErrorState = ERROR_STATE();

        ROLLBACK TRANSACTION tran_session_insert;

        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH;

END;
