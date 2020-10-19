CREATE TABLE [dbo].[Client_Wf_Template] (
    [ClientId]                INT             NOT NULL,
    [ProductSku]              CHAR (8)        NULL,
    [WorkflowId]              CHAR (8)        NOT NULL,
    [PdfTemplate]             VARCHAR (50)    NULL,
    [SmsTemplate]             VARCHAR (50)    NULL,
    [ConfirmMailTemplateId]   VARCHAR (20)    NULL,
    [WareHouseTemplateId]     VARCHAR (20)    NULL,
    [IsPdfTicket]             BIT             CONSTRAINT [DF_Client_Wf_Template_IsPdfTicket] DEFAULT ((0)) NOT NULL,
    [TariffMapId]             INT             NULL,
    [AvailableVoucherFolder]  NVARCHAR (1000) NULL,
    [ProcessingVoucherFolder] NVARCHAR (1000) NULL,
    [UsedVoucherFolder]       NVARCHAR (1000) NULL,
    [AddVoucherInNewPage]     BIT             CONSTRAINT [DF_Client_Wf_Template_AddVoucherInNewPage] DEFAULT ((0)) NOT NULL,
    [CropVoucher]             BIT             CONSTRAINT [DF_Client_Wf_Template_CropVoucher] DEFAULT ((0)) NOT NULL,
    [QrCodeQuantity]          INT             CONSTRAINT [DF_Client_Wf_Template_QrCodeQuantity] DEFAULT ((0)) NULL,
    CONSTRAINT [FK_Client_Wf_Template_Client] FOREIGN KEY ([ClientId]) REFERENCES [dbo].[Client] ([ClientId]),
    CONSTRAINT [FK_Client_Wf_Template_CP_Tariff] FOREIGN KEY ([TariffMapId]) REFERENCES [dbo].[CP_Tariff] ([TariffMapId]),
    CONSTRAINT [FK_Client_Wf_Template_MailTemplate] FOREIGN KEY ([ConfirmMailTemplateId]) REFERENCES [dbo].[MailTemplate] ([MailTemplateId]),
    CONSTRAINT [FK_Client_Wf_Template_ProductCodes] FOREIGN KEY ([ProductSku]) REFERENCES [dbo].[ProductCodes] ([ProductSku]),
    CONSTRAINT [FK_Client_Wf_Template_Workflows] FOREIGN KEY ([WorkflowId]) REFERENCES [dbo].[Workflows] ([WorkflowId])
);








GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Client_Wf_Template]
    ON [dbo].[Client_Wf_Template]([ClientId] ASC, [ProductSku] ASC, [WorkflowId] ASC, [TariffMapId] ASC);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Percorso fisico del voucher una volta utilizzato', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Client_Wf_Template', @level2type = N'COLUMN', @level2name = N'UsedVoucherFolder';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Riferimento alla tabella dbo.CP_Tariff. Permette di personalizzare a livello di prodotto/tariffa i template, i voucher, le mail e gli sms.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Client_Wf_Template', @level2type = N'COLUMN', @level2name = N'TariffMapId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Percorso fisico del voucher mentre viene utilizzato', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Client_Wf_Template', @level2type = N'COLUMN', @level2name = N'ProcessingVoucherFolder';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Stabilisce se il file va ritagliato', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Client_Wf_Template', @level2type = N'COLUMN', @level2name = N'CropVoucher';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Percorso fisico del voucher da utilizzare', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Client_Wf_Template', @level2type = N'COLUMN', @level2name = N'AvailableVoucherFolder';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Stabilisce se il voucher va inserito in una nuova pagina', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Client_Wf_Template', @level2type = N'COLUMN', @level2name = N'AddVoucherInNewPage';

