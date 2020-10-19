
CREATE FUNCTION [dbo].[GetTariffDetailsId]
    (
      @tariffDetailsId INT ,
      @travelDate DATE
    )
RETURNS INT
AS
    BEGIN
        DECLARE @detailsId INT;
        DECLARE @holiday INT = 0;

	--SELECT @holiday = count(*) from Holidays where HolidayDate = @travelDate;
        IF EXISTS ( SELECT  1
                    FROM    Holidays
                    WHERE   HolidayDate = @travelDate )
            BEGIN
                SET @holiday = 1;
            END;

        SELECT  @detailsId = COALESCE(CASE WHEN @holiday > 0
                                           THEN HolidayTariffDetailsId
                                           ELSE TariffDetailsId
                                      END, @tariffDetailsId)
        FROM    trains.TariffDetails
        WHERE   TariffDetailsId = @tariffDetailsId;

        RETURN @detailsId;
    END;