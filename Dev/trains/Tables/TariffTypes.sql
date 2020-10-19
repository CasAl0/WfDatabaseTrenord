CREATE TABLE [trains].[TariffTypes] (
    [TariffTypeId]      INT          NOT NULL,
    [TariffTypeCode]    VARCHAR (2)  NOT NULL,
    [TariffDescription] VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_ProductTariffTypes] PRIMARY KEY CLUSTERED ([TariffTypeId] ASC)
);

