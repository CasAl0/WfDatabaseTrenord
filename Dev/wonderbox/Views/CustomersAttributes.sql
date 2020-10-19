


CREATE VIEW [wonderbox].[CustomersAttributes]
AS
    SELECT g.*
    FROM   wonderbox.Customers AS c
           INNER JOIN wonderbox.GenericAttribute AS g ON g.EntityId = c.Id
    WHERE  g.KeyGroup = 'Customer';