CREATE TABLE [dbo].[WfExpiredFinalQueueParams] (
    [Token]       VARCHAR (32)  NOT NULL,
    [ObjectName]  VARCHAR (50)  NOT NULL,
    [ObjectValue] VARCHAR (MAX) NOT NULL,
    [ObjectType]  VARCHAR (50)  NULL,
    CONSTRAINT [PK_WfExpiredFinalQueueParams] PRIMARY KEY CLUSTERED ([Token] ASC, [ObjectName] ASC)
);

