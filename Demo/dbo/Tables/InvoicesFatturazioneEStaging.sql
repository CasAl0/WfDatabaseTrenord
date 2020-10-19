CREATE TABLE [dbo].[InvoicesFatturazioneEStaging] (
    [OrderId]           VARCHAR (50)   NOT NULL,
    [Recipient]         VARCHAR (500)  NULL,
    [VatNumber]         VARCHAR (50)   NULL,
    [FiscalCode]        VARCHAR (50)   NULL,
    [City]              VARCHAR (100)  NOT NULL,
    [Address]           VARCHAR (4000) NOT NULL,
    [ZipCode]           VARCHAR (50)   NOT NULL,
    [Country]           VARCHAR (100)  NULL,
    [EMail]             VARCHAR (255)  NULL,
    [PdfDateInvoice]    DATETIME       NULL,
    [PdfDateReceipt]    DATETIME       NULL,
    [InvoiceNumber]     VARCHAR (100)  NULL,
    [ReceiptNumber]     VARCHAR (100)  NULL,
    [ClientId]          INT            NOT NULL,
    [TargetCode]        VARCHAR (7)    NULL,
    [FlgElectronicSend] INT            CONSTRAINT [DF_InvoicesFatturazioneEStaging_FlgElectronicSend] DEFAULT ((0)) NULL,
    [Province]          VARCHAR (4)    NULL,
    [PecEmail]          NVARCHAR (300) NULL,
    [TwoLetterIsoCode]  VARCHAR (2)    NOT NULL,
    CONSTRAINT [PK_InvoicesFatturazioneEStaging] PRIMARY KEY CLUSTERED ([OrderId] ASC, [ClientId] ASC)
);

