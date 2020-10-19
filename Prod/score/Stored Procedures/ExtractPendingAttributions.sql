

CREATE procedure [score].[ExtractPendingAttributions]

as 

begin
	select at.*, ass.PartnerUserName, c.TransactionCode, p.*
	from score.Associations ass
	inner join score.Attributions at on at.AssociationId = ass.AssociationId
	inner join score.AttributionStatus ats on ats.AttributionStatusId = at.AttributionStatusId
	inner join score.Combinations c on c.CombinationId = at.CombinationId
	inner join dbo.Partners p on p.PartnerId = c.PartnerId
	where ats.RetryToSend = 1
	order by at.AttributionId asc;
end
