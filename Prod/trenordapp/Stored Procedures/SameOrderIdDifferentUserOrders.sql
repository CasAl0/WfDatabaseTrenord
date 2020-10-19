create procedure [trenordapp].[SameOrderIdDifferentUserOrders]
as
begin
select wh.* from WfWareHouse wh
inner join (
select a.OrderId from (select distinct OrderId, SsoUserId from WfWareHouse where ClientId = 2 group by OrderId, SsoUserId) as a group by a.OrderId having COUNT(a.SsoUserId) > 1
) as b on b.OrderId = wh.OrderId
order by cast(replace(wh.OrderId, 'tnapp-', '') as int) asc, wh.WareHouseId asc
end
GO
GRANT EXECUTE
    ON OBJECT::[trenordapp].[SameOrderIdDifferentUserOrders] TO [reporting]
    AS [dbo];

