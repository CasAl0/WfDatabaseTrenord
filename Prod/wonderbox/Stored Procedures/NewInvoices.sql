CREATE PROCEDURE [wonderbox].[NewInvoices]
AS
BEGIN

    PRINT 'START - ' + CONVERT(VARCHAR, GETDATE(), 108);

    WITH newInvoices
      AS (SELECT StoreOrderId AS OrderId,
                 ClientId
            FROM dbo.PaidOrders
           WHERE ClientId = 1
             AND Paid     = 1
          EXCEPT
          SELECT OrderId,
                 ClientId
            FROM dbo.WfInvoices
           WHERE ClientId = 1
             AND OrderId IS NOT NULL)
    INSERT INTO [dbo].[WfInvoices] (OrderId,
                                    ClientId,
                                    Recipient,
                                    VatNumber,
                                    FiscalCode,
                                    EMail,
                                    City,
                                    [Address],
                                    ZipCode,
                                    Country,
                                    TargetCode,
                                    Province,
									PecEmail)
    SELECT      O.StoreOrderId AS OrderId,
                1 AS ClientId,
                CASE
                     WHEN A.Company IS NULL THEN A.FirstName + ' ' + A.LastName
                     ELSE A.Company END AS Recipient,
                /* 05.02.2019 consente di determinare correttamente a quale categoria di fatturazione ci riferiamo: Persona fisica / Persona giuridica  */
                CASE
                     WHEN A.CompanyAddress = 0 THEN NULL
                     ELSE A.VatNumber END AS VatNumber,
                CASE
                     WHEN A.CompanyAddress = 1 THEN NULL
                     ELSE A.FiscalCode END AS FiscalCode,
                /* casati */
                cu.Email,
                COALESCE(A.City, '') AS City,
                COALESCE(A.Address1, '') AS [Address],
                COALESCE(A.ZipPostalCode, '') AS ZipCode,
                COALESCE(C.Name, '') AS Country,
                A.RecipientCode,
                sp.Abbreviation,
				A.PecEmail
      FROM      dbo.PaidOrders AS O
     INNER JOIN newInvoices AS N
        ON N.OrderId    = O.StoreOrderId
       AND N.ClientId   = O.ClientId
       AND O.Paid       = 1
     INNER JOIN wonderbox.Addresses AS A
        ON A.Id         = O.BillingAddressId
     INNER JOIN wonderbox.Customers AS cu
        ON cu.Id        = O.CustomerId
      LEFT JOIN wonderbox.StateProvince AS sp
        ON sp.Id        = A.StateProvinceId
       AND sp.CountryId = A.CountryId
      LEFT JOIN wonderbox.Countries AS C
        ON C.Id         = A.CountryId;

    PRINT 'INSERIMENTO NUOVE RICEVUTE / FATTURE - ' + CONVERT(VARCHAR, GETDATE(), 108);
END;
