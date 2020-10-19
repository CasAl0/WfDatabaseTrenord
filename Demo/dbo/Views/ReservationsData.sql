






CREATE VIEW [dbo].[ReservationsData]
AS
select r.*,
r.ReservationId as Id,
r.ReservationName as Name,
case when DATEDIFF(d, r.ReservationDate, getdate()) > pc.ExpirationReservationDays and rs.ReservationStatusId = 1 then 5 else rs.ReservationStatusId end as StatusId,
case when DATEDIFF(d, r.ReservationDate, getdate()) > pc.ExpirationReservationDays and rs.ReservationStatusId = 1 then 'SCADUTA' else rs.Description end as StatusDescription,
rd.OutgoingLastTrainNumber, rd.ReturnLastTrainNumber,
rd.OriginLegacyStationId, rd.OriginDescription,
rd.DestinationLegacyStationId, rd.DestinationDescription
from Reservations r with (nolock)
inner join ReservationStatus rs with (nolock) on rs.ReservationStatusId = r.ReservationStatusId
inner join trains.ReservationsDetails rd with (nolock) on rd.ReservationId = r.ReservationId
inner join ProductCodes pc with (nolock) on pc.ProductSku = r.ProductSku