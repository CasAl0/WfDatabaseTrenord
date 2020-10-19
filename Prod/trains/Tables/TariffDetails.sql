CREATE TABLE [trains].[TariffDetails] (
    [TariffDetailsId]            INT           NOT NULL,
    [TariffId]                   INT           NOT NULL,
    [PrefixTariffKey]            VARCHAR (50)  NULL,
    [Description]                VARCHAR (100) NULL,
    [Description_en]             VARCHAR (100) NULL,
    [PassengerClass]             VARCHAR (5)   NULL,
    [GatewayId]                  INT           CONSTRAINT [DF_TariffDetails_GatewayId] DEFAULT ((0)) NOT NULL,
    [TariffValidityId]           INT           NULL,
    [TariffCategory]             VARCHAR (10)  NULL,
    [StationFilter]              VARCHAR (50)  NULL,
    [LimitLoadDays]              INT           NULL,
    [ContractTravelTypeId]       INT           NULL,
    [ProvinceCodeFilter]         VARCHAR (50)  NULL,
    [UnitTariffCategory]         VARCHAR (10)  NULL,
    [OriginLegacyStationId]      INT           NOT NULL,
    [OriginDescription]          NVARCHAR (50) NOT NULL,
    [DestinationLegacyStationId] INT           NOT NULL,
    [DestinationDescription]     NVARCHAR (50) NOT NULL,
    [OrderExpression]            INT           NOT NULL,
    [CheckAvailableDays]         BIT           CONSTRAINT [DF_TariffDetails_CheckAvailableDays] DEFAULT ((0)) NOT NULL,
    [HolidayTariffDetailsId]     INT           NULL,
    [FixedPeopleNumber]          INT           NULL,
    [JustOnePNR]                 BIT           CONSTRAINT [DF_TariffDetails_JustOnePNR] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_TariffAlternatives] PRIMARY KEY CLUSTERED ([TariffDetailsId] ASC),
    CONSTRAINT [FK_TariffDetails_ContractTravelTypes] FOREIGN KEY ([ContractTravelTypeId]) REFERENCES [dbo].[ContractTravelTypes] ([ContractTravelTypeId]),
    CONSTRAINT [FK_TariffDetails_Gateways] FOREIGN KEY ([GatewayId]) REFERENCES [dbo].[Gateways] ([GatewayId]),
    CONSTRAINT [FK_TariffDetails_Tariff] FOREIGN KEY ([TariffId]) REFERENCES [dbo].[Tariff] ([TariffId])
);











