CREATE procedure [dbo].[BestBuyersByTotalPrice]
	@DateFrom date = null,
	@DateTo date = null
as
begin
	
	set @DateFrom = coalesce(@DateFrom, '2000-01-01');
	set @DateTo = coalesce(@DateTo, getdate());

	with bestbuyers as
	(
		select top 20 wh.SsoUserId, cast(sum(wh.Quantity * wh.Price) as money) as TotalPrice
		from WfWarehouse wh with (nolock)
		where cast(wh.OrderDate as date) between @DateFrom and @DateTo
		group by wh.SsoUserId
		order by TotalPrice desc
	)
	select ud.LastName, ud.FirstName, ud.SsoUserId, bb.TotalPrice, pgwh.ProductGroupDescription, pgwh.Price,
	ud.FiscalCode, ud.Birthday, ud.BirthPlace, ud.Nationality, ud.HomeAddress, ud.Email, ud.PhoneNumber
	from bestbuyers bb
	cross apply
	(
		select *
		from sso.UserData(bb.SsoUserId)
	) ud
	cross apply
	(
		select pg.ProductGroupDescription, cast(sum(wh.Quantity * wh.Price) as money) as Price
		from WfWareHouse wh with (nolock)
		inner join ProductCodes pc with (nolock) on pc.ProductSku = wh.Sku
		inner join ProductGroup pg with (nolock) on pg.ProductGroupId = pc.ProductGroupId
		where wh.SsoUserId = bb.SsoUserId
		and cast(OrderDate as date) between @DateFrom and @DateTo
		group by pg.ProductGroupDescription
	) pgwh
	order by bb.TotalPrice desc, pgwh.Price desc;

end