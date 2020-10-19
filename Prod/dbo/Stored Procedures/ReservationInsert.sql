CREATE PROCEDURE [dbo].[ReservationInsert]
    @reservationName VARCHAR(200) ,
    @travelDate DATE = NULL ,
    @productSku CHAR(8) ,
    @partecipiantNo INT ,
    @payerNo INT ,
    @disabledPeopleNo INT ,
    @token VARCHAR(32) ,
    @contactFirstName VARCHAR(200) ,
    @contactLastName VARCHAR(200) ,
    @emailAddress VARCHAR(200) ,
    @phoneNumber VARCHAR(200) ,
    @notes VARCHAR(4000) ,
    @price DECIMAL(9, 2) ,
    @currentSsoUserId INT ,
    @outgoingLastTrainNumber INT = 0 ,
    @returnLastTrainNumber INT = 0 ,
    @originLegacyStationId INT = 0 ,
    @originDescription NVARCHAR(50) = '' ,
    @destinationLegacyStationId INT = 0 ,
    @destinationDescription NVARCHAR(50) = '' ,
    @cityId INT = 0
AS
    BEGIN
        DECLARE @reservationId INT;
        /*
	declare @availability1 int;
	declare @availability2 int;

	select @availability1 = TargetPassengerNumber - ReservedPassengerNumber - @partecipiantNo  from trains.SpecialTrains
	where SpecialTrainId = @outgoingLastTrainNumber;
	
	select @availability2 = TargetPassengerNumber - ReservedPassengerNumber - @partecipiantNo  from trains.SpecialTrains
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

        BEGIN TRANSACTION reservation_insert;
        BEGIN TRY

            INSERT INTO [dbo].[Reservations] ( [ReservationStatusId] ,
                                               [ReservationDate] ,
                                               [ReservationName] ,
                                               [ProductSku] ,
                                               [PartecipiantNo] ,
                                               [PayerNo] ,
                                               [DisabledPeopleNo] ,
                                               [Token] ,
                                               [ContactFirstName] ,
                                               [ContactLastName] ,
                                               [EmailAddress] ,
                                               [PhoneNumber] ,
                                               [Notes] ,
                                               [Price] ,
                                               [LastChangeDate] ,
                                               [CurrentSsoUserId] ,
                                               [CityId] ,
                                               [TravelDate] )
            VALUES ( 1, GETDATE(), @reservationName, @productSku ,
                     @partecipiantNo , @payerNo, @disabledPeopleNo, @token ,
                     @contactFirstName , @contactLastName, @emailAddress ,
                     @phoneNumber , @notes, @price, GETDATE() ,
                     @currentSsoUserId , @cityId, @travelDate );

            SET @reservationId = SCOPE_IDENTITY();

            INSERT INTO [trains].[ReservationsDetails] ( [ReservationId] ,
                                                         [OutgoingLastTrainNumber] ,
                                                         [ReturnLastTrainNumber] ,
                                                         [OriginLegacyStationId] ,
                                                         [OriginDescription] ,
                                                         [DestinationLegacyStationId] ,
                                                         [DestinationDescription] )
            VALUES ( @reservationId, @outgoingLastTrainNumber ,
                     @returnLastTrainNumber , @originLegacyStationId ,
                     @originDescription , @destinationLegacyStationId ,
                     @destinationDescription );


            IF ( @productSku <> 'BGLCOM01' )
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

            COMMIT TRANSACTION reservation_insert;

            RETURN @reservationId;

        END TRY
        BEGIN CATCH
            ROLLBACK TRANSACTION reservation_insert;
            RETURN -99;
        END CATCH;
    END;