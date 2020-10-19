
create VIEW [wonderbox].[FinalizedOrdersToReconcile]
AS
SELECT distinct cast(O.Id as bigint) AS NumeroOrdine,
		DATEADD(mi, DATEDIFF(mi, GETUTCDATE(), GETDATE()), O.CreatedOnUtc) as DataInserimento,
		O.OrderStatusId AS IdStato,
		O.PaymentStatusId AS IdStatoBanca
	FROM [WonderBox].dbo.[Order] O
		inner join dbo.WfFinalQueue FQ ON cast(FQ.StoreOrderId as int) = O.Id and FQ.ClientId = 1 and FQ.StateCode = 10
	WHERE O.PaymentStatusId = 50
	and O.PaymentMethodSystemName = 'Payments.Unicredit'
	and DATEADD(mi, DATEDIFF(mi, GETUTCDATE(), GETDATE()), O.CreatedOnUtc) < DATEADD(mi, -10, GETDATE())

