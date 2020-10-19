CREATE TABLE [trains].[ReservationsTariffs] (
    [ReservationsTariffId]       INT            IDENTITY (1, 1) NOT NULL,
    [ReservationId]              INT            NOT NULL,
    [TariffDetailsId]            INT            NOT NULL,
    [Quantity]                   INT            NOT NULL,
    [Price]                      DECIMAL (9, 2) NULL,
    [OriginLegacyStationId]      INT            NULL,
    [DestinationLegacyStationId] INT            NULL,
    [PassengerClass]             VARCHAR (5)    NULL,
    [Via1LegacyStationId]        INT            NULL,
    [Via2LegacyStationId]        INT            NULL,
    [Distance]                   INT            NULL,
    CONSTRAINT [PK_ReservationTariffs] PRIMARY KEY CLUSTERED ([ReservationsTariffId] ASC),
    CONSTRAINT [FK_ReservationTariffs_Reservations] FOREIGN KEY ([ReservationId]) REFERENCES [dbo].[Reservations] ([ReservationId]),
    CONSTRAINT [FK_ReservationTariffs_TariffDetails] FOREIGN KEY ([TariffDetailsId]) REFERENCES [trains].[TariffDetails] ([TariffDetailsId])
);



