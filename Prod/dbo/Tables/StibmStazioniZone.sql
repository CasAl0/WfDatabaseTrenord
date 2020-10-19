CREATE TABLE [dbo].[StibmStazioniZone] (
    [ID]             INT          NOT NULL,
    [PricingModelId] INT          NOT NULL,
    [NomeStazione]   VARCHAR (50) NOT NULL,
    [CodiceMir]      VARCHAR (6)  NOT NULL,
    [Rete]           VARCHAR (6)  NOT NULL,
    [Provincia]      VARCHAR (2)  NOT NULL,
    [ZonaId]         INT          NOT NULL,
    CONSTRAINT [PK_StibmStazioniZone] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_StibmStazioniZone_StibmPricingModels] FOREIGN KEY ([PricingModelId]) REFERENCES [dbo].[StibmPricingModels] ([ID])
);

