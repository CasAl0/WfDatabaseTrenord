CREATE TABLE [dbo].[Tariff] (
    [TariffId]                 INT             NOT NULL,
    [TariffKey]                VARCHAR (10)    NOT NULL,
    [TariffDescription]        VARCHAR (100)   NOT NULL,
    [TariffDescription_en]     VARCHAR (100)   NULL,
    [FixedPrice]               DECIMAL (18, 2) NULL,
    [Units]                    INT             NULL,
    [UnitFixedPrice]           DECIMAL (18, 2) NULL,
    [UnitTariffDescription]    VARCHAR (100)   NULL,
    [UnitTariffDescription_en] VARCHAR (100)   NULL,
    [Valid]                    BIT             CONSTRAINT [DF_Tariff_Valid] DEFAULT ((1)) NOT NULL,
    [SpecialComposition]       BIT             CONSTRAINT [DF_Tariff_SpecialComposition] DEFAULT ((0)) NOT NULL,
    [DefaultQuantity]          INT             CONSTRAINT [DF_Tariff_DefaultQuantity] DEFAULT ((0)) NOT NULL,
    [MinimumQuantity]          INT             CONSTRAINT [DF_Tariff_MinimumQuantity] DEFAULT ((1)) NOT NULL,
    [MaximumQuantity]          INT             CONSTRAINT [DF_Tariff_MaximumQuantity] DEFAULT ((999)) NOT NULL,
    [StepQuantity]             INT             CONSTRAINT [DF_Tariff_StepQuantity] DEFAULT ((1)) NOT NULL,
    [Origin]                   VARCHAR (50)    NULL,
    [Destination]              VARCHAR (50)    NULL,
    [NumTariffa]               INT             NULL,
    [Type]                     INT             NULL,
    [Stibm]                    BIT             CONSTRAINT [DF_Tariff_Stibm] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_Tariff_TariffId] PRIMARY KEY CLUSTERED ([TariffId] ASC),
    CONSTRAINT [CK_Tariff_Type] CHECK ([Type]=(1) OR [Type]=(2)),
    CONSTRAINT [UK_Tariff_TariffKey] UNIQUE NONCLUSTERED ([TariffKey] ASC)
);












GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'1 = Ticket ; 2 = Abbonamento', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Tariff', @level2type = N'COLUMN', @level2name = N'Type';

