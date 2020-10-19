CREATE TABLE [dbo].[BackUpReceipt] (
    [Id]        INT           IDENTITY (1, 1) NOT NULL,
    [Path]      VARCHAR (500) NOT NULL,
    [FileName]  VARCHAR (200) NOT NULL,
    [CreatedAt] DATETIME2 (7) CONSTRAINT [DF_BackUpReceipt_CreatedAt] DEFAULT (sysdatetime()) NULL,
    [CreatedBy] VARCHAR (200) NOT NULL,
    CONSTRAINT [PK_BackUpReceipt] PRIMARY KEY CLUSTERED ([Id] ASC)
);

