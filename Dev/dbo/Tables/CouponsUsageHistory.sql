CREATE TABLE [dbo].[CouponsUsageHistory] (
    [CouponUsageHistoryId] INT             IDENTITY (1, 1) NOT NULL,
    [CouponId]             INT             NOT NULL,
    [ClientId]             INT             NULL,
    [StoreOrderId]         VARCHAR (50)    NULL,
    [Value]                DECIMAL (18, 2) NOT NULL,
    [LegacyOrderId]        VARCHAR (50)    NULL,
    [Token]                VARCHAR (32)    NULL,
    [LastChangeDate]       DATETIME        CONSTRAINT [DF_CouponsUsageHistory_LastChangeDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_CouponsUsageHistory] PRIMARY KEY CLUSTERED ([CouponUsageHistoryId] ASC),
    CONSTRAINT [FK_CouponsUsageHistory_Coupons] FOREIGN KEY ([CouponId]) REFERENCES [dbo].[Coupons] ([CouponId])
);







