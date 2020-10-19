CREATE TABLE [score].[AttributionStatus] (
    [AttributionStatusId] INT           NOT NULL,
    [PartnerId]           INT           NULL,
    [Code]                NVARCHAR (50) NOT NULL,
    [Description]         NVARCHAR (50) NOT NULL,
    [RetryToSend]         BIT           CONSTRAINT [DF_AttributionStatus_RetryToSend] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_AttributionStatus] PRIMARY KEY CLUSTERED ([AttributionStatusId] ASC),
    CONSTRAINT [FK_AttributionStatus_Partners] FOREIGN KEY ([PartnerId]) REFERENCES [dbo].[Partners] ([PartnerId])
);

