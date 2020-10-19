CREATE TABLE [dbo].[CouponTypeSku] (
    [CouponTypeId] INT      NOT NULL,
    [ProductSku]   CHAR (8) NOT NULL,
    CONSTRAINT [PK_CouponTypeSku] PRIMARY KEY CLUSTERED ([CouponTypeId] ASC, [ProductSku] ASC),
    CONSTRAINT [FK_CouponTypeSku_CouponTypes] FOREIGN KEY ([CouponTypeId]) REFERENCES [dbo].[CouponTypes] ([CouponTypeId]),
    CONSTRAINT [FK_CouponTypeSku_ProductCodes] FOREIGN KEY ([ProductSku]) REFERENCES [dbo].[ProductCodes] ([ProductSku])
);



