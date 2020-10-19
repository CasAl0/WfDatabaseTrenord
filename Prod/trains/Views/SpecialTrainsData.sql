


CREATE view [trains].[SpecialTrainsData]
as 
select top 100 percent
right('0' + cast(st.SpecialTrainsDirectionId as varchar(10)), 2)
+ ' - ' + case st.ReturnTrain when 0 then st.DestinationDescription else st.OriginDescription end
+ ' - ' + case st.ReturnTrain when 0 then left(convert(varchar, st.ArrivalTime, 108), 5) else left(convert(varchar, st.DepartureTime, 108), 5) end
+ ' - ' + st.TrainNumber
+ ' - TGT: ' + cast(st.TargetPassengerNumber as varchar(10))
+ ' - OCC: ' + cast(st.ReservedPassengerNumber as varchar(10))
+ ' - DISP: ' + cast(st.TargetPassengerNumber - st.ReservedPassengerNumber as varchar(10))
+ case when st.DisabledPeopleTrain = 1 then ' - DISABILI' else '' end
as Description,
std.Description as DirectionDescription,
st.*
from trains.SpecialTrains st
inner join trains.SpecialTrainsSku sts on sts.SpecialTrainId = st.SpecialTrainId
inner join trains.SpecialTrainsDirections std on std.SpecialTrainsDirectionId = st.SpecialTrainsDirectionId
order by st.DestinationDescription asc, st.ArrivalTime asc