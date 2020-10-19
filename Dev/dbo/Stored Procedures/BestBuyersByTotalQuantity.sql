CREATE procedure [dbo].[BestBuyersByTotalQuantity]
	@DateFrom date = null,
	@DateTo date = null
as
begin
	with bestbuyers as
	(
		select top 20 wh.SsoUserId, sum(wh.Quantity) as TotalQuantity
		from WfWarehouse wh with (nolock)
		where cast(wh.OrderDate as date) between @DateFrom and @DateTo
		group by wh.SsoUserId
		order by TotalQuantity desc
	)
	select ud.LastName, ud.FirstName, ud.SsoUserId, bb.TotalQuantity, pgwh.ProductGroupDescription, pgwh.Quantity,
	ud.FiscalCode, ud.Birthday, ud.BirthPlace, ud.Nationality, ud.HomeAddress, ud.Email, ud.PhoneNumber
	from bestbuyers bb
	cross apply
	(
		select *
		from sso.UserData(bb.SsoUserId)
	) ud
	cross apply
	(
		select pg.ProductGroupDescription, sum(wh.Quantity) as Quantity
		from WfWareHouse wh with (nolock)
		inner join ProductCodes pc with (nolock) on pc.ProductSku = wh.Sku
		inner join ProductGroup pg with (nolock) on pg.ProductGroupId = pc.ProductGroupId
		where wh.SsoUserId = bb.SsoUserId
		and cast(OrderDate as date) between @DateFrom and @DateTo
		group by pg.ProductGroupDescription
	) pgwh
	order by bb.TotalQuantity desc, pgwh.Quantity desc;

end