CREATE TABLE [dbo].[Mail] (
    [IdMail]         INT           IDENTITY (1, 1) NOT NULL,
    [IsHtml]         BIT           CONSTRAINT [DF_Mail_IsHtml] DEFAULT ((0)) NOT NULL,
    [FromAddress]    VARCHAR (255) NOT NULL,
    [FromName]       VARCHAR (255) NULL,
    [ToAddress]      VARCHAR (255) NOT NULL,
    [ToName]         VARCHAR (255) NULL,
    [ReplyToAddress] VARCHAR (255) NULL,
    [Subject]        VARCHAR (255) NOT NULL,
    [Body]           VARCHAR (MAX) NOT NULL,
    [CreationDate]   DATETIME      NULL,
    [Status]         CHAR (1)      CONSTRAINT [DF_Mail_Status] DEFAULT ('0') NOT NULL,
    [ErrorMessage]   VARCHAR (255) NULL,
    [Attachment]     VARCHAR (255) NULL,
    [SentDate]       DATETIME      NULL,
    [CcnAddress]     VARCHAR (255) NULL,
    [CcnName]        VARCHAR (255) NULL,
    [UserProfile]    VARCHAR (10)  NULL,
    CONSTRAINT [PK_Mail] PRIMARY KEY CLUSTERED ([IdMail] ASC)
);





