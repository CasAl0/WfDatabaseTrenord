CREATE TABLE [dbo].[WfFinalQueueTickets] (
    [Token]             VARCHAR (32) NOT NULL,
    [StoreOrderId]      VARCHAR (50) NOT NULL,
    [LegacyOrderId]     INT          NOT NULL,
    [SerialNo]          VARCHAR (50) NOT NULL,
    [Available]         BIT          NOT NULL,
    [PNR]               VARCHAR (8)  NOT NULL,
    [CounterfoilPNR]    VARCHAR (8)  NOT NULL,
    [LastChangeDate]    DATETIME     CONSTRAINT [DF_WfFinalQueueTickets_LastChangeDate] DEFAULT (getdate()) NOT NULL,
    [SingleTicketToken] VARCHAR (32) NULL,
    [SSOUserId]         INT          NOT NULL,
    [TariffDetailsId]   INT          NOT NULL,
    CONSTRAINT [PK_WfTickets] PRIMARY KEY CLUSTERED ([Token] ASC, [StoreOrderId] ASC, [LegacyOrderId] ASC, [SerialNo] ASC)
);



