

CREATE VIEW [wonderbox].[OrdersToReconcile]
AS
	select distinct cast(Id as bigint) AS NumeroOrdine,
	dateadd(mi, datediff(mi, getutcdate(), getdate()), CreatedOnUtc) as DataInserimento,
	OrderStatusId AS IdStato,
	PaymentStatusId AS IdStatoBanca,
	cast(case when PaymentMethodSystemName = 'Payments.Unicredit' then 1 else 0 end as bit) as Riconcilia
	from wonderbox.Orders
	Where OrderStatusId in (10, 20)
	and dateadd(mi, datediff(mi, getutcdate(), getdate()), CreatedOnUtc) < dateadd(mi, -10, getdate())
	and CreatedOnUtc > getutcdate() - 20


