CREATE TABLE [dbo].[WfSession] (
    [RecordId]     INT           IDENTITY (1, 1) NOT NULL,
    [Token]        VARCHAR (32)  NOT NULL,
    [ObjectName]   VARCHAR (50)  NOT NULL,
    [ObjectBase64] VARCHAR (MAX) NULL,
    [ObjectType]   VARCHAR (50)  NULL,
    [StepNr]       INT           CONSTRAINT [DF_WfSession_StepNr] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_WfSession] PRIMARY KEY CLUSTERED ([RecordId] ASC),
    CONSTRAINT [FK_WfSession_WfToken] FOREIGN KEY ([Token]) REFERENCES [dbo].[WfToken] ([Token]) ON DELETE CASCADE NOT FOR REPLICATION,
    CONSTRAINT [IX_WfSession] UNIQUE NONCLUSTERED ([Token] ASC, [ObjectName] ASC)
);

