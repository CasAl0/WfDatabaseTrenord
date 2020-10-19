CREATE TABLE [dbo].[WfStartTraces] (
    [TraceId]    BIGINT        IDENTITY (1, 1) NOT NULL,
    [Token]      VARCHAR (32)  NOT NULL,
    [ServerName] VARCHAR (150) NOT NULL,
    [TraceDate]  DATETIME      NOT NULL,
    [RemoteInfo] VARCHAR (300) NULL,
    CONSTRAINT [PK_WfStartTraces] PRIMARY KEY CLUSTERED ([TraceId] ASC)
);

