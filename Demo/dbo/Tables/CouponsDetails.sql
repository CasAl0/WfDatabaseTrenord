CREATE TABLE [dbo].[CouponsDetails] (
    [CouponId]       INT             NOT NULL,
    [Amount]         DECIMAL (18, 2) NOT NULL,
    [SenderName]     NVARCHAR (4000) NULL,
    [SenderEmail]    NVARCHAR (4000) NULL,
    [SenderMessage]  NVARCHAR (4000) NULL,
    [RecipientName]  NVARCHAR (4000) NULL,
    [RecipientEmail] NVARCHAR (4000) NULL,
    CONSTRAINT [PK_CouponsDetails] PRIMARY KEY CLUSTERED ([CouponId] ASC),
    CONSTRAINT [FK_CouponsDetails_Coupons] FOREIGN KEY ([CouponId]) REFERENCES [dbo].[Coupons] ([CouponId])
);



