CREATE TABLE [dbo].[WfStartErrors] (
    [LogId]             INT           IDENTITY (1, 1) NOT NULL,
    [LogDate]           DATETIME      NOT NULL,
    [Token]             VARCHAR (32)  NULL,
    [ClientKey]         VARCHAR (20)  NULL,
    [ProductServiceKey] CHAR (8)      NULL,
    [FlgProduct]        BIT           NULL,
    [Userprofile]       CHAR (4)      NULL,
    [IP]                VARCHAR (150) NULL,
    [Reason]            VARCHAR (50)  NOT NULL
);

