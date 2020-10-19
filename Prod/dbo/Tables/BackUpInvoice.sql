CREATE TABLE [dbo].[BackUpInvoice] (
    [Id]        INT           IDENTITY (1, 1) NOT NULL,
    [Path]      VARCHAR (500) NOT NULL,
    [FileName]  VARCHAR (200) NOT NULL,
    [CreatedAt] DATETIME2 (7) CONSTRAINT [DF_BackUpInvoice_CreatedAt] DEFAULT (sysdatetime()) NULL,
    [CreatedBy] VARCHAR (200) NOT NULL,
    CONSTRAINT [PK_BackUpInvoice] PRIMARY KEY CLUSTERED ([Id] ASC)
);

