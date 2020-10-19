
CREATE procedure [dbo].[ReportReservations]
as
begin
select rd.ReservationId as 'Prenotazione - Numero',
rd.ReservationDate as 'Prenotazione - Data', 
pc.ProductDescription as 'Prenotazione - Evento',
rd.ReservationName as 'Prenotazione - Nome',
rd.PartecipiantNo as 'Prenotazione - Partecipanti',
rd.PayerNo as 'Prenotazione - Paganti',
rd.DisabledPeopleNo as 'Prenotazione - Disabili',
coalesce(rd.ExternalTicketNumber, '') as 'Prenotazione - Pratica CRM',
rd.StatusDescription as 'Prenotazione - Stato',
coalesce(s.NomeStazione, '') as 'Prenotazione - Partenza',
coalesce(c.Description + ' (' + c.ProvinceCode + ')', '') as 'Prenotazione - Comune',
coalesce(rd.ContactLastName, '') as 'Referente - Cognome',
coalesce(rd.ContactFirstName, '') as 'Referente - Nome',
coalesce(rd.EmailAddress, '') as 'Referente - Mail',
coalesce(rd.PhoneNumber, '') as 'Referente - Telefono',
coalesce(std1.DestinationDescription, '') as 'Treno Afflusso - Stazione porta',
coalesce(left(convert(varchar, std1.ArrivalTime, 108), 5), '') as 'Treno Afflusso - Orario porta',
coalesce(std1.TrainNumber, '') as 'Treno Afflusso - Numero',
coalesce(cast(std1.TotalPassengerNumber as varchar(10)), '') as 'Treno Afflusso - Posti offerti',
coalesce(cast(std1.TargetPassengerNumber as varchar(10)), '') as 'Treno Afflusso - Posti target',
coalesce(cast(std1.ReservedPassengerNumber as varchar(10)), '') as 'Treno Afflusso - Posti prenotati',
coalesce(cast(std1.TargetPassengerNumber - std1.ReservedPassengerNumber as varchar(10)), '') as 'Treno Afflusso - Posti disponibili',
coalesce(std2.OriginDescription, '') as 'Treno Defflusso - Stazione porta',
coalesce(left(convert(varchar, std2.DepartureTime, 108), 5), '') as 'Treno Defflusso - Orario porta',
coalesce(std2.TrainNumber, '') as 'Treno Defflusso - Numero',
coalesce(cast(std2.TotalPassengerNumber as varchar(10)), '') as 'Treno Defflusso - Posti offerti',
coalesce(cast(std2.TargetPassengerNumber as varchar(10)), '') as 'Treno Defflusso - Posti target',
coalesce(cast(std2.ReservedPassengerNumber as varchar(10)), '') as 'Treno Defflusso - Posti prenotati',
coalesce(cast(std2.TargetPassengerNumber - std2.ReservedPassengerNumber as varchar(10)), '') as 'Treno Defflusso - Posti disponibili'
from ReservationsData rd
inner join ProductCodes pc on pc.ProductSku = rd.ProductSku
left join tln.Stazioni s on s.IdStazione = rd.OriginLegacyStationId
left join trains.SpecialTrainsData std1 on std1.SpecialTrainId = rd.OutgoingLastTrainNumber
left join trains.SpecialTrainsData std2 on std2.SpecialTrainId = rd.ReturnLastTrainNumber
left join Cities c on c.CityId = rd.CityId
order by rd.ReservationId asc
end