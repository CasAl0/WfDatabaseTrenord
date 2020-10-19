CREATE TABLE [dbo].[CP_Tariff] (
    [TariffMapId]            INT            NOT NULL,
    [ClientId]               INT            NOT NULL,
    [ProductSku]             CHAR (8)       NOT NULL,
    [TariffId]               INT            NOT NULL,
    [OverrideDescription]    VARCHAR (200)  NULL,
    [OverrideDescription_en] VARCHAR (200)  NULL,
    [OverrideFixedPrice]     DECIMAL (9, 2) NULL,
    [FilterExpression]       VARCHAR (20)   NULL,
    [OrderExpression]        INT            NULL,
    [PassengerClasses]       VARCHAR (10)   NULL,
    [SellingBeginDate]       DATE           CONSTRAINT [DF_CP_Tariff_BeginDate1] DEFAULT ('20140101') NOT NULL,
    [SellingEndDate]         DATE           CONSTRAINT [DF_CP_Tariff_EndDate1] DEFAULT ('29990101') NOT NULL,
    CONSTRAINT [PK_Tariff] PRIMARY KEY CLUSTERED ([TariffMapId] ASC),
    CONSTRAINT [FK_CP_Tariff_ProductCodes] FOREIGN KEY ([ProductSku]) REFERENCES [dbo].[ProductCodes] ([ProductSku]),
    CONSTRAINT [FK_CP_Tariff_Tariff] FOREIGN KEY ([TariffId]) REFERENCES [dbo].[Tariff] ([TariffId])
);












GO


