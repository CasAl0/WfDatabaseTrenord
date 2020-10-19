CREATE TABLE [dbo].[Client] (
    [ClientId]          INT           NOT NULL,
    [ClientDescription] VARCHAR (200) NOT NULL,
    [ClientKey]         VARCHAR (10)  NOT NULL,
    [InvoiceEnabled]    BIT           CONSTRAINT [DF_Client_InvoiceEnabled] DEFAULT ((0)) NOT NULL,
    [WareHouseEnabled]  BIT           CONSTRAINT [DF_Client_WareHouse] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_Client] PRIMARY KEY CLUSTERED ([ClientId] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Specifica se un Client emette fattura/ricevuta fiscale: 0 = NO, 1 = SI. Il default è 0(NO)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Client', @level2type = N'COLUMN', @level2name = N'InvoiceEnabled';

