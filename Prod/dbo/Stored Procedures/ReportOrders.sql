CREATE procedure [dbo].[ReportOrders]
	@ClientId int,
	@DateFrom date = null,
	@DateTo date = null
as
begin

declare @params as varchar(1000);

set @params = dbo.ReportParameters(@ClientId, null, null, null, null, null, null, null, @DateFrom, @DateTo);

select c.ClientId, c.ClientDescription as Provenienza, fq.StoreOrderId as NumeroOrdineProvenienza, wh.PaymentMethod as MetodoPagamento, 
pcs.PaymentChannelDescription as CanaleVendita, fq.OrderDate as DataOrdine,
cast(sum(wh.Quantity + wh.Price) as money) as PrezzoTotale,
fq.UserLastname as CognomeAcquirente, fq.UserFirstname as NomeAcquirente, fq.UserEmail as EmailAcquirente, fq.OrderSmsNumber as TelefonoAcquirente,
@params as SearchParameters
from WfFinalQueue fq with (nolock)
inner join WfWareHouse wh with (nolock) on wh.Token = fq.Token
inner join Client c with (nolock) on c.ClientId = fq.ClientId
left join PaymentConfirmations pc with (nolock) on pc.StoreOrderId = fq.StoreOrderId and pc.ClientId = fq.ClientId
left join PaymentChannels pcs with (nolock) on pcs.PaymentChannelId = pc.PaymentChannelId
where (@ClientId = 0 or fq.ClientId = @ClientId)
and fq.OrderDate between isnull(@DateFrom, '2000-01-01') and dateadd(d, 1, isnull(@DateTo,  getdate()))
group by c.ClientDescription, fq.StoreOrderId, wh.PaymentMethod, pcs.PaymentChannelDescription, c.ClientId, fq.OrderDate,
fq.UserLastname, fq.UserFirstname, fq.UserEmail, fq.OrderSmsNumber
order by fq.OrderDate asc, c.ClientId asc, fq.StoreOrderId asc;

end
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[ReportOrders] TO [reporting]
    AS [dbo];

