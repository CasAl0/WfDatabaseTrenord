CREATE TABLE [dbo].[TariffOverchargeCombinations] (
    [TariffOverchargeCombinationId] INT             NOT NULL,
    [TariffOverchargeTypeId]        INT             NOT NULL,
    [TariffValidityId]              INT             NOT NULL,
    [OverchargePrice]               DECIMAL (18, 2) NOT NULL,
    [DistanceFrom]                  INT             NOT NULL,
    [DistanceTo]                    INT             NULL,
    CONSTRAINT [PK_TariffOverchargeCombinations] PRIMARY KEY CLUSTERED ([TariffOverchargeCombinationId] ASC),
    CONSTRAINT [FK_TariffOverchargeCombinations_TariffOvercharges] FOREIGN KEY ([TariffOverchargeTypeId]) REFERENCES [dbo].[TariffOvercharges] ([TariffOverchargeTypeId]),
    CONSTRAINT [FK_TariffOverchargeCombinations_TariffValidity] FOREIGN KEY ([TariffValidityId]) REFERENCES [dbo].[TariffValidity] ([TariffValidityId])
);

