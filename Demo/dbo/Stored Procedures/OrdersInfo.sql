CREATE procedure [dbo].[OrdersInfo]
	@ClientId int,
	@DateFrom date,
	@DateTo date
as
begin

select

	fq.ProductSku as 'Prodotto - Codice Workflow',
	fq.ProductName as 'Prodotto - Nome',
	wh.Description as 'Prodotto - Descrizione',
	fq.OrderDate as 'Ordine - Data',
	fq.Token as 'Ordine - Token',
	fq.LegacyOrderId as 'Ordine - Numero TLN',
	wh.SerialNo as 'Ordine - Numero ticket',
	fq.StoreOrderId as 'Ordine - Numero APP',
	wh.Quantity as 'Ordine - Quantità',
	replace(cast(wh.Price as varchar(100)), '.', ',') as 'Ordine - Prezzo',
	wh.SsoUserId as 'Utente - Codice SSO',
	fq.UserLastname as 'Utente - Cognome',
	fq.UserFirstname as 'Utente - Nome',
	fq.UserEmail as 'Utente - Email'	
	
from WfFinalQueue fq, WfWareHouse wh
where fq.clientid = isnull(@ClientId, fq.ClientId) and fq.StateCode = 10
and fq.OrderDate between isnull(@DateFrom, '2000-01-01') and dateadd(d, 1, isnull(@DateTo,  getdate()))
and fq.Token = wh.Token
order by fq.orderdate asc

end