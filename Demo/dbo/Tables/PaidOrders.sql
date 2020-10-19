CREATE TABLE [dbo].[PaidOrders] (
    [ClientId]                INT             NOT NULL,
    [StoreOrderId]            VARCHAR (50)    NOT NULL,
    [OrderDate]               DATETIME        NOT NULL,
    [BillingAddressId]        INT             NULL,
    [CustomerId]              INT             NULL,
    [PaymentMethodSystemName] NVARCHAR (4000) NULL,
    [Paid]                    BIT             CONSTRAINT [DF_PaidOrders_Paid] DEFAULT ((1)) NOT NULL,
    [Pending]                 BIT             CONSTRAINT [DF_PaidOrders_Pending] DEFAULT ((0)) NOT NULL,
    [Voided]                  BIT             CONSTRAINT [DF_PaidOrders_Voided] DEFAULT ((0)) NOT NULL
);


GO
CREATE NONCLUSTERED INDEX [IX_PaidOrders]
    ON [dbo].[PaidOrders]([OrderDate] ASC);

