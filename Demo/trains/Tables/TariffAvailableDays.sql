CREATE TABLE [trains].[TariffAvailableDays] (
    [TariffAvailableDaysId] BIGINT IDENTITY (1, 1) NOT NULL,
    [TariffDetailsId]       INT    NOT NULL,
    [AvailableDate]         DATE   NOT NULL,
    CONSTRAINT [PK_FreeTimeDays] PRIMARY KEY CLUSTERED ([TariffAvailableDaysId] ASC),
    CONSTRAINT [FK_TariffAvailableDays_TariffDetails] FOREIGN KEY ([TariffDetailsId]) REFERENCES [trains].[TariffDetails] ([TariffDetailsId])
);



