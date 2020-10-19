
CREATE VIEW [wonderbox].[ProductSpecificAttributes]
AS
    SELECT pasm.ProductId ,
           sa.Name AS SpecificAttributeName ,
           sao.Name AS SpecificAttributeValue
	FROM   wonderbox.Product_SpecificationAttribute_Mapping AS pasm
		   INNER JOIN wonderbox.SpecificationAttributeOption AS sao ON sao.Id = pasm.SpecificationAttributeOptionId
           INNER JOIN wonderbox.SpecificationAttribute AS sa ON sa.Id = sao.SpecificationAttributeId;