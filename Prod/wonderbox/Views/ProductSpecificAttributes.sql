create view wonderbox.ProductSpecificAttributes
as
select pasm.ProductId, sa.Name as SpecificAttributeName, sao.Name as SpecificAttributeValue
from [WonderBox].dbo.Product_SpecificationAttribute_Mapping pasm
INNER JOIN [WonderBox].dbo.SpecificationAttributeOption sao ON sao.Id = pasm.SpecificationAttributeOptionId
INNER JOIN [WonderBox].dbo.SpecificationAttribute sa ON sa.Id = sao.SpecificationAttributeId
