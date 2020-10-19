CREATE TABLE [dbo].[InvoicesNumbers] (
    [InvoiceNumber] BIGINT NOT NULL,
    [InvoiceYear]   INT    NOT NULL,
    [CompanyId]     INT    CONSTRAINT [DF_InvoicesNumbers_CompanyId] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_InvoicesNumbers] PRIMARY KEY CLUSTERED ([InvoiceNumber] ASC, [InvoiceYear] ASC, [CompanyId] ASC),
    CONSTRAINT [FK_InvoicesNumbers_Companies] FOREIGN KEY ([CompanyId]) REFERENCES [dbo].[Companies] ([Id])
);











