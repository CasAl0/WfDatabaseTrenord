CREATE TABLE [dbo].[Companies] (
    [Id]                    INT             NOT NULL,
    [Name]                  NVARCHAR (200)  NOT NULL,
    [Website]               NVARCHAR (200)  NOT NULL,
    [PhoneNumber]           NVARCHAR (200)  NOT NULL,
    [Email]                 NVARCHAR (200)  NOT NULL,
    [InvoiceHeaderLogo]     NVARCHAR (2000) NOT NULL,
    [InvoiceFooterLogo]     NVARCHAR (2000) NOT NULL,
    [InvoiceLeftFooter]     NVARCHAR (2000) NOT NULL,
    [InvoiceRightFooter]    NVARCHAR (2000) NOT NULL,
    [ReceiptMailTemplateId] VARCHAR (20)    NOT NULL,
    [InvoiceMailTemplateId] VARCHAR (20)    NOT NULL,
    [ReceiptPath]           NVARCHAR (200)  NOT NULL,
    [InvoicePath]           NVARCHAR (200)  NOT NULL,
    [ReceiptPrefixName]     VARCHAR (20)    NOT NULL,
    [InvoicePrefixName]     VARCHAR (20)    NOT NULL,
    CONSTRAINT [PK_Companies] PRIMARY KEY CLUSTERED ([Id] ASC)
);

