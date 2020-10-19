CREATE TABLE [dbo].[WfVatCodes] (
    [VatCodeId]      INT           NOT NULL,
    [VatCode]        VARCHAR (50)  NOT NULL,
    [VatDescription] VARCHAR (250) NOT NULL,
    CONSTRAINT [PK_WfVatCodes] PRIMARY KEY CLUSTERED ([VatCodeId] ASC)
);

