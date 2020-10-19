CREATE TABLE [dbo].[TariffValidity] (
    [TariffValidityId] INT           NOT NULL,
    [Description]      NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_TariffValidity] PRIMARY KEY CLUSTERED ([TariffValidityId] ASC)
);

