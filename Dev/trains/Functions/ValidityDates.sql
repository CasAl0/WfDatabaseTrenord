CREATE FUNCTION [trains].[ValidityDates] (@tariffDetailsId INT,
                                         @distance INT,
                                         @travelDate DATETIME)
RETURNS TABLE
AS
RETURN WITH startdate
         AS (SELECT CASE
                         WHEN ValidityStartDateTime IS NOT NULL THEN ValidityStartDateTime
                         WHEN ValidityStartTime IS NOT NULL THEN
                             CAST(LEFT(CONVERT(VARCHAR, @travelDate, 126), 10) + 'T'
                                  + CONVERT(VARCHAR, ValidityStartTime, 114) AS DATETIME)
                         ELSE @travelDate END AS StartDate,
                    TariffValidityRulesId
               FROM trains.TariffValidityRules
              WHERE TariffDetailsId = @tariffDetailsId
                AND @distance BETWEEN COALESCE(DistanceFrom, 0) AND COALESCE(DistanceTo, @distance))
SELECT      sd.StartDate,
            DATEADD(
                ss,
                -1,
                CASE
                     WHEN tvr.ValidityEndDateTime IS NOT NULL THEN tvr.ValidityEndDateTime
                     WHEN tvr.ValidityHours IS NOT NULL THEN DATEADD(hh, tvr.ValidityHours, sd.StartDate)
                     WHEN tvr.ValidityEndTime IS NOT NULL THEN
                         CAST(LEFT(CONVERT(VARCHAR, sd.StartDate, 126), 10) + 'T'
                              + CONVERT(VARCHAR, tvr.ValidityEndTime, 114) AS DATETIME)
                     WHEN tvr.ValidityMinutes IS NOT NULL THEN DATEADD(MINUTE, tvr.ValidityMinutes, sd.StartDate)
                     ELSE sd.StartDate END) AS EndDate
  FROM      trains.TariffValidityRules AS tvr
 INNER JOIN startdate AS sd
    ON sd.TariffValidityRulesId = tvr.TariffValidityRulesId;