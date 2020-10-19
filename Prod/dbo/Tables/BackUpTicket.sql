CREATE TABLE [dbo].[BackUpTicket] (
    [Id]        INT           IDENTITY (1, 1) NOT NULL,
    [Path]      VARCHAR (500) NOT NULL,
    [FileName]  VARCHAR (200) NOT NULL,
    [CreatedAt] DATETIME2 (7) CONSTRAINT [DF_BackUpTicket_CreatedAt] DEFAULT (sysdatetime()) NULL,
    [CreatedBy] VARCHAR (200) NOT NULL,
    CONSTRAINT [PK_BackUpTicket] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_BackUpTicket]
    ON [dbo].[BackUpTicket]([FileName] ASC);

