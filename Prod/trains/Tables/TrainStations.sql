CREATE TABLE [trains].[TrainStations] (
    [TrainStationId]        INT           IDENTITY (1, 1) NOT NULL,
    [LegacyStationId]       INT           NULL,
    [LegacyStationCode]     VARCHAR (10)  NULL,
    [Description]           VARCHAR (200) NOT NULL,
    [WithdrawalCardStation] BIT           CONSTRAINT [DF_TrainStation_WithdrawalCardStation] DEFAULT ((0)) NOT NULL,
    [LoadStation]           BIT           CONSTRAINT [DF_TrainStation_LoadStation] DEFAULT ((0)) NOT NULL,
    [Valid]                 BIT           CONSTRAINT [DF_TrainStations_Valid] DEFAULT ((1)) NOT NULL,
    [Mxp]                   BIT           CONSTRAINT [DF_TrainStations_Mxp] DEFAULT ((0)) NOT NULL,
    [SEA]                   BIT           CONSTRAINT [DF_TrainStations_SEA_1] DEFAULT ((0)) NOT NULL,
    [MirCode]               NVARCHAR (10) NULL,
    [HafasCode]             NVARCHAR (10) NULL,
    [NFPVersion]            VARCHAR (50)  NULL,
    [OrderExpression]       INT           CONSTRAINT [DF_TrainStations_OrderExpression] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_TrainStation] PRIMARY KEY CLUSTERED ([TrainStationId] ASC)
);



