CREATE TABLE [sbme].[TariffPrices] (
    [TariffKey]      VARCHAR (10)    NOT NULL,
    [Distance]       INT             NOT NULL,
    [PassengerClass] INT             NOT NULL,
    [Price]          DECIMAL (18, 2) NOT NULL,
    [InsertDate]     DATETIME        CONSTRAINT [DF_TariffPrices_InsertDate] DEFAULT (getdate()) NOT NULL,
    [ValidFrom]      DATETIME        NULL,
    [ValidTo]        DATETIME        NULL,
    CONSTRAINT [PK_TariffPrices] PRIMARY KEY CLUSTERED ([TariffKey] ASC, [Distance] ASC, [PassengerClass] ASC),
    CONSTRAINT [FK_TariffPrices_Tariffs] FOREIGN KEY ([TariffKey]) REFERENCES [sbme].[Tariffs] ([TariffKey])
);

