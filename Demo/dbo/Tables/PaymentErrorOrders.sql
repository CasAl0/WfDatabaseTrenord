CREATE TABLE [dbo].[PaymentErrorOrders] (
    [StoreOrderId]       VARCHAR (50) NOT NULL,
    [ClientId]           INT          NOT NULL,
    [CreationDate]       DATETIME     CONSTRAINT [DF_PaymentErrorOrders_CreationDate] DEFAULT (getdate()) NOT NULL,
    [PaymentStatusOrder] VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_PaymentErrorOrders] PRIMARY KEY CLUSTERED ([StoreOrderId] ASC, [ClientId] ASC)
);

