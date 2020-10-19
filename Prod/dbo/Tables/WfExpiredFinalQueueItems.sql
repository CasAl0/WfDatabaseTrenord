CREATE TABLE [dbo].[WfExpiredFinalQueueItems] (
    [RowId]            INT          NOT NULL,
    [Token]            VARCHAR (32) NOT NULL,
    [SerialNo]         VARCHAR (50) NOT NULL,
    [BillingRequested] BIT          NULL,
    CONSTRAINT [PK_WfExpiredFinalQueueItems] PRIMARY KEY CLUSTERED ([RowId] ASC)
);

