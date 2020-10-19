CREATE TABLE [trains].[ReservationsTariffs] (
    [ReservationId]   INT NOT NULL,
    [TariffDetailsId] INT NOT NULL,
    [Quantity]        INT NOT NULL,
    CONSTRAINT [PK_ReservationTariffs] PRIMARY KEY CLUSTERED ([ReservationId] ASC, [TariffDetailsId] ASC),
    CONSTRAINT [FK_ReservationTariffs_Reservations] FOREIGN KEY ([ReservationId]) REFERENCES [dbo].[Reservations] ([ReservationId]),
    CONSTRAINT [FK_ReservationTariffs_TariffDetails] FOREIGN KEY ([TariffDetailsId]) REFERENCES [trains].[TariffDetails] ([TariffDetailsId])
);

