CREATE TABLE [trains].[TariffValidityRules] (
    [TariffValidityRulesId] INT      NOT NULL,
    [TariffDetailsId]       INT      NOT NULL,
    [DistanceFrom]          INT      NULL,
    [DistanceTo]            INT      NULL,
    [ValidityHours]         INT      NULL,
    [ValidityStartTime]     TIME (3) NULL,
    [ValidityEndTime]       TIME (3) NULL,
    [ValidityStartDateTime] DATETIME NULL,
    [ValidityEndDateTime]   DATETIME NULL,
    [ValidityMinutes]       INT      NULL,
    CONSTRAINT [PK_TariffValidityRules] PRIMARY KEY CLUSTERED ([TariffValidityRulesId] ASC),
    CONSTRAINT [FK_TariffValidityRules_TariffDetails] FOREIGN KEY ([TariffDetailsId]) REFERENCES [trains].[TariffDetails] ([TariffDetailsId])
);





