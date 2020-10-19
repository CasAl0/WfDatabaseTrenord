CREATE TABLE [trains].[SpecialTrainsSku] (
    [SpecialTrainId] INT      NOT NULL,
    [ProductSku]     CHAR (8) NOT NULL,
    CONSTRAINT [PK_SpecialTrainsSku] PRIMARY KEY CLUSTERED ([SpecialTrainId] ASC, [ProductSku] ASC),
    CONSTRAINT [FK_SpecialTrainsSku_ProductCodes] FOREIGN KEY ([ProductSku]) REFERENCES [dbo].[ProductCodes] ([ProductSku]),
    CONSTRAINT [FK_SpecialTrainsSku_SpecialTrains] FOREIGN KEY ([SpecialTrainId]) REFERENCES [trains].[SpecialTrains] ([SpecialTrainId])
);



