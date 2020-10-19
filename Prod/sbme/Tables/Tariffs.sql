CREATE TABLE [sbme].[Tariffs] (
    [TariffKey]           VARCHAR (10)  NOT NULL,
    [TariffMiniName]      VARCHAR (6)   NOT NULL,
    [TariffShortName]     VARCHAR (16)  NOT NULL,
    [TariffLongName]      VARCHAR (30)  NOT NULL,
    [Description]         VARCHAR (128) NULL,
    [ContractClassId]     INT           NOT NULL,
    [ProviderId]          INT           NOT NULL,
    [SaleAgentListId]     INT           NOT NULL,
    [OperatorListId]      INT           NOT NULL,
    [EnglishTariffName]   VARCHAR (30)  NULL,
    [FrenchTariffName]    VARCHAR (30)  NULL,
    [GermanTariffName]    VARCHAR (30)  NULL,
    [ExtraLangTariffName] VARCHAR (30)  NULL,
    [Priority]            INT           NULL,
    [Status]              VARCHAR (6)   NOT NULL,
    CONSTRAINT [PK_Tariffs] PRIMARY KEY CLUSTERED ([TariffKey] ASC)
);

