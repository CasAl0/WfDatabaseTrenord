CREATE TABLE [history].[Mail] (
    [IdMail]         INT           NOT NULL,
    [IsHtml]         BIT           NOT NULL,
    [FromAddress]    VARCHAR (255) NOT NULL,
    [FromName]       VARCHAR (255) NULL,
    [ToAddress]      VARCHAR (255) NOT NULL,
    [ToName]         VARCHAR (255) NULL,
    [ReplyToAddress] VARCHAR (255) NULL,
    [Subject]        VARCHAR (255) NOT NULL,
    [Body]           VARCHAR (MAX) NOT NULL,
    [CreationDate]   DATETIME      NULL,
    [Status]         CHAR (1)      NOT NULL,
    [ErrorMessage]   VARCHAR (255) NULL,
    [Attachment]     VARCHAR (255) NULL,
    [SentDate]       DATETIME      NULL
);

