CREATE TABLE [dbo].[StoredProcedureRunInfo] (
    [StoredProcedureName] VARCHAR (100)  NOT NULL,
    [RepeatingErrors]     INT            NOT NULL,
    [AlertAfterErrors]    INT            CONSTRAINT [DF_StoredProcedureRunInfo_AlertAfterErrors] DEFAULT ((0)) NOT NULL,
    [LastRunBeginTime]    DATETIME       NULL,
    [LastRunEndTime]      DATETIME       NULL,
    [LastError]           NVARCHAR (MAX) NULL,
    [LastErrorTime]       DATETIME       NULL,
    CONSTRAINT [PK_StoredProcedureRunInfo] PRIMARY KEY CLUSTERED ([StoredProcedureName] ASC)
);

