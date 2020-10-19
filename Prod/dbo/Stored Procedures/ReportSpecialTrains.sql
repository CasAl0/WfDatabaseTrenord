
CREATE procedure [dbo].[ReportSpecialTrains]
as
begin
select
coalesce(TrainNumber, '') as 'Treno - Numero',
case when ReturnTrain = 0 then coalesce(DestinationDescription, '') else coalesce(OriginDescription, '') end as 'Treno - Stazione porta',
case when ReturnTrain = 0 then 'Afflusso' else 'Deflusso' end as 'Treno - Afflusso / Deflusso',
case when ReturnTrain = 0 then coalesce(left(convert(varchar, ArrivalTime, 108), 5), '')
else coalesce(left(convert(varchar, DepartureTime, 108), 5), '') end as 'Treno - Orario porta',
coalesce(cast(TotalPassengerNumber as varchar(10)), '') as 'Treno - Posti offerti',
coalesce(cast(TargetPassengerNumber as varchar(10)), '') as 'Treno - Posti target',
coalesce(cast(ReservedPassengerNumber as varchar(10)), '') as 'Treno - Posti prenotati',
coalesce(cast(TargetPassengerNumber - ReservedPassengerNumber as varchar(10)), '') as 'Treno - Posti disponibili',
SpecialTrainsDirectionId as 'Direttrice - Codice',
DirectionDescription as 'Direttrice - Descrizione'
from trains.SpecialTrainsData
order by 2 asc, 3 asc, 4 asc 
end