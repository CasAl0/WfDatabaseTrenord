CREATE TABLE [dbo].[EInvoiceInfo] (
    [OrderId]     VARCHAR (50)   NOT NULL,
    [ClientId]    INT            NOT NULL,
    [FileName]    VARCHAR (50)   NOT NULL,
    [FileDir]     VARCHAR (500)  NOT NULL,
    [InfocertXml] VARCHAR (MAX)  NOT NULL,
    [CreatedOn]   DATETIME2 (7)  CONSTRAINT [DF_EInvoiceInfo_CreatedOn] DEFAULT (sysdatetime()) NOT NULL,
    [InfocertFtp] INT            CONSTRAINT [DF_EInvoiceInfo_InfocertFtp] DEFAULT ((0)) NOT NULL,
    [ErrorDescr]  VARCHAR (1000) NULL,
    CONSTRAINT [PK_EInvoiceInfo_1] PRIMARY KEY CLUSTERED ([OrderId] ASC, [ClientId] ASC, [FileName] ASC)
);

