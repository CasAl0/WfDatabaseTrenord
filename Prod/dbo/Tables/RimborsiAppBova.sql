CREATE TABLE [dbo].[RimborsiAppBova] (
    [ID]                   INT             NOT NULL,
    [ClientId]             INT             NOT NULL,
    [OrderId]              VARCHAR (50)    NOT NULL,
    [SsoUserId]            INT             NULL,
    [OrderDate]            DATETIME        NOT NULL,
    [ItemId]               INT             CONSTRAINT [DF__RimborsiA__ItemI__5911273F] DEFAULT ((0)) NOT NULL,
    [ProductId]            INT             CONSTRAINT [DF__RimborsiA__Produ__5A054B78] DEFAULT ((0)) NOT NULL,
    [Sku]                  NVARCHAR (400)  NULL,
    [Quantity]             INT             CONSTRAINT [DF__RimborsiA__Quant__5AF96FB1] DEFAULT ((1)) NOT NULL,
    [Price]                DECIMAL (18, 4) NOT NULL,
    [ProductName]          NVARCHAR (400)  NOT NULL,
    [Description]          VARCHAR (MAX)   CONSTRAINT [DF__RimborsiA__Descr__5BED93EA] DEFAULT ('RIMBORSI APP BOVA') NULL,
    [Token]                VARCHAR (50)    NULL,
    [SerialNo]             VARCHAR (50)    CONSTRAINT [DF__RimborsiA__Seria__5CE1B823] DEFAULT ((0)) NULL,
    [CreatedOn]            DATETIME        CONSTRAINT [DF__RimborsiA__Creat__5DD5DC5C] DEFAULT ('20191018') NULL,
    [BillingRequested]     BIT             CONSTRAINT [DF__RimborsiA__Billi__5ECA0095] DEFAULT ((0)) NULL,
    [PaymentMethod]        VARCHAR (100)   CONSTRAINT [DF__RimborsiA__Payme__5FBE24CE] DEFAULT ('satispay - satispay') NULL,
    [CouponUsedValue]      DECIMAL (18, 4) NULL,
    [PaymentTransactionId] VARCHAR (100)   NULL
);

