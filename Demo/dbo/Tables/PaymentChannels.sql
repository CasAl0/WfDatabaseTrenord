CREATE TABLE [dbo].[PaymentChannels] (
    [PaymentChannelId]          INT          NOT NULL,
    [PaymentChannelDescription] VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_PaymentChannel] PRIMARY KEY CLUSTERED ([PaymentChannelId] ASC)
);

