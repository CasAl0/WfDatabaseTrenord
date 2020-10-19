CREATE TABLE [dbo].[TariffOvercharges] (
    [TariffOverchargeTypeId] INT           NOT NULL,
    [Description]            NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_TariffOvercharges] PRIMARY KEY CLUSTERED ([TariffOverchargeTypeId] ASC)
);

