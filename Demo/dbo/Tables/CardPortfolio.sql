CREATE TABLE [dbo].[CardPortfolio] (
    [CardPortfolioId] INT           IDENTITY (1, 1) NOT NULL,
    [SSOUserId]       INT           NOT NULL,
    [HolderId]        BIGINT        NOT NULL,
    [Saledeviceid]    INT           NOT NULL,
    [Serialno]        BIGINT        NOT NULL,
    [CrsKey]          VARCHAR (50)  NULL,
    [InsertDate]      DATETIME2 (7) CONSTRAINT [DF_CardPortfolio_InsertDate] DEFAULT (sysdatetime()) NULL,
    CONSTRAINT [PK_tmpPortafoglioTessere] PRIMARY KEY CLUSTERED ([CardPortfolioId] ASC)
);




GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data inserimento', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CardPortfolio', @level2type = N'COLUMN', @level2name = N'InsertDate';

