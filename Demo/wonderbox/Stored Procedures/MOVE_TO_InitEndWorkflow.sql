CREATE Procedure [wonderbox].[MOVE_TO_InitEndWorkflow]
as
begin
	
	print 'START - ' + convert(varchar, getdate(), 108);
	
	declare @tokenItems table
	(
		Token varchar(32) not null,
		SerialNo varchar(50) not null,
		BillingRequested bit null,
		OrderId int not null,
		OrderDate datetime not null,
		ProductName nvarchar(400) not null
	);

	declare @ids table (Id varchar(50) not null);

	declare @finalizeTokenDays int;

	select @finalizeTokenDays = - FinalizeTokenDays from dbo.WfConfiguration with (nolock) where [Current] = 1;

	delete from dbo.PaidOrders;

	print 'PULIZIA SOTTOINSIEME ORDINI - ' + convert(varchar, getdate(), 108);

	insert into dbo.PaidOrders (ClientId, StoreOrderId, OrderDate, BillingAddressId, CustomerId, PaymentMethodSystemName, Paid)	
	select 1, Id, dateadd(mi, datediff(mi, getutcdate(), getdate()), CreatedOnUtc) as OrderDate, BillingAddressId, CustomerId, PaymentMethodSystemName,
	cast(case when OrderStatusId = 30 and PaymentStatusId = 30 then 1 else 0 end as bit) as Paid
	from wonderbox.Orders where CreatedOnUtc > dateadd(d, @finalizeTokenDays, getutcdate());

	print 'INSERIMENTO SOTTOINSIEME ORDINI - ' + convert(varchar, getdate(), 108);

	insert into @ids (Id)
	select StoreOrderId from dbo.PaidOrders where ClientId = 1 and Paid = 1
	except
	select StoreOrderId from dbo.WfFinalQueue with (nolock) where ClientId = 1 and StoreOrderId is not null;

	print 'ORDINI - ' + convert(varchar, getdate(), 108);

	declare @idsNo int;

	select @idsNo = count(*) from @ids;

	if @idsNo > 0
	begin
		with Pending as
		(
			select o.StoreOrderId, o.OrderDate, oi.BillingRequested, p.Name as ProductName,
			cast(cast(replace(oi.AttributesXml, '<ProductVariantAttribute ID="' + cast(pam.Id as varchar(10)) + '">', '<ProductVariantAttribute ID="WFTOKEN">') as xml)
			.query('/Attributes[1]/ProductVariantAttribute[@ID="WFTOKEN"]/ProductVariantAttributeValue[1]/Value[1]/text()') as varchar(100)) as Attributes
			from @ids i
			inner join dbo.PaidOrders o on o.StoreOrderId = i.Id and o.ClientId = 1
			inner join wonderbox.OrderItems oi on oi.OrderId = o.StoreOrderId
			inner join wonderbox.Products p on p.Id = oi.ProductId
			inner join wonderbox.ProductAttributeMappings pam on p.Id = pam.ProductId and pam.ProductAttributeId = 21			
		)
		insert into @tokenItems (OrderId, OrderDate, BillingRequested, ProductName,Token, SerialNo)
		select pg.StoreOrderId, pg.OrderDate, pg.BillingRequested, pg.ProductName, pg.Token, pg.SerialNo
		from dbo.WfFinalQueue fq inner join (
		select StoreOrderId, OrderDate, BillingRequested, ProductName, left(Attributes, 32) AS Token, substring(Attributes, 34, 100) AS SerialNo
		from Pending) pg on fq.Token = pg.Token
		where fq.StateCode = 0;
	
		print 'INFORMAZIONI ORDINI - ' + convert(varchar, getdate(), 108);

		with PendingGiftCardsToRegister as 
		(
			select o.StoreOrderId, o.OrderDate, oi.BillingRequested, p.Name as ProductName, cp.CreationToken
			from @ids i
			inner join dbo.PaidOrders o on o.StoreOrderId = i.Id and o.ClientId = 1
			inner join wonderbox.OrderItems oi on oi.OrderId = o.StoreOrderId
			inner join wonderbox.GiftCards gc on gc.PurchasedWithOrderItemId = oi.Id
			inner join wonderbox.Products p on p.Id = oi.ProductId
			inner join dbo.Coupons cp on cp.CouponCode = gc.GiftCardCouponCode
		)
		insert into @tokenItems (OrderId, OrderDate, BillingRequested, ProductName,Token, SerialNo)
		select pg.StoreOrderId, pg.OrderDate, pg.BillingRequested, pg.ProductName, pg.CreationToken, ''
		from dbo.WfFinalQueue fq inner join PendingGiftCardsToRegister pg on fq.Token = pg.CreationToken
		where fq.StateCode = 0;
	
		print 'INFORMAZIONI NUOVI COUPON - ' + convert(varchar, getdate(), 108);
	
		insert into dbo.WfFinalQueueItems (Token, SerialNo, BillingRequested)
		select Token, SerialNo, BillingRequested from @tokenItems;
	
		print 'INSERIMENTO ITEMS - ' + convert(varchar, getdate(), 108);
	
		update WfFinalQueue set
		WfFinalQueue.StateCode = 1,
		WfFinalQueue.StoreOrderId = a.OrderId,
		WfFinalQueue.OrderDate = a.OrderDate,
		WfFinalQueue.ProductName = a.ProductName
		from @tokenItems a
		where WfFinalQueue.Token = a.Token;

		print 'FINALIZZAZIONI IN PRELAVORAZIONE - ' + convert(varchar, getdate(), 108);

		insert into dbo.CouponsUsageHistory (CouponId, ClientId, StoreOrderId, Value)
		select c.CouponId, c.CreationClientId, gcuh.UsedWithOrderId, gcuh.UsedValue
		from  @ids i
		inner join wonderbox.GiftCardUsageHistory gcuh on gcuh.UsedWithOrderId = i.Id
		inner join wonderbox.GiftCards gc on gc.Id = gcuh.GiftCardId	
		inner join dbo.Coupons c on c.CouponCode = gc.GiftCardCouponCode and c.CreationClientId = 1
		except
		select CouponId, ClientId, StoreOrderId, Value from dbo.CouponsUsageHistory;
	
		print 'ALLINEAMENTO STORICO UTILIZZI COUPON - ' + convert(varchar, getdate(), 108);
	end

	delete from @ids

	print 'PULIZIA TABELLA TEMPORANEA @ids - ' + convert(varchar, getdate(), 108);
	
	delete from @tokenItems;

	print 'PULIZIA TABELLA TEMPORANEA @tokenItems - ' + convert(varchar, getdate(), 108);
end