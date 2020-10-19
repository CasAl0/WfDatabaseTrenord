CREATE TABLE [dbo].[WfFinalQueueItems] (
    [RowId]            INT          IDENTITY (1, 1) NOT NULL,
    [Token]            VARCHAR (32) NOT NULL,
    [SerialNo]         VARCHAR (50) NOT NULL,
    [BillingRequested] BIT          CONSTRAINT [DF_WfFinalQueueItems_BillingRequested] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_WfFinalQueueItems] PRIMARY KEY CLUSTERED ([RowId] ASC)
);

