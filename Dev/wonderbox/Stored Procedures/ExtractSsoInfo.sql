
CREATE PROCEDURE wonderbox.ExtractSsoInfo
    @customerId INT
AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE @ssoUserId INT;
        DECLARE @ssoProfile VARCHAR(10);

        SELECT @ssoUserId = CONVERT(INT, g1.Value)
        FROM   wonderbox.GenericAttribute AS g1
        WHERE  EntityId = @customerId
               AND [KeyGroup] = 'Customer'
               AND [Key] = 'SSOUserId';

        SELECT @ssoProfile = CONVERT(VARCHAR(10), g1.Value)
        FROM   wonderbox.GenericAttribute AS g1
        WHERE  EntityId = @customerId
               AND [KeyGroup] = 'Customer'
               AND [Key] = 'SsoProfileType';

        SELECT @ssoUserId AS SsoUserId ,
               @ssoProfile AS SsoProfile;

    END;