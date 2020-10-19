CREATE TABLE [dbo].[MailTemplate] (
    [MailTemplateId]          VARCHAR (20)  NOT NULL,
    [MailTemplateDescription] VARCHAR (255) NULL,
    [Subject]                 VARCHAR (255) NULL,
    [Body]                    VARCHAR (MAX) NULL,
    [IsHtml]                  BIT           NULL,
    [ToAddress]               VARCHAR (255) NULL,
    [ToName]                  VARCHAR (255) NULL,
    [CcnAddress]              VARCHAR (255) NULL,
    [CcnName]                 VARCHAR (255) NULL,
    [FromAddress]             VARCHAR (255) NULL,
    [FromName]                VARCHAR (255) NULL,
    CONSTRAINT [PK_MailTemplate] PRIMARY KEY CLUSTERED ([MailTemplateId] ASC)
);





