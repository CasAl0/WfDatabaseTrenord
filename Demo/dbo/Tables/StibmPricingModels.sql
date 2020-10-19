CREATE TABLE [dbo].[StibmPricingModels] (
    [ID]           INT           NOT NULL,
    [PricingModel] VARCHAR (30)  NOT NULL,
    [Description]  VARCHAR (100) NOT NULL,
    CONSTRAINT [PK_StibmPricingModels] PRIMARY KEY CLUSTERED ([ID] ASC)
);

