CREATE TABLE [dbo].[WfFinalQueueParams] (
    [Token]       VARCHAR (32)  NOT NULL,
    [ObjectName]  VARCHAR (50)  NOT NULL,
    [ObjectValue] VARCHAR (MAX) NOT NULL,
    [ObjectType]  VARCHAR (50)  NULL,
    CONSTRAINT [PK_WfFinalQueueParams] PRIMARY KEY CLUSTERED ([Token] ASC, [ObjectName] ASC),
    CONSTRAINT [FK_WfFinalQueueParams_WfFinalQueue] FOREIGN KEY ([Token]) REFERENCES [dbo].[WfFinalQueue] ([Token]) ON DELETE CASCADE ON UPDATE CASCADE
);

