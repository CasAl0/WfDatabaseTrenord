



CREATE VIEW [wonderbox].[CustomerSsoUser]
AS
	select distinct EntityId as CustomerId, convert(int, g1.Value) as SsoUserId, g2.SsoProfile
	from [WonderBox].dbo.GenericAttribute g1
	cross apply
	(
		select value as SSOProfile from [WonderBox].dbo.GenericAttribute
		where EntityId = g1.EntityId  and [KeyGroup] = 'Customer' and [Key] = 'SsoProfileType'
	) g2
	where [KeyGroup] = 'Customer' and [Key] = 'SSOUserId'



