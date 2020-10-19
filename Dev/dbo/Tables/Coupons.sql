CREATE TABLE [dbo].[Coupons] (
    [CouponId]             INT          IDENTITY (1, 1) NOT NULL,
    [CouponCode]           VARCHAR (50) COLLATE Latin1_General_CS_AI NOT NULL,
    [CouponTypeId]         INT          NOT NULL,
    [ValidityFrom]         DATE         NULL,
    [ValidityTo]           DATE         NULL,
    [LastChangeDate]       DATETIME     NOT NULL,
    [CreationClientId]     INT          NULL,
    [CreationStoreOrderId] VARCHAR (50) NULL,
    [CreationToken]        VARCHAR (32) NULL,
    CONSTRAINT [PK_Coupons] PRIMARY KEY CLUSTERED ([CouponId] ASC),
    CONSTRAINT [FK_Coupons_CouponTypes] FOREIGN KEY ([CouponTypeId]) REFERENCES [dbo].[CouponTypes] ([CouponTypeId])
);





