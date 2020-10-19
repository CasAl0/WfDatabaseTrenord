CREATE procedure [dbo].[TotalGroupOrders]
	@ClientId int,
	@GroupByType int,
	@PaymentChannelId int,
	@DateFrom date = null,
	@DateTo date = null
as
begin

/*
@GroupByType
-------------------------
1 -> tutto insieme
2 -> tutto il mese
3 -> tutto il giorno
-------------------------
*/

if not exists(select 1 from Client where ClientId = @ClientId)
begin
	select 'Indicare un @ClientId valido' as Errore;
	return;
end

if @GroupByType <> 1 and @GroupByType <> 2 and @GroupByType <> 3
begin
	select 'Indicare un @GroupByType valido' as Errore;
	return;
end

if not exists(select 1 from PaymentChannels where PaymentChannelId = @PaymentChannelId)
begin
	select 'Indicare un @PaymentChannelId valido' as Errore;
	return;
end

declare @data varchar(10)
declare @sql nvarchar(4000);

create table #report (ProductGroupId int not null, ProductGroup varchar(50) not null);

insert into #report (ProductGroupId, ProductGroup)
select ProductGroupId, ProductGroupDescription from ProductGroup;

declare dates cursor fast_forward for
select distinct case @GroupByType
				when 1 then cast(datepart(yy, OrderDate) as varchar(4)) 
				when 2 then cast(datepart(yy, OrderDate) as varchar(4)) + right('00' + cast(datepart(mm, OrderDate) as varchar(2)), 2)
				when 3 then convert(varchar, OrderDate, 112) end as OrderDate
from WfFinalQueue
where cast(Orderdate as date)
between isnull(@DateFrom, (select min(cast(Orderdate as date)) from WfFinalQueue with (nolock)))
and isnull(@DateTo, (select max(cast(Orderdate as date)) from WfFinalQueue with (nolock)))
order by OrderDate asc;

open dates;

fetch next from dates into @data;

set @sql = '';

while @@fetch_status = 0
begin
	set @sql = 'ALTER TABLE #report ADD Number_' + @data + ' bigint, Price_' + @data + ' money;';
	execute sp_executesql @sql;

	set @sql = 'update #report set
	Number_' + @data + ' = a.quantita,
	Price_' + @data + ' = cast(a.prezzo as money)
	from (
	select pgs.ProductGroupId as pgid,
	isnull(sum(wh.Quantity), 0) as quantita,
	isnull(sum(wh.Quantity * wh.Price), 0) as prezzo
	from WfFinalQueue fq with (nolock)
	inner join WfWareHouse wh with (nolock) on wh.Token = fq.Token
	inner join ProductGroupSku pgs with (nolock) on pgs.ProductSku = fq.ProductSku';
	if @ClientId = 1
	begin
		set @sql = @sql + ' inner join PaymentConfirmations pc with (nolock) on pc.StoreOrderId = fq.StoreOrderId';
		set @sql = @sql + ' inner join PaymentChannels pcs with (nolock) on pcs.PaymentChannelId = pc.PaymentChannelId';
	end
	set @sql = @sql + ' where fq.clientid = ' + cast(@ClientId as varchar(10)) + ' and fq.StateCode = 10';

	if @GroupByType = 1
	begin
		set @sql = @sql + ' and cast(datepart(yy, fq.OrderDate) as varchar(4)) = ''' + @data + '''';
	end
	if @GroupByType = 2
	begin
		set @sql = @sql + ' and cast(datepart(yy, fq.Orderdate) as varchar(4)) + right(''00'' + cast(datepart(mm, fq.Orderdate) as varchar(2)), 2) = ''' + @data + '''';
	end
	if @GroupByType = 3
	begin
		set @sql = @sql + ' and convert(varchar, fq.OrderDate, 112) = ''' + @data + '''';
	end

	if @ClientId = 1
	begin
		set @sql = @sql + ' and pc.PaymentChannelId = ' + cast(@PaymentChannelId as varchar(10));
	end
	set @sql = @sql + ' group by pgs.ProductGroupId) as a where ProductGroupId = a.pgid;';
	execute sp_executesql @sql;

	set @sql = 'update #report set Number_' + @data + ' = 0 where Number_' + @data + ' is null;
				update #report set Price_' + @data + ' = ''0,0'' where Price_' + @data + ' is null;';
	execute sp_executesql @sql;

	fetch next from dates into @data;
end

close dates;
deallocate dates;

select * from #report;

drop table #report;

end