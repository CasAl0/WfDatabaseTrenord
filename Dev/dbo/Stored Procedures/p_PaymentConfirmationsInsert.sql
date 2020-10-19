
CREATE PROCEDURE [dbo].[p_PaymentConfirmationsInsert] (
@clientId INT,
@storeOrderId VARCHAR(50),
@paymentChannelId INT)
AS
BEGIN
    DECLARE @now DATETIME;
    DECLARE @RowCount INTEGER;

    SET @now = GETDATE();

    UPDATE PaymentConfirmations
       SET ConfirmPaymentDate = GETDATE(),
           PaymentChannelId = @paymentChannelId
     WHERE StoreOrderId = @storeOrderId
       AND ClientId     = @clientId;

    SELECT @RowCount = @@ROWCOUNT;

    IF @RowCount = 0
    BEGIN
        INSERT INTO PaymentConfirmations (StoreOrderId,
                                          ClientId,
                                          ConfirmPaymentDate,
                                          PaymentChannelId)
        SELECT @storeOrderId,
               @clientId,
               @now,
               @paymentChannelId;
    END;

--EXCEPT
--SELECT StoreOrderId,
--       ClientId,
--       @now,
--       @paymentChannelId
--  FROM PaymentConfirmations
-- WHERE StoreOrderId = @storeOrderId
--   AND ClientId     = @clientId;

END;