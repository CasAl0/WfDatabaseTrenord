CREATE TABLE [dbo].[ProductAvailableDays] (
    [ProductAvailableDaysId] BIGINT   NOT NULL,
    [ProductSku]             CHAR (8) NOT NULL,
    [AvailableDate]          DATE     NOT NULL,
    CONSTRAINT [PK_FreeTimeDays] PRIMARY KEY CLUSTERED ([ProductAvailableDaysId] ASC),
    CONSTRAINT [FK_ProductAvailableDays_ProductCodes] FOREIGN KEY ([ProductSku]) REFERENCES [dbo].[ProductCodes] ([ProductSku])
);



