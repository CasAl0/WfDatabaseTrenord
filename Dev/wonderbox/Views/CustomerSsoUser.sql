
CREATE VIEW [wonderbox].[CustomerSsoUser]
AS
    SELECT DISTINCT EntityId AS CustomerId ,
                    CONVERT(INT, g1.Value) AS SSOUserId ,
                    --StoreId ,
                    g2.SSOProfile
    FROM   wonderbox.GenericAttribute AS g1
           CROSS APPLY (   SELECT Value AS SSOProfile
                           FROM   wonderbox.GenericAttribute
                           WHERE  EntityId = g1.EntityId
                                  AND [KeyGroup] = 'Customer'
                                  AND [Key] = 'SsoProfileType' ) AS g2
    WHERE  [KeyGroup] = 'Customer'
           AND [Key] = 'SSOUserId';