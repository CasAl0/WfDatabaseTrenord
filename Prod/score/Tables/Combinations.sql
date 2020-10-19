CREATE TABLE [score].[Combinations] (
    [CombinationId]   INT           IDENTITY (1, 1) NOT NULL,
    [ProductSku]      CHAR (8)      NOT NULL,
    [TariffId]        INT           NOT NULL,
    [Points]          INT           NOT NULL,
    [ValidFrom]       DATE          CONSTRAINT [DF_ProductTariffPoints_ValidFrom] DEFAULT (getdate()) NOT NULL,
    [ValidTo]         DATE          CONSTRAINT [DF_ProductTariffPoints_ValidTo] DEFAULT ('29990101') NOT NULL,
    [PartnerId]       INT           NOT NULL,
    [TransactionCode] NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_Combinations] PRIMARY KEY CLUSTERED ([CombinationId] ASC),
    CONSTRAINT [FK_Combinations_Partners] FOREIGN KEY ([PartnerId]) REFERENCES [dbo].[Partners] ([PartnerId]),
    CONSTRAINT [FK_Combinations_ProductCodes] FOREIGN KEY ([ProductSku]) REFERENCES [dbo].[ProductCodes] ([ProductSku]),
    CONSTRAINT [FK_Combinations_ProductCodes1] FOREIGN KEY ([ProductSku]) REFERENCES [dbo].[ProductCodes] ([ProductSku]),
    CONSTRAINT [FK_Combinations_Tariff] FOREIGN KEY ([TariffId]) REFERENCES [dbo].[Tariff] ([TariffId]),
    CONSTRAINT [FK_Combinations_Tariff1] FOREIGN KEY ([TariffId]) REFERENCES [dbo].[Tariff] ([TariffId])
);

