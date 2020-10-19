CREATE PROCEDURE [dbo].[ReservationUpdate]
    @reservationId INT ,
    @reservationStatusId INT ,
    @reservationName VARCHAR(200) ,
    @productSku CHAR(8) ,
    @partecipiantNo INT ,
    @payerNo INT ,
    @disabledPeopleNo INT ,
    @contactFirstName VARCHAR(200) ,
    @contactLastName VARCHAR(200) ,
    @emailAddress VARCHAR(200) ,
    @phoneNumber VARCHAR(200) ,
    @notes VARCHAR(4000) ,
    @price DECIMAL(9, 2) ,
    @externalTicketNumber NVARCHAR(50) ,
    @currentSsoUserId INT ,
    @outgoingLastTrainNumber INT = 0 ,
    @returnLastTrainNumber INT = 0 ,
    @originLegacyStationId INT = 0 ,
    @originDescription NVARCHAR(50) = '' ,
    @destinationLegacyStationId INT = 0 ,
    @destinationDescription NVARCHAR(50) = '' ,
    @cityId INT = 0 , 
	@travelDate DATE = NULL
AS
    BEGIN
        DECLARE @reserved INT;
        DECLARE @oldoutgoing INT;
        DECLARE @oldreturn INT;

        SELECT @oldoutgoing = OutgoingLastTrainNumber ,
               @oldreturn = ReturnLastTrainNumber
        FROM   trains.ReservationsDetails
        WHERE  ReservationId = @reservationId;

        SELECT @reserved = PartecipiantNo
        FROM   Reservations
        WHERE  ReservationId = @reservationId;

        /*
	declare @availability1 int;
	declare @availability2 int;

	select @availability1 = TargetPassengerNumber - ReservedPassengerNumber
	+ case when @oldoutgoing = @outgoingLastTrainNumber then @reserved else 0 end
	- @partecipiantNo
	from trains.SpecialTrains
	where SpecialTrainId = @outgoingLastTrainNumber;
	
	select @availability2 = TargetPassengerNumber - ReservedPassengerNumber
	+ case when @oldreturn = @returnLastTrainNumber then @reserved else 0 end
	- @partecipiantNo
	from trains.SpecialTrains
	where SpecialTrainId = @returnLastTrainNumber;

	if @availability1 < 0 and @availability2 < 0
	begin
		return -1;
	end

	if @availability1 < 0
	begin
		return -2;
	end
	
	if @availability2 < 0
	begin
		return -3;
	end
	*/

        BEGIN TRANSACTION reservation_update;
        BEGIN TRY

            UPDATE trains.SpecialTrains
            SET    ReservedPassengerNumber = ReservedPassengerNumber - @reserved
            WHERE  SpecialTrainId = @oldoutgoing;

            UPDATE trains.SpecialTrains
            SET    ReservedPassengerNumber = ReservedPassengerNumber - @reserved
            WHERE  SpecialTrainId = @oldreturn;

            UPDATE [dbo].[Reservations]
            SET    [ReservationStatusId] = @reservationStatusId ,
                   [ReservationName] = @reservationName ,
                   [ProductSku] = @productSku ,
                   [PartecipiantNo] = @partecipiantNo ,
                   [PayerNo] = @payerNo ,
                   [DisabledPeopleNo] = @disabledPeopleNo ,
                   [ContactFirstName] = @contactFirstName ,
                   [ContactLastName] = @contactLastName ,
                   [EmailAddress] = @emailAddress ,
                   [PhoneNumber] = @phoneNumber ,
                   [Notes] = @notes ,
                   [Price] = @price ,
                   [ExternalTicketNumber] = @externalTicketNumber ,
                   [LastChangeDate] = GETDATE() ,
                   [CurrentSsoUserId] = @currentSsoUserId ,
                   [CityId] = @cityId , 
				   [TravelDate] = @travelDate
            WHERE  ReservationId = @reservationId;

            UPDATE [trains].[ReservationsDetails]
            SET    [OutgoingLastTrainNumber] = @outgoingLastTrainNumber ,
                   [ReturnLastTrainNumber] = @returnLastTrainNumber ,
                   [OriginLegacyStationId] = @originLegacyStationId ,
                   [OriginDescription] = @originDescription ,
                   [DestinationLegacyStationId] = @destinationLegacyStationId ,
                   [DestinationDescription] = @destinationDescription
            WHERE  ReservationId = @reservationId;

            IF @reservationStatusId <> 4
                BEGIN
                    UPDATE trains.SpecialTrains
                    SET    ReservedPassengerNumber = ReservedPassengerNumber
                                                     + @partecipiantNo
                    WHERE  SpecialTrainId = @outgoingLastTrainNumber;

                    UPDATE trains.SpecialTrains
                    SET    ReservedPassengerNumber = ReservedPassengerNumber
                                                     + @partecipiantNo
                    WHERE  SpecialTrainId = @returnLastTrainNumber;
                END;

            COMMIT TRANSACTION reservation_update;
            RETURN 0;

        END TRY
        BEGIN CATCH
            ROLLBACK TRANSACTION reservation_update;
            RETURN -99;
        END CATCH;
    END;