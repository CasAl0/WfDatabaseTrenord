CREATE function [dbo].[NewWareHouseData](@clientId int, @from datetime, @to datetime)
returns table
as
return
SELECT wh.[OrderId], wh.[WareHouseId], wh.[ClientId], wh.[SsoUserId], wh.[OrderDate], wh.[ItemId],
			wh.[ProductId], wh.[Sku], wh.[Quantity], wh.[Price], wh.[ProductName], wh.[Description],
			wh.[Token], wh.[SerialNo], wh.[CreatedOn], wh.[BillingRequested], wh.[PaymentMethod],
			fq.[LegacyOrderId], fq.[UserLastname], fq.[UserFirstname], fq.[UserEmail], fq.[OrderSmsNumber]
	FROM [dbo].[WfWareHouse] wh with (nolock)
	INNER JOIN [dbo].[WfFinalQueue] fq with (nolock) ON fq.[Token] = wh.[Token] AND fq.[StateCode] in (10, 90, 99)
	WHERE wh.[ClientId] = @clientId
	AND wh.[OrderDate] BETWEEN @from and @to
