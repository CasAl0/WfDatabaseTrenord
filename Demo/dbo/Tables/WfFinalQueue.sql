CREATE TABLE [dbo].[WfFinalQueue] (
    [Token]          VARCHAR (32)  NOT NULL,
    [ClientId]       INT           NOT NULL,
    [ProductSku]     CHAR (8)      NOT NULL,
    [OrderDate]      DATETIME      NOT NULL,
    [Expiration]     DATETIME      NOT NULL,
    [StateCode]      INT           CONSTRAINT [DF_WfFinalProduct_StateCode] DEFAULT ((0)) NOT NULL,
    [EndWorkflowId]  CHAR (8)      NULL,
    [LegacyOrderId]  VARCHAR (50)  NULL,
    [StoreOrderId]   VARCHAR (50)  NULL,
    [ProductName]    VARCHAR (200) NULL,
    [Description]    VARCHAR (MAX) NULL,
    [UserFirstname]  VARCHAR (200) NULL,
    [UserLastname]   VARCHAR (200) NULL,
    [UserEmail]      VARCHAR (255) NULL,
    [OrderSmsNumber] VARCHAR (255) NULL,
    [ErrorLog]       VARCHAR (MAX) NULL,
    [ReleaseDate]    VARCHAR (50)  NULL,
    [ReleasePlace]   VARCHAR (255) NULL,
    [UserId]         INT           NULL,
    [UserProfile]    VARCHAR (10)  NULL,
    CONSTRAINT [PK_WfFinalQueue] PRIMARY KEY CLUSTERED ([Token] ASC),
    CONSTRAINT [FK_WfFinalQueue_FinalQueueState] FOREIGN KEY ([StateCode]) REFERENCES [dbo].[FinalQueueState] ([StateCode])
);




GO
CREATE NONCLUSTERED INDEX [IX_WfFinalQueue_ClientId_ProductSku]
    ON [dbo].[WfFinalQueue]([ClientId] ASC, [ProductSku] ASC)
    INCLUDE([Token]);


GO
GRANT SELECT
    ON OBJECT::[dbo].[WfFinalQueue] TO [reporting]
    AS [dbo];

