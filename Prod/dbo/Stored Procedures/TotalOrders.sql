CREATE procedure [dbo].[TotalOrders]
	@ClientId int,
	@GroupByType int,
	@PaymentChannelId int = null,
	@DateFrom date = null,
	@DateTo date = null
as
begin

/*
@GroupByType
-------------------------
1 -> tutti i giorni
2 -> tutto il mese
3 -> tutto il giorno
4 -> per ora
-------------------------
*/

select a.descrizione_client as 'Canale Vendita',
case @GroupByType when 1 then null else a.mese_ordine end as 'Mese Ordini',
case @GroupByType when 1 then null when 2 then null else a.data_ordine end as 'Data Ordini',
case @GroupByType when 1 then null when 2 then null when 3 then null when 4 then a.ora_ordine end as 'Ora Ordini',
count(distinct(a.ordine)) as 'Totale - Numero Ordini',
cast(isnull(sum(a.prezzo), 0.0) as money) as 'Totale €',
isnull(sum(a.quantita_pat), 0) as 'P@H - Numero biglietti',
cast(isnull(sum(a.prezzo_pat), 0.0) as money) as 'P@H - Valore €',
isnull(sum(a.quantita_abb + a.quantita_oc + a.quantita_ri), 0) as 'Abbonamenti - Numero',
cast(isnull(sum(a.prezzo_abb + a.prezzo_oc + a.prezzo_ri), 0.0) as money) as 'Abbonamenti - Valore €',
isnull(sum(a.quantita_abb), 0) as 'Nuovi abbonamenti - Numero',
cast(isnull(sum(a.prezzo_abb), 0.0) as money) as 'Nuovi abbonamenti - Valore €',
isnull(sum(a.quantita_oc), 0) as 'OneClick - Numero',
cast(isnull(sum(a.prezzo_oc), 0.0) as money) as 'OneClick - Valore €',
isnull(sum(a.quantita_ri), 0) as 'Rinnovo App - Numero',
cast(isnull(sum(a.prezzo_ri), 0.0) as money) as 'Rinnovo App - Valore €',
isnull(sum(a.quantita_expo1 + a.quantita_expo5 + a.quantita_expo_ar), 0) as 'EXPO - Numero biglietti',
cast(isnull(sum(a.prezzo_expo1 + a.prezzo_expo5 + a.prezzo_expo_ar), 0.0) as money) as 'EXPO - Valore €',
isnull(sum(a.quantita_expo1), 0) as 'EXPO 1 giorno - Numero biglietti',
cast(isnull(sum(a.prezzo_expo1), 0.0) as money) as 'EXPO 1 giorno - Valore €',
isnull(sum(a.quantita_expo5), 0) as 'EXPO 5 giorni - Numero biglietti',
cast(isnull(sum(a.prezzo_expo5), 0.0) as money) as 'EXPO 5 giorni - Valore €',
isnull(sum(a.quantita_expo_ar), 0) as 'EXPO A/R - Numero biglietti',
cast(isnull(sum(a.prezzo_expo_ar), 0.0) as money) as 'EXPO A/R - Valore €',
isnull(sum(a.quantita_mxp_ar), 0) as 'MXP A/R - Numero biglietti',
cast(isnull(sum(a.prezzo_mxp_ar), 0.0) as money) as 'MXP A/R - Valore €',
isnull(sum(a.quantita_tessera_unica + a.quantita_altre_tessere), 0) as 'Tessere - Numero',
cast(isnull(sum(a.prezzo_tessera_unica + a.prezzo_altre_tessere), 0.0) as money) as 'Tessere - Valore €',
isnull(sum(a.quantita_tessera_unica), 0) as 'Tessera unica - Numero',
cast(isnull(sum(a.prezzo_tessera_unica), 0.0) as money) as 'Tessera unica - Valore €',
isnull(sum(a.quantita_altre_tessere), 0) as 'Altre tessere - Numero',
cast(isnull(sum(a.prezzo_altre_tessere), 0.0) as money) as 'Altre tessere - Valore €',
isnull(sum(a.quantita_gardaland + a.quantita_altro), 0) as 'Free Time - Numero biglietti',
cast(isnull(sum(a.prezzo_gardaland + a.prezzo_altro), 0.0) as money) as 'Free Time - Valore €',
isnull(sum(a.quantita_gardaland), 0) as 'GARDALAND - Numero biglietti',
cast(isnull(sum(a.prezzo_gardaland), 0.0) as money) as 'GARDALAND - Valore €',
isnull(sum(a.quantita_altro), 0) as 'Altro - Numero biglietti',
cast(isnull(sum(a.prezzo_altro), 0.0) as money) as 'Altro - Valore €',
count(distinct(a.ordine_paypal)) as 'PayPal - Numero Ordini',
cast(isnull(sum(a.prezzo_paypal), 0.0) as money) as 'PayPal - Valore €',
count(distinct(a.ordine_carta_credito)) as 'Carta di credito - Numero Ordini',
cast(isnull(sum(a.prezzo_carta_credito), 0.0) as money) as 'Carta di credito - Valore €',
count(distinct(a.ordine_n_d)) as 'N.d. - Numero Ordini',
cast(isnull(sum(a.prezzo_n_d), 0.0) as money) as 'N.d. - Valore €'
from
(
select cast(fq.OrderDate as date) as data_ordine,
cast(datepart(yy, fq.Orderdate) as varchar(4)) + '/' + right('00' + cast(datepart(mm, fq.Orderdate) as varchar(2)), 2) as mese_ordine,
right('00' + cast(datepart(HH, fq.Orderdate) as varchar(2)), 2) as ora_ordine,
case fq.ClientId when 1 then 'STORE' when 2 then 'APP' else 'ALTRI CLIENT' end + ' '
+ case when @PaymentChannelId = 0 then '' else isnull(pcs.PaymentChannelDescription, '') end as descrizione_client,
wh.Quantity * wh.Price as prezzo,
case when fq.ProductSku = 'CTR00001' then wh.Quantity else 0 end as quantita_abb,
case when fq.ProductSku = 'CTR00001' then wh.Quantity * wh.Price else 0.0 end as prezzo_abb,
case when fq.ProductSku = 'CTR00002' then wh.Quantity else 0 end as quantita_oc,
case when fq.ProductSku = 'CTR00002' then wh.Quantity * wh.Price else 0.0 end as prezzo_oc,
case when fq.ProductSku = 'CTR00003' then wh.Quantity else 0 end as quantita_ri,
case when fq.ProductSku = 'CTR00003' then wh.Quantity * wh.Price else 0.0 end as prezzo_ri,
case when fq.ProductSku = 'TKH00001' then wh.Quantity else 0 end as quantita_pat,
case when fq.ProductSku = 'TKH00001' then wh.Quantity * wh.Price else 0.0 end as prezzo_pat,
case when fq.ProductSku = 'FTEXPO01' then wh.Quantity else 0 end as quantita_expo1,
case when fq.ProductSku = 'FTEXPO01' then wh.Quantity * wh.Price else 0.0 end as prezzo_expo1,
case when fq.ProductSku = 'FTEXPO05' then wh.Quantity else 0 end as quantita_expo5,
case when fq.ProductSku = 'FTEXPO05' then wh.Quantity * wh.Price else 0.0 end as prezzo_expo5, 
case when fq.ProductSku = 'FTEXPOAR' then wh.Quantity else 0 end as quantita_expo_ar,
case when fq.ProductSku = 'FTEXPOAR' then wh.Quantity * wh.Price else 0.0 end as prezzo_expo_ar,
case when fq.ProductSku = 'FTGARDA1' then wh.Quantity else 0 end as quantita_gardaland,
case when fq.ProductSku = 'FTGARDA1' then wh.Quantity * wh.Price else 0.0 end as prezzo_gardaland,
case when fq.ProductSku = 'TKMAR001' then wh.Quantity else 0 end as quantita_mxp_ar,
case when fq.ProductSku = 'TKMAR001' then wh.Quantity * wh.Price else 0.0 end as prezzo_mxp_ar,
case when fq.ProductSku = 'TSCUN001' then wh.Quantity else 0 end as quantita_tessera_unica,
case when fq.ProductSku = 'TSCUN001' then wh.Quantity * wh.Price else 0.0 end as prezzo_tessera_unica,
case when fq.ProductSku in ('TSCIV001', 'TSCIT001') then wh.Quantity else 0 end as quantita_altre_tessere,
case when fq.ProductSku in ('TSCIV001', 'TSCIT001') then wh.Quantity * wh.Price else 0.0 end as prezzo_altre_tessere,
case when fq.ProductSku not in ('CTR00001', 'CTR00002', 'CTR00003', 'TKH00001', 'FTEXPO01', 'FTEXPO05', 'FTEXPOAR', 'FTGARDA1', 'TKMAR001', 'TSCIV001', 'TSCIT001', 'TSCUN001') then wh.Quantity else 0 end as quantita_altro,
case when fq.ProductSku not in ('CTR00001', 'CTR00002', 'CTR00003', 'TKH00001', 'FTEXPO01', 'FTEXPO05', 'FTEXPOAR', 'FTGARDA1', 'TKMAR001', 'TSCIV001', 'TSCIT001', 'TSCUN001') then wh.Quantity * wh.Price else 0.0 end as prezzo_altro,
case when upper(ltrim(rtrim(isnull(wh.PaymentMethod, '')))) = 'PAYPAL' then wh.Quantity * wh.Price else 0.0 end as prezzo_paypal,
case when upper(ltrim(rtrim(isnull(wh.PaymentMethod, '')))) = 'CARTA DI CREDITO' then wh.Quantity * wh.Price else 0.0 end as prezzo_carta_credito,
case when upper(ltrim(rtrim(isnull(wh.PaymentMethod, '')))) not in ('PAYPAL','CARTA DI CREDITO') then wh.Quantity * wh.Price else 0.0 end as prezzo_n_d,
fq.StoreOrderId as ordine,
case when upper(ltrim(rtrim(isnull(wh.PaymentMethod, '')))) = 'PAYPAL' then fq.StoreOrderId else null end as ordine_paypal,
case when upper(ltrim(rtrim(isnull(wh.PaymentMethod, '')))) = 'CARTA DI CREDITO' then fq.StoreOrderId else null end as ordine_carta_credito,
case when upper(ltrim(rtrim(isnull(wh.PaymentMethod, '')))) not in ('PAYPAL','CARTA DI CREDITO') then fq.StoreOrderId else null end as ordine_n_d
from WfFinalQueue fq with (nolock)
inner join WfWareHouse wh with (nolock) on wh.Token = fq.Token
inner join
(
	select StoreOrderId, ClientId, PaymentChannelId from PaymentConfirmations with (nolock)
	union
	select StoreOrderId, ClientId, 3 from WfFinalQueue with (nolock) where ClientId = 2 and StoreOrderId is not null
) pc on pc.StoreOrderId = fq.StoreOrderId
inner join PaymentChannels pcs with (nolock) on pcs.PaymentChannelId = pc.PaymentChannelId
where fq.clientid = isnull(@ClientId, fq.ClientId) and fq.StateCode = 10
and fq.OrderDate between isnull(@DateFrom, '2000-01-01') and dateadd(d, 1, isnull(@DateTo,  getdate()))
and (@PaymentChannelId = 0 or pc.PaymentChannelId = isnull(@PaymentChannelId, pc.PaymentChannelId))
) a
group by a.descrizione_client,
case @GroupByType when 1 then null else a.mese_ordine end,
case @GroupByType when 1 then null when 2 then null else a.data_ordine end,
case @GroupByType when 1 then null when 2 then null when 3 then null when 4 then a.ora_ordine end
order by 2 asc, 3 asc, 4 asc, a.descrizione_client

end




