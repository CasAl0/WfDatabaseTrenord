CREATE TABLE [dbo].[WfVatRates] (
    [ProductSku] CHAR (8)       NOT NULL,
    [VateRate]   DECIMAL (4, 2) NOT NULL,
    [ValidFrom]  DATE           NOT NULL,
    [ValidTo]    DATE           CONSTRAINT [DF_WfVatRates_ValidTo] DEFAULT ('99991231') NOT NULL,
    [VatCodeId]  INT            CONSTRAINT [DF_WfVatRates_VatCodeId_1] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_WfVatRates] PRIMARY KEY CLUSTERED ([ProductSku] ASC),
    CONSTRAINT [FK_WfVatRates_ProductCodes] FOREIGN KEY ([ProductSku]) REFERENCES [dbo].[ProductCodes] ([ProductSku]),
    CONSTRAINT [FK_WfVatRates_WfVatCodes] FOREIGN KEY ([VatCodeId]) REFERENCES [dbo].[WfVatCodes] ([VatCodeId])
);



