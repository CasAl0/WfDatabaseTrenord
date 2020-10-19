CREATE TABLE [dbo].[Reservations] (
    [ReservationId]          INT            IDENTITY (1, 1) NOT NULL,
    [ReservationStatusId]    INT            NOT NULL,
    [ReservationDate]        DATETIME       NOT NULL,
    [ReservationName]        VARCHAR (200)  NOT NULL,
    [ProductSku]             CHAR (8)       NOT NULL,
    [PartecipiantNo]         INT            CONSTRAINT [DF_Reservations_PartecipiantNo] DEFAULT ((0)) NOT NULL,
    [PayerNo]                INT            CONSTRAINT [DF_Reservations_PayerNo] DEFAULT ((0)) NOT NULL,
    [DisabledPeopleNo]       INT            CONSTRAINT [DF_Reservations_DisabledPeopleNumber] DEFAULT ((0)) NOT NULL,
    [CityId]                 INT            NOT NULL,
    [Token]                  VARCHAR (32)   NULL,
    [ClientId]               INT            NULL,
    [StoreOrderId]           VARCHAR (50)   NULL,
    [ContactFirstName]       VARCHAR (200)  NULL,
    [ContactLastName]        VARCHAR (200)  NULL,
    [EmailAddress]           VARCHAR (200)  NULL,
    [PhoneNumber]            VARCHAR (200)  NULL,
    [Notes]                  VARCHAR (4000) NULL,
    [Price]                  DECIMAL (9, 2) NULL,
    [ExternalTicketNumber]   NVARCHAR (50)  NULL,
    [LastChangeDate]         DATETIME       NOT NULL,
    [CurrentSsoUserId]       INT            NULL,
    [ExtendingReservationId] INT            NULL,
    [TravelDate]             DATE           NULL,
    CONSTRAINT [PK_Reservations] PRIMARY KEY CLUSTERED ([ReservationId] ASC),
    CONSTRAINT [FK_Reservations_Client] FOREIGN KEY ([ClientId]) REFERENCES [dbo].[Client] ([ClientId]),
    CONSTRAINT [FK_Reservations_ProductCodes] FOREIGN KEY ([ProductSku]) REFERENCES [dbo].[ProductCodes] ([ProductSku]),
    CONSTRAINT [FK_Reservations_ReservationStatus] FOREIGN KEY ([ReservationStatusId]) REFERENCES [dbo].[ReservationStatus] ([ReservationStatusId])
);



