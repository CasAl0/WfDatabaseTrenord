CREATE TABLE [dbo].[IntegratiMultipli] (
    [TariffIdPadre]  BIGINT        NOT NULL,
    [TariffIdFiglio] BIGINT        NOT NULL,
    [IdVettore]      VARCHAR (50)  NOT NULL,
    [DescPadre]      VARCHAR (50)  NULL,
    [Boundle]        VARCHAR (50)  NULL,
    [DescFiglio]     VARCHAR (50)  NULL,
    [Destinazione]   VARCHAR (50)  NULL,
    [Km]             FLOAT (53)    NULL,
    [Linea]          FLOAT (53)    NULL,
    [Tratta]         FLOAT (53)    NULL,
    [QuotaVettore]   FLOAT (53)    NULL,
    [TipoQuota]      VARCHAR (50)  NULL,
    [Totale]         FLOAT (53)    NULL,
    [InsertDate]     DATETIME2 (7) CONSTRAINT [DF__Integrati__InsertDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_IntegratiMultipli] PRIMARY KEY CLUSTERED ([TariffIdPadre] ASC, [TariffIdFiglio] ASC, [IdVettore] ASC)
);




GO
CREATE NONCLUSTERED INDEX [IX_IntegratiMultipli_TariffIdPadre_IdVettore_TipoQuota]
    ON [dbo].[IntegratiMultipli]([TariffIdPadre] ASC, [IdVettore] ASC, [TipoQuota] ASC);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data di inserimento del record', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IntegratiMultipli', @level2type = N'COLUMN', @level2name = N'InsertDate';

