CREATE PROCEDURE [dbo].[CarnetFix]
(
	@EMAIL   AS VARCHAR(255),
	@ORDERID AS VARCHAR(100),
	@TOKEN   AS VARCHAR(32) ,
	@PNR_LIST    AS VARCHAR(MAX) ,
	@TICKET_LIST AS VARCHAR(MAX)
)
 AS
BEGIN
BEGIN TRY

    BEGIN TRANSACTION carnetTran;

    
    DECLARE @DATI_UTENTE AS VARCHAR(MAX) = '';
    SELECT @DATI_UTENTE = CONCAT(
                              UserId ,
                              ',0,' ,
                              UserProfile ,
                              CASE LOWER(UserProfile)
                                   WHEN 'lite' THEN ',,'
                                   WHEN 'full' THEN
                                       CONCAT(
                                           ',' ,
                                       (   SELECT TOP ( 1 ) Value
                                           FROM   wonderbox.GenericAttribute
                                           WHERE  [Key] = 'FiscalCode'
                                                  AND EntityId = (   SELECT TOP ( 1 ) Id
                                                                     FROM   wonderbox.Customers
                                                                     WHERE  Email = @EMAIL )),
                                           ',')
                                   ELSE 'ERRORE'
                              END,
                              UserLastname ,
                              ',' ,
                              UserFirstname ,
                              ',' ,
                              UserEmail)
    FROM   dbo.WfFinalQueue
    WHERE  Token = @TOKEN;

    IF (CHARINDEX('ERRORE', @DATI_UTENTE)) = 0
        BEGIN
            -- PREZZO CARNET
            DECLARE @PRICE AS VARCHAR(MAX) = '0';
            SELECT @PRICE = Price
            FROM   dbo.FullWfWarehouse
            WHERE  Sku = 'TKCAR001'
                   AND OrderId = @ORDERID;

            -- INSERT
            INSERT INTO dbo.WfFinalQueueParams
            VALUES ( @TOKEN, '#pnr_list', @PNR_LIST, 'Ticket[]' ) ,
                   ( @TOKEN, '#userid', @DATI_UTENTE, 'string' ) ,
                   ( @TOKEN, '#price', @PRICE, 'decimal' ) ,
                   ( @TOKEN, '#ticket_list', @TICKET_LIST, 'Ticket[]' );

			UPDATE dbo.CarnetDaCorreggere  SET Ok = GETDATE() WHERE Token = @TOKEN;
        END;
    ELSE
        BEGIN
           SELECT 1/0
        END;

    COMMIT TRANSACTION carnetTran;

END TRY
BEGIN CATCH
    IF ( @@ERROR > 0 )
        BEGIN
            PRINT @@ERROR;
            ROLLBACK TRANSACTION carnetTran;
        END;
END CATCH;
END