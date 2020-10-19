CREATE TABLE [trains].[TariffPrices] (
    [TariffPricesId]  INT            NOT NULL,
    [TariffDetailsId] INT            NOT NULL,
    [DistanceFrom]    INT            NOT NULL,
    [DistanceTo]      INT            NULL,
    [DayType]         INT            NOT NULL,
    [Price]           DECIMAL (9, 2) NOT NULL,
    CONSTRAINT [PK_TariffPrices_1] PRIMARY KEY CLUSTERED ([TariffPricesId] ASC),
    CONSTRAINT [FK_TariffPrices_TariffDetails] FOREIGN KEY ([TariffDetailsId]) REFERENCES [trains].[TariffDetails] ([TariffDetailsId])
);






GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'0 = non definito; 1 = feriali; 2 = festivi', @level0type = N'SCHEMA', @level0name = N'trains', @level1type = N'TABLE', @level1name = N'TariffPrices', @level2type = N'COLUMN', @level2name = N'DayType';

