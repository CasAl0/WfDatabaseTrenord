
CREATE PROCEDURE [dbo].[MailInsert] (
@mailType INT,
@gift BIT,
@templateid VARCHAR(50),
@token VARCHAR(32),
@attachment VARCHAR(255) = NULL,
@copyaddress VARCHAR(255) = NULL)
AS
BEGIN
    -- @mailType
    -- 1 -> Abbonamenti
    -- 2 -> Tessere
    -- 3 -> Print@Home
    -- 4 -> FreeTime
    -- 5 -> Carnet
    -- 6 -> Biglietto Carnet
    -- 7 -> Carte prepagate
    -- 8 -> Prenotazioni
    DECLARE @abbonamenti     INT = 1,
            @Tessere         INT = 2,
            @Print@Home      INT = 3,
            @FreeTime        INT = 4,
            @Carnet          INT = 5,
            @BigliettoCarnet INT = 6,
            @CartePrepagate  INT = 7,
            @Prenotazioni    INT = 8;

    DECLARE @fromaddress       VARCHAR(255),
            @mailSubjectPrefix VARCHAR(255),
            @subject           VARCHAR(255),
            @body              VARCHAR(MAX),
            @ishtml            BIT,
            @toaddress         VARCHAR(255),
            @ccnaddress        VARCHAR(255),
            @writemail         BIT;

    SET @writemail = 1;

    SELECT @fromaddress = DefaultFromMailAddress,
           @mailSubjectPrefix = ISNULL(MailSubjectPrefix, '')
      FROM WfConfiguration WITH (NOLOCK)
     WHERE [Current] = 1;


    /* Lo trasformo da 3 a 8 visto che si tratta di un biglietto comitive. vedi metodo SendReservationTicket() della classe Handlers.MailHandler del workflow */
    IF UPPER(@templateid) = 'PRENOTAZIONETICKET'
    BEGIN
        SET @mailType = 8;
    END;

    DECLARE @recipient        VARCHAR(255),
            @recipient_email  VARCHAR(255),
            @value            DECIMAL(18, 2),
            @buyer            VARCHAR(255),
            @buyer_email      VARCHAR(255),
            @buyer_text       VARCHAR(255),
            @coupon           VARCHAR(255),
            @couponType       INT,
            @couponTemplateid VARCHAR(50);

    IF @mailType = @CartePrepagate
    BEGIN
        SELECT      @recipient = cd.RecipientName,
                    @recipient_email = cd.RecipientEmail,
                    @value = cd.Amount,
                    @buyer = cd.SenderName,
                    @buyer_email = cd.SenderEmail,
                    @buyer_text = cd.SenderMessage,
                    @coupon = c.CouponCode,
                    @couponType = c.CouponTypeId,
                    @couponTemplateid = ct.MailTemplateId
          FROM      Coupons AS c
         INNER JOIN CouponsDetails AS cd
            ON cd.CouponId     = c.CouponId
         INNER JOIN CouponTypes AS ct
            ON ct.CouponTypeId = c.CouponTypeId
         WHERE      c.CreationToken = @token;

        SET @templateid = ISNULL(@couponTemplateid, @templateid) + CASE
                                                                        WHEN @gift = 1 THEN '_Regalo'
                                                                        ELSE '' END;

        IF @couponType <> 1
       AND @gift = 1
        BEGIN
            SET @writemail = 0;
        END;
    END;

    IF @writemail = 1
    BEGIN
        SELECT @subject = [Subject],
               @body = Body,
               @ishtml = COALESCE(IsHtml, 1),
               @toaddress = ToAddress,
               @fromaddress = CASE
                                   WHEN FromAddress IS NULL THEN @fromaddress
                                   ELSE FromAddress END,
               @ccnaddress = CcnAddress
          FROM MailTemplate WITH (NOLOCK)
         WHERE MailTemplateId = @templateid;

        DECLARE @userProfile  VARCHAR(10),
                @useremail    VARCHAR(255),
                @nome         VARCHAR(255),
                @cognome      VARCHAR(255),
                @ordine       VARCHAR(50),
                @ordinelegacy VARCHAR(50),
                @description  VARCHAR(MAX),
                @product      VARCHAR(50),
                @releaseDate  VARCHAR(50),
                @releasePlace VARCHAR(255);

        SELECT @userProfile = UserProfile,
               @useremail = LOWER(UserEmail),
               @nome = UserFirstname,
               @cognome = UserLastname,
               @ordine = StoreOrderId,
               @ordinelegacy = LegacyOrderId,
               @description = [Description],
               @product = ProductName,
               @releaseDate = ReleaseDate,
               @releasePlace = ReleasePlace
          FROM WfFinalQueue WITH (NOLOCK)
         WHERE Token = @token;

        IF LEN(LTRIM(RTRIM(@useremail))) > 0
        BEGIN
            SET @toaddress = REPLACE(@toaddress, '#useremail', @useremail);
        END;

        SET @subject = REPLACE(@subject, '{#ordine}', COALESCE(@ordine, 'n.d.'));
        SET @subject = REPLACE(@subject, '{#ordinelegacy}', COALESCE(@ordinelegacy, 'n.d.'));

        SET @body = REPLACE(@body, '{#ordine}', COALESCE(@ordine, 'n.d.'));
        SET @body = REPLACE(@body, '{#ordinelegacy}', COALESCE(@ordinelegacy, 'n.d.'));
        SET @body = REPLACE(@body, '{#description}', COALESCE(@description, 'n.d.'));
        SET @body = REPLACE(@body, '{#nome}', COALESCE(@nome, 'n.d.'));
        SET @body = REPLACE(@body, '{#cognome}', COALESCE(@cognome, 'n.d.'));
        SET @body = REPLACE(@body, '{#product}', COALESCE(@product, 'n.d.'));
        SET @body = REPLACE(@body, '{#today+1}', COALESCE(CONVERT(VARCHAR, DATEADD(d, 1, GETDATE()), 103), 'n.d.'));

        IF @mailType = @abbonamenti --1
        BEGIN
            SET @body = REPLACE(@body, '{#releaseDate}', COALESCE(@releaseDate, 'n.d.'));
            SET @body = REPLACE(@body, '{#releasePlace}', COALESCE(@releasePlace, 'n.d.'));

            SELECT @description = ObjectBase64
              FROM WfSession WITH (NOLOCK)
             WHERE Token      = @token
               AND ObjectName = '_descriptionIta';

            SET @body = REPLACE(@body, '{#descriptionIta}', COALESCE(@description, 'n.d.'));

            SELECT @description = ObjectBase64
              FROM WfSession WITH (NOLOCK)
             WHERE Token      = @token
               AND ObjectName = '_descriptionEng';

            SET @body = REPLACE(@body, '{#descriptionEng}', COALESCE(@description, 'n.d.'));
        END;
        ELSE IF @mailType = @Tessere --2
        BEGIN
            DECLARE @shippingaddress VARCHAR(MAX);

            SELECT @shippingaddress = ObjectBase64
              FROM WfSession WITH (NOLOCK)
             WHERE Token      = @token
               AND ObjectName = '_shippingaddress';

            SET @body = REPLACE(@body, '{#shippingaddress}', COALESCE(@shippingaddress, 'n.d.'));
        END;
        /*
		else if @mailType = @Print@Home --3
		begin
		end
		else if @mailType = @FreeTime --4
		begin
		end
		*/
        ELSE IF @mailType = @Carnet --5
        BEGIN
            DECLARE @pnr         VARCHAR(MAX),
                    @origin      VARCHAR(MAX),
                    @destination VARCHAR(MAX);

            SELECT @pnr = ObjectBase64
              FROM WfSession WITH (NOLOCK)
             WHERE Token      = @token
               AND ObjectName = '_pnr';

            SET @body = REPLACE(@body, '{#pnr}', COALESCE(@pnr, 'n.d.'));

            SELECT @origin = ObjectBase64
              FROM WfSession WITH (NOLOCK)
             WHERE Token      = @token
               AND ObjectName = '_origin';

            SET @body = REPLACE(@body, '{#origine}', COALESCE(@origin, 'n.d.'));

            SELECT @destination = ObjectBase64
              FROM WfSession WITH (NOLOCK)
             WHERE Token      = @token
               AND ObjectName = '_destination';

            SET @body = REPLACE(@body, '{#destinazione}', COALESCE(@destination, 'n.d.'));
        END;
        ELSE IF @mailType = @BigliettoCarnet --6
        BEGIN
            SELECT @toaddress = ObjectBase64
              FROM WfSession WITH (NOLOCK)
             WHERE Token      = @token
               AND ObjectName = '_toaddress';

            SELECT @pnr = ObjectBase64
              FROM WfSession WITH (NOLOCK)
             WHERE Token      = @token
               AND ObjectName = 'counterfoilPnr';

            SET @subject = REPLACE(@subject, '{#pnr_matrice}', COALESCE(@pnr, 'n.d.'));
        END;
        ELSE IF @mailType = @CartePrepagate --7
        BEGIN
            IF @gift = 1
            BEGIN
                SET @toaddress = @recipient_email;
            END;

            SET @subject = REPLACE(@subject, '{#acquirente}', COALESCE(@buyer, 'n.d.'));

            SET @body = REPLACE(@body, '{#destinatario}', COALESCE(@recipient, 'n.d.'));
            SET @body = REPLACE(@body, '{#destinatario_email}', COALESCE(@recipient_email, 'n.d.'));
            SET @body = REPLACE(@body, '{#valore}', COALESCE(@value, 'n.d.'));
            SET @body = REPLACE(@body, '{#acquirente}', COALESCE(@buyer, 'n.d.'));
            SET @body = REPLACE(@body, '{#acquirente_email}', COALESCE(@buyer_email, 'n.d.'));
            SET @body = REPLACE(@body, '{#acquirente_messaggio}', COALESCE(@buyer_text, 'n.d.'));
            SET @body = REPLACE(@body, '{#coupon}', COALESCE(@coupon, 'n.d.'));
        END;
        ELSE IF @mailType = @Prenotazioni --8
        BEGIN

            DECLARE @reservationId        VARCHAR(200),
                    @externalTicketNumber VARCHAR(200),
                    @lastChangeDate       VARCHAR(200),
                    @status               VARCHAR(200),
                    @date                 VARCHAR(200),
                    @name                 VARCHAR(200),
                    @city                 VARCHAR(200),
                    @partecipiantNo       VARCHAR(200),
                    @payerNo              VARCHAR(200),
                    @disabledPeopleNo     VARCHAR(200),
                    @lastname             VARCHAR(200),
                    @firstname            VARCHAR(200),
                    @email                VARCHAR(200),
                    @phone                VARCHAR(200),
                    @originStation        VARCHAR(200),
                    @outgoingTrain        VARCHAR(200),
                    @returnTrain          VARCHAR(200);

            SELECT      @reservationId = CAST(ReservationId AS VARCHAR(200)),
                        @product = pc.ProductDescription,
                        @externalTicketNumber = CAST(ExternalTicketNumber AS VARCHAR(200)),
                        @lastChangeDate
                            = CONVERT(VARCHAR, LastChangeDate, 103) + ' ' + CONVERT(VARCHAR, LastChangeDate, 108),
                        @status = StatusDescription,
                        @date = CONVERT(VARCHAR, ReservationDate, 103) + ' ' + CONVERT(VARCHAR, ReservationDate, 108),
                        @name = Name,
                        @city = c.Description,
                        @partecipiantNo = CAST(PartecipiantNo AS VARCHAR(200)),
                        @payerNo = CAST(PayerNo AS VARCHAR(200)),
                        @disabledPeopleNo = CAST(DisabledPeopleNo AS VARCHAR(200)),
                        @lastname = ContactLastName,
                        @firstname = ContactFirstName,
                        @email = EmailAddress,
                        @phone = PhoneNumber,
                        @originStation = rd.OriginDescription,
                        @outgoingTrain = s1.Description,
                        @returnTrain = s2.Description
              FROM      ReservationsData AS rd
             INNER JOIN ProductCodes AS pc
                ON pc.ProductSku     = rd.ProductSku
              LEFT JOIN Cities AS c
                ON c.CityId          = rd.CityId
              LEFT JOIN trains.SpecialTrainsData AS s1
                ON s1.SpecialTrainId = rd.OutgoingLastTrainNumber
              LEFT JOIN trains.SpecialTrainsData AS s2
                ON s2.SpecialTrainId = rd.ReturnLastTrainNumber
             WHERE      rd.Token = @token;

            SET @body = REPLACE(@body, '{#reservationId}', COALESCE(@reservationId, ''));
            SET @body = REPLACE(@body, '{#externalTicketNumber}', COALESCE(@externalTicketNumber, ''));
            SET @body = REPLACE(@body, '{#lastChangeDate}', COALESCE(@lastChangeDate, ''));
            SET @body = REPLACE(@body, '{#status}', COALESCE(@status, ''));
            SET @body = REPLACE(@body, '{#date}', COALESCE(@date, ''));
            SET @body = REPLACE(@body, '{#name}', COALESCE(@name, ''));
            SET @body = REPLACE(@body, '{#city}', COALESCE(@city, ''));
            SET @body = REPLACE(@body, '{#partecipiantNo}', COALESCE(@partecipiantNo, ''));
            SET @body = REPLACE(@body, '{#payerNo}', COALESCE(@payerNo, ''));
            SET @body = REPLACE(@body, '{#disabledPeopleNo}', COALESCE(@disabledPeopleNo, ''));
            SET @body = REPLACE(@body, '{#lastname}', COALESCE(@lastname, ''));
            SET @body = REPLACE(@body, '{#firstname}', COALESCE(@firstname, ''));
            SET @body = REPLACE(@body, '{#email}', COALESCE(@email, ''));
            SET @body = REPLACE(@body, '{#phone}', COALESCE(@phone, ''));
            SET @body = REPLACE(@body, '{#origin}', COALESCE(@originStation, ''));
            SET @body = REPLACE(@body, '{#outgoingTrain}', COALESCE(@outgoingTrain, ''));
            SET @body = REPLACE(@body, '{#returnTrain}', COALESCE(@returnTrain, ''));

            SET @subject = REPLACE(@subject, '{#reservationId}', COALESCE(@reservationId, ''));
            SET @subject = REPLACE(@subject, '{#externalTicketNumber}', COALESCE(@externalTicketNumber, ''));

            SET @fromaddress = 'comitiva_cliente_' + @reservationId + '@trenord.it';

            /* Lo trasformo da 3 a 8 visto che si tratta di un biglietto comitive. vedi metodo SendReservationTicket() della classe Handlers.MailHandler del workflow */
            IF UPPER(@templateid) = 'PRENOTAZIONETICKET'
            BEGIN
                SET @fromaddress = 'noreply@trenord.it';
            END;

        END;

        SET @subject = REPLACE(@subject, '{#product}', COALESCE(@product, 'n.d.'));

        SET @subject = @mailSubjectPrefix + @subject;

        INSERT INTO Mail (IsHtml,
                          FromAddress,
                          ToAddress,
                          CcnAddress,
                          [Subject],
                          Body,
                          CreationDate,
                          [Status],
                          Attachment,
                          UserProfile)
        VALUES (@ishtml, @fromaddress, @toaddress, @ccnaddress, @subject, @body, GETDATE(), '0', @attachment,
                @userProfile);

        DECLARE @idIns AS INT = 0;
        SET @idIns = SCOPE_IDENTITY();

        IF UPPER(@templateid) = 'PRENOTAZIONETICKET'
        BEGIN
            INSERT INTO dbo.Mail (IsHtml,
                                  FromAddress,
                                  FromName,
                                  ToAddress,
                                  ToName,
                                  ReplyToAddress,
                                  [Subject],
                                  Body,
                                  CreationDate,
                                  [Status],
                                  ErrorMessage,
                                  Attachment,
                                  SentDate,
                                  CcnAddress,
                                  CcnName,
                                  UserProfile)
            SELECT IsHtml,
                   FromAddress,
                   FromName,
                   'comitive@trenord.it',
                   ToAddress, --ToName,
                   ReplyToAddress,
                   [Subject],
                   Body,
                   CreationDate,
                   [Status],
                   ErrorMessage,
                   Attachment,
                   SentDate,
                   NULL, --CcnAddress
                   CcnName,
                   UserProfile
              FROM dbo.Mail
             WHERE IdMail = @idIns;
        END;


        IF @copyaddress IS NOT NULL
        BEGIN
            INSERT INTO Mail (IsHtml,
                              FromAddress,
                              ToAddress,
                              CcnAddress,
                              [Subject],
                              Body,
                              CreationDate,
                              [Status],
                              Attachment,
                              UserProfile)
            VALUES (@ishtml, @fromaddress, @copyaddress, @ccnaddress, @subject, @body, GETDATE(), '0', @attachment,
                    @userProfile);
        END;
    END;
END;