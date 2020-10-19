CREATE TABLE [dbo].[TariffCategory] (
    [TariffCategoryId] INT          NOT NULL,
    [Code]             VARCHAR (10) NOT NULL,
    [Description]      VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_TariffCategory] PRIMARY KEY CLUSTERED ([TariffCategoryId] ASC)
);

