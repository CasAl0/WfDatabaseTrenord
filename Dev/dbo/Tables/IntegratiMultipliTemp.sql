CREATE TABLE [dbo].[IntegratiMultipliTemp] (
    [TariffIdPadre]  BIGINT       NOT NULL,
    [TariffIdFiglio] BIGINT       NOT NULL,
    [IdVettore]      VARCHAR (50) NOT NULL,
    [DescPadre]      VARCHAR (50) NULL,
    [Boundle]        VARCHAR (50) NULL,
    [DescFiglio]     VARCHAR (50) NULL,
    [Destinazione]   VARCHAR (50) NULL,
    [Km]             FLOAT (53)   NULL,
    [Linea]          FLOAT (53)   NULL,
    [Tratta]         FLOAT (53)   NULL,
    [QuotaVettore]   FLOAT (53)   NULL,
    [TipoQuota]      VARCHAR (50) NULL,
    [Totale]         FLOAT (53)   NULL,
    CONSTRAINT [PK_IntegratiMultipliTemp] PRIMARY KEY CLUSTERED ([TariffIdPadre] ASC, [TariffIdFiglio] ASC, [IdVettore] ASC)
);

