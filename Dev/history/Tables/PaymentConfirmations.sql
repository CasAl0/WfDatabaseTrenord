﻿CREATE TABLE [history].[PaymentConfirmations] (
    [StoreOrderId]       VARCHAR (50) NOT NULL,
    [ClientId]           INT          NOT NULL,
    [ConfirmPaymentDate] DATETIME     NOT NULL,
    [PaymentChannelId]   INT          NOT NULL,
    CONSTRAINT [PK_PaymentConfirmations] PRIMARY KEY CLUSTERED ([StoreOrderId] ASC, [ClientId] ASC),
    CONSTRAINT [FK_PaymentConfirmations_PaymentChannels] FOREIGN KEY ([PaymentChannelId]) REFERENCES [dbo].[PaymentChannels] ([PaymentChannelId])
);



