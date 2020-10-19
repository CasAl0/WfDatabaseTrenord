CREATE TABLE [trains].[ReservationsDetails] (
    [ReservationId]              INT           NOT NULL,
    [OutgoingLastTrainNumber]    INT           NULL,
    [ReturnLastTrainNumber]      INT           NULL,
    [OriginLegacyStationId]      INT           NULL,
    [OriginDescription]          NVARCHAR (50) NULL,
    [DestinationLegacyStationId] INT           NULL,
    [DestinationDescription]     NVARCHAR (50) NULL,
    CONSTRAINT [PK_Reservations] PRIMARY KEY CLUSTERED ([ReservationId] ASC),
    CONSTRAINT [FK_ReservationsDetails_Reservations] FOREIGN KEY ([ReservationId]) REFERENCES [dbo].[Reservations] ([ReservationId])
);

