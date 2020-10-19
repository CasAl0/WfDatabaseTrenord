CREATE TABLE [trains].[Client_Wf_Template] (
    [ClientId]              INT          NOT NULL,
    [ProductSku]            CHAR (8)     NULL,
    [WorkflowId]            CHAR (8)     NOT NULL,
    [PdfTemplate]           VARCHAR (50) NULL,
    [SmsTemplate]           VARCHAR (50) NULL,
    [ConfirmMailTemplateId] VARCHAR (20) NULL,
    [WareHouseTemplateId]   VARCHAR (20) NULL,
    [TariffDetailsId]       INT          NOT NULL,
    [IsPdfTicket]           BIT          CONSTRAINT [DF_Client_Wf_Template_IsPdfTicket] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [FK_Client_Wf_Template_Client] FOREIGN KEY ([ClientId]) REFERENCES [dbo].[Client] ([ClientId]),
    CONSTRAINT [FK_Client_Wf_Template_MailTemplate] FOREIGN KEY ([ConfirmMailTemplateId]) REFERENCES [dbo].[MailTemplate] ([MailTemplateId]),
    CONSTRAINT [FK_Client_Wf_Template_ProductCodes] FOREIGN KEY ([ProductSku]) REFERENCES [dbo].[ProductCodes] ([ProductSku]),
    CONSTRAINT [FK_Client_Wf_Template_TariffDetails] FOREIGN KEY ([TariffDetailsId]) REFERENCES [trains].[TariffDetails] ([TariffDetailsId]),
    CONSTRAINT [FK_Client_Wf_Template_Workflows] FOREIGN KEY ([WorkflowId]) REFERENCES [dbo].[Workflows] ([WorkflowId]),
    CONSTRAINT [IX_Client_Wf_Template] UNIQUE NONCLUSTERED ([ClientId] ASC, [ProductSku] ASC, [WorkflowId] ASC, [TariffDetailsId] ASC)
);

