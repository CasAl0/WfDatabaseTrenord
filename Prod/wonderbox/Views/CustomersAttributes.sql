


create VIEW [wonderbox].[CustomersAttributes]
AS
	select g.* from [WonderBox].dbo.Customer c
	inner join [WonderBox].dbo.GenericAttribute g on g.EntityId = c.Id
	where g.KeyGroup = 'Customer'

