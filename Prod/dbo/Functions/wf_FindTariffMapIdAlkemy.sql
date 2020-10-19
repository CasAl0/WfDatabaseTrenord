
CREATE FUNCTION [dbo].[wf_FindTariffMapIdAlkemy] (@TariffMapIdStore INT)
RETURNS INT
WITH EXECUTE AS CALLER
AS
-- place the body of the function here
BEGIN

    DECLARE @id AS INT = 0;
    SELECT      @id = ct1.TariffMapId
      FROM      dbo.CP_Tariff AS ct1
     INNER JOIN dbo.CP_Tariff AS ct2
        ON ct1.ProductSku = ct2.ProductSku
       AND ct1.TariffId   = ct2.TariffId
       AND ct1.ClientId   = 10
     WHERE      ct1.ClientId IN ( 1, 10 )
       AND      ct2.ClientId IN ( 1, 10 )
       AND      ct1.TariffMapId <> ct2.TariffMapId
       AND      ct1.ClientId    <> ct2.ClientId
	   AND ct2.TariffMapId = @TariffMapIdStore;
     
    RETURN @id;
END;