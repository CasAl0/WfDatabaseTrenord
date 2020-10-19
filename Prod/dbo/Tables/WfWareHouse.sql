CREATE TABLE [dbo].[WfWareHouse] (
    [WareHouseId]          BIGINT          IDENTITY (1, 1) NOT NULL,
    [ClientId]             INT             NOT NULL,
    [OrderId]              VARCHAR (50)    NOT NULL,
    [SsoUserId]            INT             NULL,
    [OrderDate]            DATETIME        NOT NULL,
    [ItemId]               INT             NOT NULL,
    [ProductId]            INT             NOT NULL,
    [Sku]                  NVARCHAR (400)  NULL,
    [Quantity]             INT             NOT NULL,
    [Price]                DECIMAL (18, 4) NOT NULL,
    [ProductName]          NVARCHAR (400)  NOT NULL,
    [Description]          VARCHAR (MAX)   NULL,
    [Token]                VARCHAR (50)    NULL,
    [SerialNo]             VARCHAR (50)    NULL,
    [CreatedOn]            DATETIME        CONSTRAINT [DF_WfWareHouse_CreatedOn] DEFAULT (getdate()) NULL,
    [BillingRequested]     BIT             NULL,
    [PaymentMethod]        VARCHAR (100)   NULL,
    [CouponUsedValue]      DECIMAL (18, 4) NULL,
    [PaymentTransactionId] VARCHAR (100)   NULL,
    CONSTRAINT [PK_WfWareHouse] PRIMARY KEY CLUSTERED ([WareHouseId] ASC),
    CONSTRAINT [UK_WfWareHouse_Token_SerialNo] UNIQUE NONCLUSTERED ([Token] ASC, [SerialNo] ASC)
);














GO
GRANT SELECT
    ON OBJECT::[dbo].[WfWareHouse] TO [reporting]
    AS [dbo];

