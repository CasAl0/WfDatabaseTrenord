CREATE TABLE [dbo].[TariffCategoryRules] (
    [TariffCategoryRulesId] INT           IDENTITY (1, 1) NOT NULL,
    [TariffCategoryId]      INT           NOT NULL,
    [OriginKey]             INT           NULL,
    [DestinationKey]        INT           NULL,
    [StationKey]            VARCHAR (10)  NULL,
    [TrainCategory]         VARCHAR (100) NULL,
    CONSTRAINT [PK_TariffCategoryRule] PRIMARY KEY CLUSTERED ([TariffCategoryRulesId] ASC),
    CONSTRAINT [FK_TariffCategoryRules_TariffCategory] FOREIGN KEY ([TariffCategoryId]) REFERENCES [dbo].[TariffCategory] ([TariffCategoryId])
);



